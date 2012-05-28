get '/' do
  haml :index
end

post '/' do
  Time.now.to_s
end

get '/env' do
  ENV.keys.sort.map{|k|
    "#{k}=#{ENV[k]}"
  }.join("\n")
end
