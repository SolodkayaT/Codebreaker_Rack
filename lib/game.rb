#module Codebreaker
  class Game
    attr_accessor :tries, :hints, :secret_code, :win
    def initialize
      @secret_code = generate
      @tries = 10
      @hints = 1
      @win = ''
    end

    def generate
      (1..4).map { rand(1..6) }.join
    end

    def check(guess)
      return "Secret code should have only numbers from 1 to 6" if (guess =~ /[1-6]{4}/).nil?
      return "Secret code should have 4 numbers" if (guess.size != 4)
      if @tries == 0 then @win = false
      else @tries -= 1 end
      if guess == @secret_code
        @win = true
        return "++++"
      end
      result = ''
      code = @secret_code.split("")
      answer = guess.split("")
      code.map.with_index do |item, index|
        next unless answer[index] == item
        result <<'+'
        answer[index] = code[index] = nil
      end
      code.compact!
      answer.compact!
      code.each do |item|
        next unless answer.include?(item)
        answer[answer.index(item)] = nil
        result << '-'
      end
      result
    end

    def hint
      if @hints > 0
        @hints -= 1
        return @secret_code.chars.sample
      else
        "You have no hint"
      end
    end
  end