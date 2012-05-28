require 'rubygems'
require 'rack'
require File.dirname(__FILE__)+'/zanmai'
require File.dirname(__FILE__)+'/app'

run Zanmai::Application
