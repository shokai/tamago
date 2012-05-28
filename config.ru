require 'rubygems'
require 'rack'
require File.dirname(__FILE__)+'/tamago'
require File.dirname(__FILE__)+'/app'

run Tamago::Application
