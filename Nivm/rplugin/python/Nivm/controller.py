from threading import Thread
from Queue import Queue, Empty, Full
from .vim_buffers import VimBuffers
from .session import Session

class EventLoopError(Exception):
  pass

class Controller(Thread):
  def __init__(self, vimx):
    self._sink = open('/dev/null')

    self.in_queue = Queue(maxsize=2)
    self.out_queue = Queue(maxsize=1)

    self.vimx = vimx

    self._target = None
    self._process = None
    self._num_bps = 0
    super(Controller, self).__init__()

  def safe_call(self, method, args=[], sync=False, timeout=None):
    """ (thread-safe) Call `method` with `args`. If `sync` is True, wait for
        `method` to complete and return its value. If timeout is set and non-
        negative, and the `method` did not complete within `timeout` seconds,
        an EventLoopError is raised!
    """
    if self.out_queue.full(): # garbage
      self.out_queue.get() # clean

    try:
      self.in_queue.put((method, args, sync), block=False)
      self._trx.BroadcastEvent(interrupt)
      if sync:
        return self.out_queue.get(block=True, timeout=timeout)
    except Empty:
      raise EventLoopError("Timed out!")
    except Full:
      self.logger.critical("Event loop thread is probably dead!")
      raise EventLoopError("Dead event loop!")
  def safe_exit(self):
    self.join()

  def run(self):
    """ This thread's event loop. """
    import traceback
    to_count = 0
    while True:
      event = lldb.SBEvent()

      if self._rcx.WaitForEvent(30, event): # 30 second timeout

        def event_matches(broadcaster, skip=True):
          if event.BroadcasterMatchesRef(broadcaster):
            if skip:
              while self._rcx.GetNextEventForBroadcaster(broadcaster, event):
                pass
            return True
          return False

        if event_matches(self._trx, skip=False):
          try:
            method, args, sync = self.in_queue.get(block=False)
            if method is None:
              break
            self.logger.info('Calling %s with %s' % (method.func_name, repr(args)))
            ret = method(*args)
            if sync:
              self.out_queue.put(ret, block=False)
          except Exception:
            self.logger.critical(traceback.format_exc())

        elif event_matches(self._process.broadcaster):
          # Dump stdout and stderr to logs buffer
          while True:
            out = self._process.GetSTDOUT(256)
            out += self._process.GetSTDERR(256)
            if len(out) == 0:
              break
            n_lines = self.buffers.logs_append(out)
            if n_lines == 0:
              self._proc_cur_line_len += len(out)
            else:
              self._proc_cur_line_len = 0
              self._proc_lines_count += n_lines
            if self._proc_cur_line_len > 8192 or self._proc_lines_count > 2048:
              # detect and stop/kill insane process
              if self._process.state == lldb.eStateStopped:
                pass
              elif self._proc_sigstop_count > 7:
                self._process.Kill()
                self.buffers.logs_append(u'\u2717SIGSTOP limit exceeded! Sent SIGKILL!\n')
              else:
                self._process.SendAsyncInterrupt()
                self._proc_sigstop_count += 1
                self.buffers.logs_append(u'\u2717Output limits exceeded! Sent SIGSTOP!\n')
              break
          # end of dump while
          self.update_buffers()

      else: # Timed out
        to_count += 1
        if to_count > 172800: # in case WaitForEvent() does not wait!
          self.logger.critical('Broke the loop barrier!')
          break
    # end of event-loop while

    self._dbg.Terminate()
    self._dbg = None
    self._sink.close()
    self.logger.info('Terminated!')
