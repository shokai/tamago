# -*- coding: utf-8 -*-
require 'rubygems'
require 'rack'
require 'rack/request'
require 'rack/response'

class Zanmai
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
    else
      body = case req.request_method
             when 'GET'
               '<html><body><form method="POST"><input type="submit" value="現在時刻" /></form></body></html>'
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
