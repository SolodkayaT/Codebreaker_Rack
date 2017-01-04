require "erb"
require_relative "game"
require 'pry'
require 'csv'
require 'yaml/store'

class Racker
  def self.call(env)
    new(env).response.finish
  end
   
  def initialize(env)
    @request = Rack::Request.new(env)
    @game = start
    @stat = ''
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render(template_file))
    when "/check" then check
    when "/hint" then give_hint
    when "/play_again" then restart
    when "/save" then save_score
    when "/score" then score_page
    else 
      Rack::Response.new("Not Found", 404)  
    end
  end

  def render(template, params = nil)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def start
    @request.session[:game] ||= Game.new
  end

  def restart
    @request.session[:game] = Game.new
    Rack::Response.new do |response|
      response.set_cookie("guess", "")
      response.set_cookie("mark", "")
      response.set_cookie("hint", "")
      response.set_cookie('template', 'game.html.erb')
      response.redirect("/")
    end
  end

  def hint
    @request.cookies["hint"] || ""
  end

  def give_hint
    Rack::Response.new do |response|
      response.set_cookie("hint", @game.hint)
      response.redirect("/")
    end    
  end

  def template_file
    @request.cookies["template"] || 'game.html.erb'
  end

  def mark
    @request.cookies["mark"]
  end

  def guess
    @request.cookies["guess"]
  end

  def check
    guess = @request.params["guess"]
    answer = @game.check(guess)
    if @game.win == true
      template = 'win.html.erb'
    elsif @game.win == false
      template = 'lose.html.erb'
    else
      template = 'game.html.erb'
    end    

    Rack::Response.new do |response|
      response.set_cookie("guess", guess)
      response.set_cookie("mark", answer)
      response.set_cookie("template", template)
      response.redirect("/")
    end
  end

  def save_score
    user = @request.params["user"]
    attempts = 10 - @game.tries
    CSV.open('score.txt', 'a') do |csv|
      csv << [user, attempts, @game.win ==true ? 'win' : 'loose']
    end
    restart
  end

  def show_score
     FileTest::exist?('score.txt') ? CSV.read('score.txt') : []
  end

  def score_page
    Rack::Response.new do |response|
      response.set_cookie("template", 'score.html.erb')
      response.redirect("/")
    end   
  end
end