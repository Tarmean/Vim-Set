# -*- coding: utf-8 -*-
import re
errorRe = re.compile(r"^(?P<filename>.*)\((?P<lnum>\d+), (?P<col>\d+)\) (?P<type>.).*? (?P<text>.*)$")
class Placer(object):
  def __init__(self, vim):
    self.vim = vim
    self.default_signID = 6000
    self.currentId = 6000
    self.items = []
  def addId(self, item):
    self.currentId += 1
    item[id] = self.currentId

  def parseErrors(self, message):
    result = []
    for line in message.split("\r\n"):
      m = errorRe.match(line)
      if m is None: continue
      result.append(m.groupdict())
    return result

  def deltaErrors(self, errors):
    print errors


  def updateSigns(self, added, removed):
    defaultSigns = {'E':u'✖', 'W':u'⚠', 'M':u'➤', 'I':u'ℹ'}
    for removedItem in removed:
       cmd = 'sign unplace %s file=%s'%(item.id, item.filename)
       self.vim.command(cmd)

    for addedItem in added:
      self.addId(addedItem)
      cmd = 'sign place {addedItem.id} line={addedItem.lnum} name={addedItem.type} file={addedItem.filename}'%(addedItem)
      self.vim.command(cmd)
