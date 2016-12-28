require "erb"
require_relative "game"

class Racker
  def self.call(env)
    new(env).response.finish
  end
   
  def initialize(env)
    @request = Rack::Request.new(env)
    @game = start
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render('index.html.erb'))
    when "/check" then check
    when "/hint" then give_hint
    when "/play_again" then restart
    else 
      Rack::Response.new("Not Found", 404)  
    end
  end

  def render(template)
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

  def mark
    @request.cookies["mark"]
  end

  def guess
    @request.cookies["guess"]
  end

  def check
    guess = @request.params["guess"]
    answer = @game.check(guess)
    Rack::Response.new do |response|
      response.set_cookie("guess", guess)
      response.set_cookie("mark", answer)
      response.redirect("/")
      end
    end
  end