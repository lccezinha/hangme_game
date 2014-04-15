require_relative 'command_line_ui'
require_relative 'game'
require 'forwardable'

class GameFlow
  extend Forwardable
  delegate :ended? => :@game


  def initialize(game = Game.new, ui = CommandLineUi.new)
    @game = game
    @ui = ui
  end

  def start
    @ui.write 'Bem vindo ao jogo da forca'
  end

  def next_step
    case @game.state
    when :initial then ask_to_raffle_a_word
    when :word_raffled then ask_to_guess_a_word
    end
  end

  private

  def ask_to_guess_a_word
    ask_to_player('Qual a letra ?') do |letter|
      if @game.guess_letter letter
        @ui.write('Você adivinhou uma letra com sucesso.')
        @ui.write(guessed_letters)
      else
        @ui.write("Você errou a letra.")
        missed_parts
      end
    end
  end

  def ask_to_raffle_a_word
    ask_to_player('Qual o tamanho da palavra a ser sorteada?') do |length|
      if @game.raffle(length.to_i)
        @ui.write guessed_letters
      else
        @ui.write error_message
      end
    end
  end

  private

  def guessed_letters
    letters = ''

    @game.raffled_word.each_char do |letter|
      if @game.guessed_letters.include?(letter)
        letters << letter + ' '
      else
        letters << '_ '
      end
    end

    letters.strip!
  end

  def error_message
    message = "Não temos palavras com o tamanho desejado. Qual o tamanho da palavra a ser sorteada?"
    @ui.write message
  end

  def ask_to_player(question)
    @ui.write(question)
    input = @ui.read.strip

    if input.eql? 'fim'
      @game.finish
    else
      yield input.strip
    end
  end

  def missed_parts
    message = 'O boneco da forca perdeu as seguintes partes do corpo: '
    message << @game.missed_parts.join(', ')
    @ui.write message
  end

end
