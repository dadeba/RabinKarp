#!/usr/bin/python
# -*- coding: utf-8 -*-

# If you have psyco, you can use these two lines.
#import psyco 
#psyco.full() 

class RabinKarp(object):
  ALPHA = 101  # could be any number

  def __init__(self, searchstring):
    self.s = searchstring
    self.m = len(self.s)
    self.a = [RabinKarp.ALPHA ** (self.m - (i + 1)) for i in xrange(0, self.m)]
    self.hsub = self._hash(self.s)

  def _hash(self, s):
    h = 0
    for i in xrange(0, self.m):
      h += ord(s[i]) * self.a[i]
    return h

  def newhash(self, h, s0, si):
    return RabinKarp.ALPHA * (h - ord(s0) * self.a[0]) + ord(si)

  def run(self, text):
    n = len(text)
    if n < self.m:
      return None
    m = self.m
    h = self._hash(text[0:m])
    for i in xrange(0, (n-m)):
      if h == self.hsub and self.s == text[i:(i+m)]:
        return i
      h = self.newhash(h, text[i], text[i+m])
    return None 

if __name__ == '__main__':
  import sys
  if len(sys.argv) != 3:
    print "usage: python rk.py <pattern> <filename>"
    exit()
  pattern = sys.argv[1]
  filename = sys.argv[2].encode('utf-8')
  rk = RabinKarp(pattern)
  for line in open(filename):
    position = rk.run(line)
    if position is not None:
      print line,
