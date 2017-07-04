# Simple poker game - Ruby

### Instructions

#### To run the game locally
Clone this repository:
- SSH: `git@github.com:lucymonie/simplest-poker-ruby.git`
- HTTPS: `https://github.com/lucymonie/simplest-poker-ruby.git`

Navigate into the folder: `cd simplest-poker-ruby`
Run: `ruby index.rb`
Open a browser: `localhost:4567`

#### To run the tests
In the terminal, run
- `gem install rspec`
- `bundle install`
- `respec spec/poker_game_tests.rb`

### Notes
This is a simple game based on Poker, in which players are dealt a single hand of cards, and
the player with the highest scoring cards is declared the winner.

#### Scores
The application deals cards to each player, then adds up the value of each hand and declares a
winner (or winners, in the case of a draw). Scores are determined for each hand by summing the face
value of each card (Ace = 1, two through ten on face value), then the following: Jack = 11, Queen = 12,
King = 13.

#### Inputs
The number of players and the number of cards dealt to each player are configurable. The
game prevents an impossible combination of players and cards.

#### User interface
The game has a super simple user interface for the browser. It takes user inputs (number of players, number
of cards) and replies with a comment about which player has won. This is my first try at making a web app using Sinatra.
