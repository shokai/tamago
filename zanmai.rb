# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'rack/request'
require 'rack/response'
require 'haml'

class Zanmai
  class View
    def self.render(template)
      template = template.read if template.kind_of? File
      template = open("#{ENV['PWD']}/views/#{template}.haml").read if template.kind_of? Symbol
      raise ArgumentError, 'Argument must be instance of File or String.' unless template.kind_of? String
      Haml::Engine.new(template).render
    end
  end
  
  class Application
    def self.call(env)
      req = Rack::Request.new(env)
      puts "[#{req.request_method}] #{req.scheme}://#{req.host_with_port}#{req.path_info}?#{req.query_string}"
      p req.params
      puts req.user_agent
      if req.path_info == '/methods'
        Rack::Response.new{|res|
          req.methods.sort.each do |m|
            res.write "#{m}\n"
          end
          res['Content-Type'] = 'text/plain'
          res.status = 200
        }.finish
      elsif req.path_info == '/env'
        Rack::Response.new{|res|
          ENV.keys.sort.each do |k|
            res.write "#{k}=#{ENV[k]}\n"
          end
          }.finish
      else
        body = case req.request_method
               when 'GET'
                 View.render :index
                 #'<html><body><form method="POST"><input type="submit" value="現在時刻" /></form></body></html>'
               when 'POST'
                 "<html><body>#{Time.now}</body></html>"
               end
        Rack::Response.new { |r|
          r.status = 200
          r['Content-Type'] = 'text/html;charset=utf-8'
          r.write body
        }.finish
      end
    end
  end
end
