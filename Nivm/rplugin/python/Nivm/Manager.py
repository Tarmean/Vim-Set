import subprocess
import socket
import neovim

class Manager(object):
  def __init__(self, path, f):
    self.f = f
    self.p = path
    self.port = 6009
    self.server = subprocess.Popen(['nimsuggest', '--v2', '--port:%d'%self.port, f], cwd=path)

  def execute(self, args):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect(('127.0.0.1', self.port))

     
    command = args[0]
    line = 0
    col = 0
    f = self.f
    if len(args) > 1:
      line = args[2]
      col = args[3]
      f = args[1]

    command = "%s %s:%d:%d\n"%(command, f, line, col)
    # print command
    # print len(args)
    s.send(command)
    result = ""
    while True:
        out = s.recv(4096)
        if len(out) == 0 or out == "\r\n": break
        else: result += out

    s.close()
    return result

  def kill(self):
    self.server.terminate()
  def __enter__(self):
    return self
  def __exit__(self, exc_type, exc_value, traceback):
    self.kill()
