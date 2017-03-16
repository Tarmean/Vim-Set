import logging
import neovim
import re
import CheckHandler
from Manager import Manager

@neovim.plugin
class Main(object):
  def __init__(self, vim):
    self.logger = logging.getLogger(__name__)
    self.fh = logging.FileHandler('nivm.log')
    self.fh.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    self.fh.setFormatter(formatter)

    self.checkHandler = CheckHandler.Placer(vim)

    self.logger.info('starting up')
    self.vim = vim
  @neovim.function('NivmInit')
  def NivmInit(self, args):
    self.vim.command('echo "' +args[0] + ' ' + args[1] + '"')
    self.mang = Manager(args[0], args[1])
  @neovim.function('NivmExecute')
  def NivmExecute(self, args):
    self.vim.command('echo "' +str(args) + '"')
    result = self.mang.execute(args)
    self.vim.command('echo "' + str(result) + '"')
    for entry in result:
      self.vim.command('echo "' + entry + '"')
  @neovim.function('NivmHighlight')
  def NivmHighlight(self, args):
    res = self.mang.execute(['highlight'])
    self.vim.eval('NivmHighlightApply("%s")'%res)
  @neovim.function('NivmCompile')
  def NivmCompile(self, args):
    message = self.mang.execute(['chk'])
    results = self.checkHandler.parseErrors(message)
    self.vim.command("cd %s"%self.mang.p)
    self.vim.call("setqflist", results)

      
  def __del__(self):
    self.mang.kill()
    
# from time import sleep
# n = Nivm(0)
# n.startUp('/home/cyril/vimfiles/Nivm/rplugin/python/Nivm', 'test.nim')
# sleep(2)
# print n.execute('outline')
# from Nivm import *
# m = Main(0)
# m.NivmInit(['/home/cyril/vimfiles/Nivm/rplugin/python/Nivm', 'test.nim'])
# m.

# import neovim 
# import os     
# vim = neovim.attach('socket', path=os.environ['NVIM_LISTEN_ADDRESS'])
# from Nivm import *
# m = Main(vim)
# m.NivmInit(['/home/cyril/vimfiles/Nivm/rplugin/python/Nivm', 'test.nim'])
