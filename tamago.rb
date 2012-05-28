# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'rack/request'
require 'rack/response'
require 'haml'
require 'tmp_cache'

class Object
  def method_missing(name, *args, &block)
    case name
    when :get, :post, :head, :delete
      path = args[0]
      TmpCache.set("[#{name.to_s.upcase}] #{path}", block)
    end
  end
end

class Tamago
  class View
    def self.render(template)
      template = case true
                 when template.kind_of?(File)
                   template.read
                 when template.kind_of?(Symbol)
                   File.open("#{ENV['PWD']}/views/#{template}.haml").read
                 end
      raise ArgumentError, 'Argument must be instance of File, String or Symbol.' unless template.kind_of? String
      Haml::Engine.new(template).render
    end
  end
  
  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      puts "[#{req.request_method}] #{req.scheme}://#{req.host_with_port}#{req.path_info}?#{req.query_string}"
      p req.params
      puts req.user_agent
      case req.path_info
      when '/env'
        Rack::Response.new{|res|
          ENV.keys.sort.each do |k|
            res.write "#{k}=#{ENV[k]}\n"
          end
        }.finish
      else
        body = TmpCache.get("[#{req.request_method}] #{req.path_info}").call(env)
        Rack::Response.new { |r|
          r.status = 200
          r['Content-Type'] = 'text/html;charset=utf-8'
          r.write body
        }.finish
      end
    end
  end
end
