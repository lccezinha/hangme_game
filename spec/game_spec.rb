require 'spec_helper'
require 'game'

describe Game do
  # Definindo colaboradores p/ o Game
  let(:word_raffler) { double('word raffler').as_null_object }
  subject(:game) { Game.new  word_raffler }

  context '#ended?' do
    it 'returns false when the game just started' do
      expect(game).not_to be_ended
    end
  end

  context '#guess_letter' do
    it { expect(game.guessed_letters).to eq([]) }

    it 'save the guessed_letters' do
      game.raffled_word = 'slayer'

      expect {
        game.guess_letter('a')
      }.to change { game.guessed_letters }.from([]).to(['a'])
    end

    it 'does not save guessed_letters more than once' do
      game.raffled_word = 'slayer'
      game.guess_letter('a')

      expect {
        game.guess_letter('a')
      }.not_to change { game.guessed_letters }.from(['a'])
    end

    it 'return the guessd_letter' do
      game.raffled_word = 'slayer'
      game.guess_letter('a')

      expect(game.guessed_letters).to eq ['a']
    end

    it 'return true if the raffled_word contains the guessd_letter word' do
      game.raffled_word = 'slayer'
      expect(game.guess_letter('a')).to be_true
    end

    it 'return false if the raffled_word does not contains the guessd_letter word' do
      game.raffled_word = 'korn'
      expect(game.guess_letter('a')).to be_false
    end

    it 'return false if the letter is blank' do
      game.raffled_word = 'korn'

      expect(game.guess_letter("")).to be_false
      expect(game.guess_letter(" ")).to be_false
    end
  end

  context '#raffle' do
    it 'ruffled a word with the size' do
      expect(word_raffler).to receive(:raffle).with(6)
      game.raffle(6)
    end

    it 'change stage from :inital to :word_raffled' do
      allow(word_raffler).to receive(:raffle).and_return('slayer')

      expect {
        game.raffle(6)
      }.to change { game.state }.from(:initial).to(:word_raffled)
    end

    it 'do not change de :initial when can not be raffled' do
      allow(word_raffler).to receive(:raffle).and_return(nil)

      game.raffle(6)
      expect(game.state).to eql(:initial)
    end

    it 'save raffled word' do
      raffled_word = 'megadeth'
      allow(word_raffler).to receive(:raffle).and_return(raffled_word)

      game.raffle(3)
      expect(game.raffled_word).to eq(raffled_word)
    end
  end

  context '#finish' do
    it do
      game.finish
      expect(game).to be_ended
    end
  end

  context 'state machine' do
    context 'when start' do
      it { expect(game.state).to eql(:initial) }
    end
  end

end