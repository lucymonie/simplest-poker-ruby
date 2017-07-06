require 'sinatra'

class Game
	def initialize (num_cards, num_players)
		@num_cards = num_cards
		@num_players = num_players
		# Initial deck with all cards
		@deck = %w{AH 2H 3H 4H 5H 6H 7H 8H 9H XH JH QH KH AC 2C 3C 4C 5C 6C 7C 8C 9C XC JC QC KC AD 2D 3D 4D 5D 6D 7D 8D 9D XD JD QD KD AS 2S 3S 4S 5S 6S 7S 8S 9S XS JS QS KS}
		# Heuristic for measuring the score for each player
		@score = {"A"=>1, "2"=>2, "3"=>3, "4"=>4, "5"=>5, "6"=>6, "7"=>7, "8"=>8, "9"=>9, "X"=>10, "J"=>11, "Q"=>12, "K"=>13}
	end

	attr_reader :num_cards
	attr_reader :num_players
	attr_reader :deck
	attr_reader :score

	# Following are functions related to dealing hands of cards
	# Returns a record of the cards dealt to each player { player => hand (array (strings)) }
	def get_all_cards
		all_hands = Hash.new
		n = 1
		@num_players.times do
			all_hands["player#{n}"] = deal_hand
			n += 1
		end
		all_hands
	end

	# Returns a hand of cards (array (strings))
	def deal_hand
		hand = Array.new
		@num_cards.times do
			card = get_card(get_random_number)
			hand << card
			remove_card_from_deck(card)
		end
		hand
	end

	# Returns a random number based on the current length of the deck
	# Not a pure function as it's based on external state (number of cards in the deck)
	def get_random_number
		random_num = rand(@deck.length)
	end

	# Takes a single argument (number) and returns a card (string) from the deck
	def get_card (random_num)
		@deck[random_num]
	end

	# Takes a card (string). Removes the card that has just been dealt from the deck
	# Not a pure function -> has a side effect
	def remove_card_from_deck (card)
		@deck -= [card]
	end

	# Following are functions related to assigning scores to each hand of cards
	# Takes { player (string) => hands (array (strings)) }
	# Returns { player (string) => score (number) }
	def get_all_scores (all_hands)
		scores = Hash.new
		all_hands.each do |player|
			scores[player[0]] = get_score(player[1])
		end
		scores
	end

	# Takes a hand of cards (array (string)). Returns a score (number) for the hand of cards passed in
	def get_score (cards)
		score = 0
		cards.each do |card|
			measure = card[0]
			score += @score[measure]
		end
		score
	end

	# Following are functions related to determining which player is the winner
	# Takes a hash { player (string) => score (number) }
	# Returns a hash { player (string) => score (number), winning_score (string) => score (number) }
	def get_winning_score (all_scores)
		all_scores_new = all_scores.dup
		winning_score = 0
		all_scores.each do |score|
			if score[1] > winning_score
				winning_score = score[1]
			end
		end
		all_scores_new['winning_score'] = winning_score
		all_scores_new
	end

	# Takes a hash { player (string) => score (number), winning_score (string) => score (number) }
	# Returns a list of winning players (array (string))
	def get_winning_players (all_scores)
		winning_players = Array.new
		all_scores.each do |player|
      if player[1] == all_scores["winning_score"]
				winning_players << player[0]
			end
		end
		winning_players
	end

	# Takes winner list (array (string)). Returns winner message (string)
	def get_winner_message (winner)
		if winner.length == 1
		  return "The winner is #{winner[0]}"
		else
			winner_message = "The winners are: "
		  winner.each do |winner|
			  winner_message += "#{winner}, "
			end
			winner_message.chomp(', ')
		end
	end

end

# Game controller function
# Takes players (number) and cards (number). Returns winner message
def play_game (num_players, num_cards)
	game = Game.new(num_players, num_cards)
	all_hands = game.get_all_cards
	all_scores = game.get_all_scores (all_hands)
	scores_and_winning_score = game.get_winning_score (all_scores)
	winning_players = game.get_winning_players (scores_and_winning_score)
	message = game.get_winner_message(winning_players)
end

# Helper function for number validation (user inputs)
def valid_numbers(num_cards, num_players)
  if (num_cards * num_players > 52 || num_cards < 1 || num_players < 2)
		return false
	else
		return true
	end
end

get '/' do
	erb :form
end

post '/' do
	num_players = params[:players].to_i
	num_cards = params[:cards].to_i
	if valid_numbers(num_players, num_cards)
		message = play_game(num_players, num_cards)
		winner_message = URI.escape(message)
		redirect "/message/#{winner_message}"
	else
		@error = 'Sorry, that combination of players and cards doesn\'t work. Please try again'
		erb :form
	end
end

get '/message/:winner_message' do
	message = params[:winner_message]
	@message = URI.unescape(message)
	erb :index
end
