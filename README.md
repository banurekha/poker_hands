# Code Exercise: poker winning for player 1
Find player winning from given list of poker hands

### [Link to the problem](https://projecteuler.net/problem=54)
# Problem
To find How many hands does Player 1 win?

# Solving the problem /Running the script

On the ```master``` branch you will see ruby script `lib/winning_hand.rb`
Execute this script with as
` bundle exec ruby winning_hand.rb p054_poker.txt ` should print number of player 1 winning

# TODO

- Move some methods inside hand_parser into helper module and add more test
- Increase test coverage
- Way to introduce different parser for different data format
- Right now hand and hand parser are together but it can be broken down and can have different parser
- Custom Error and improve exception/error message
- Increase comments and documentation