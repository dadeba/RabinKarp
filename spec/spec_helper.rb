
require 'rubygems'
require 'spec'
require 'rbench'

RACK_ENV = :test

require File.join(File.dirname(__FILE__), '/../lib/rk')

def path(key)
  Pathname(File.join(File.dirname(__FILE__) + "/fixtures/#{key}"))
end

