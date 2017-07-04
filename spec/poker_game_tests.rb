ENV['RACK_ENV'] = 'test'

$:.unshift File.join(File.dirname(__FILE__))
require_relative File.join(File.dirname(__FILE__), "../index")

require 'rspec'
require 'rack/test'

describe 'Simple Poker Game' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "can establish a new game with the correct number of cards and players" do
    game = Game.new(6, 2)
    cards = game.num_cards
    players = game.num_players
    expect(cards).to eq(6)
    expect(players).to eq(2)
  end

  it "can get a random number" do
    game = Game.new(6, 2)
    500.times do
      num = game.get_random_number
      expect(num).to be >= 0
      expect(num).to be <= 52
    end
  end

  it "can get a random card from the deck" do
    game = Game.new(6, 2)
    num = 5
    card = game.get_card(num)
    expect(card).to eq('6H')
  end

  it "can remove the card selected from the deck" do
    game = Game.new(5, 3)
    num = game.get_random_number
    card = game.get_card(num)
    game.remove_card_from_deck(card)
    deck = game.deck
    expect(deck).not_to include(card)
  end

  it "can deal a hand of cards" do
    game = Game.new(5, 2)
    deck_length_before_deal = game.deck.length
    hand = game.deal_hand
    expect(hand.length).to eq(5)
    expect(game.deck.length).to be < deck_length_before_deal
    expect(game.deck.length).to eq(47)
  end

  it "can keep a record of each players hand" do
    game = Game.new(6, 3)
    all_players = game.get_all_cards
    expect(all_players.length).to eq(3)
    expect(all_players["player1"].length).to eq(6)
  end

  it "can give a score based on the cards in a given hand" do
    game = Game.new(2, 6)
    player1 = ["2D", "XC", "4D", "XD", "5S", "QD"]
    score = game.get_score(player1)
    expect(score).to eq(43)
  end

  it "can record scores for each player" do
    game = Game.new(3, 6)
    cards = {"player1"=>["2D", "XC", "4D", "XD", "5S", "QD"], "player2"=>["7H", "5H", "2C", "KD", "9D", "7S"], "player3"=>["3H", "9S", "6D", "6C", "4H", "7C"]}
    scores = game.get_all_scores(cards)
  end

  it "can use the scores to determine the winner or winners" do
    game = Game.new(3, 6)
    cards = {"player1"=>["2D", "XC", "4D", "XD", "5S", "QD"], "player2"=>["7H", "5H", "2C", "KD", "9D", "7S"], "player3"=>["3H", "9S", "6D", "6C", "4H", "7C"]}
    scores = game.get_all_scores(cards)
    winners = game.get_winner(scores)
    expect(winners) =~ ["player1", "player2"]
  end

  # Better way might be to have one function to determine the highest score
  # Then have a function that selects any props that have this score

  it "can play a full game, taking in the number of players and cards" do
    winner_message = play_game(6, 4)
    expect(winner_message).to include('winner')
  end

  it "responds with success" do
    get '/'
    expect(last_response).to be_ok
  end

  it "has a layout file and html" do
    get '/'
    expect(last_response.body).to include("<title>poker game</title>")
  end
end
