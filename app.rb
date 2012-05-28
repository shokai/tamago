get '/' do
  Tamago::View.render :index
end

post '/' do
  Time.now.to_s
end

get '/methods' do
  ENV.keys.sort.map{|k|
    "#{k}=#{ENV[k]}"
  }.join("\n")
end
