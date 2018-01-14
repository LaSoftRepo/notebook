class StaticsController < ApplicationController
  def home
    puts "**************************************"
    puts request.ip
    puts request.remote_ip
    puts "**************************************"
    render 'statics/home'
  end
end
