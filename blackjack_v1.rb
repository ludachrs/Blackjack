#DECK = %w[D1 D2 D3 D4]

SUIT = %w[Hearts Diamonds Clubs Spades]

CARD_VALUE = {"Two" => 2, 
              "Three" => 3,
              "Four" => 4,
              "Five" => 5,
              "Six" => 6,
              "Seven" => 7,
              "Eight" => 8,
              "Nine" => 9,
              "Ten" => 10, 
              "Jack" => 10,
              "Queen" => 10,
              "King" => 10,
              "Ace" => 11} 

def create_new_deck
deck = {}
  SUIT.each do |suit|
    CARD_VALUE.each do |k,v|
    deck[k + " of " + suit] = v
    end
  end
  return deck
end

def display_cards(deck,who)
  if who == "computer"
    hand = deck.each_key.to_a
    puts "The Computer's hand is #{hand}"
  elsif who == "first"
    hand = deck.each_key.to_a
    puts "#{$name} your first card is #{hand}"
  else
    hand = deck.each_key.to_a
    puts "#{$name} your hand is #{hand}"
  end
end

def deal_cards(deck)
    item = $current_deck.keys.to_a.sample
    deck.store("#{item.to_s}", $current_deck[item.to_s])
      if item.include?("Ace")
        display_cards(deck,"player")
        puts "#{$name} would you like to play the Ace as a 1 or an 11?"
        ask = gets.chomp
        if ask == '1'
          deck.each {|k,v| deck["#{item.to_s}"] = 1}
        end
      end
    $current_deck.delete("#{item.to_s}")
    return deck
end

def deal_cards_computer(deck)
    item = $current_deck.keys.to_a.sample
    deck.store("#{item.to_s}", $current_deck[item.to_s])
    $current_deck.delete("#{item.to_s}")
    return deck
end

def play_hand(deck)
  begin
  display_cards(deck,"player")
  puts "#{$name}, do you want to hit or stay (h,s)?"
  input = gets.chomp
    if input == "h"
      deal_cards(deck)
      system 'clear'
      player_hand_total = deck.values.to_a.reduce(:+)
      if player_hand_total > 21
        break
      end
    end
  end while input != "s"
  return deck
end

def computer_play_hand(deck)
  begin
    computer_hand_total = deck.values.to_a.reduce(:+)
    case 
    when computer_hand_total > 21
      break
    when computer_hand_total < 21 && computer_hand_total > 15
      computer = 'done'
    when computer_hand_total < 16
      deal_cards_computer(deck)
    end  
  end until computer == "done"
  return deck
end 

def winner_check(player,computer)
  computer_hand_total = computer.values.to_a.reduce(:+)
  player_hand_total = player.values.to_a.reduce(:+)
  system 'clear'
  case
  when player_hand_total == 21
    display_cards(player,"player")
    puts "#{$name} you got a Blackjack, winner!!!!"
  when player_hand_total > 21
    display_cards(player,"player")
    puts "#{$name} your hand total is #{player_hand_total}." 
    puts "You busted, you lose!"
  when computer_hand_total > 21
    display_cards(player,"player")
    puts "The computer's hand is #{computer} for a total of #{computer_hand_total}."
    puts "The computer busted. #{$name} wins!"
  when computer_hand_total == player_hand_total
    display_cards(player,"player")
    puts "#{$name}'s total is #{player_hand_total}"
    puts "---------------"
    display_cards(computer,"computer")
    puts "The computer's total is #{computer_hand_total}"
    puts "It's a push!"
  when computer_hand_total > player_hand_total
    display_cards(player,"player")
    puts "#{$name}'s total is #{player_hand_total}"
    puts "---------------"
    display_cards(computer,"computer")
    puts "The computer's total is #{computer_hand_total}, Computer Wins!"
  when computer_hand_total < player_hand_total
    display_cards(player,"player")
    puts "#{$name}'s total is #{player_hand_total}"
    puts "---------------"
    display_cards(computer,"computer")
    puts "The computer's total is #{computer_hand_total}, #{$name} wins!!!"
  end
end

$current_deck = {}
$current_deck = create_new_deck

puts "Welcome to Blackjack!"
puts "May I have your name please?"
$name = gets.chomp

begin
  end_game = 'false'
  players_hand = {}
  computers_hand = {}
  # 1st card
  deal_cards(players_hand)
  # show 1st card
  display_cards(players_hand,"first")
  deal_cards(players_hand)
  2.times {deal_cards_computer(computers_hand)}
  play_hand(players_hand)
  computer_play_hand(computers_hand)
  winner_check(players_hand,computers_hand)
  puts "Would you like to play again? (y,n)"
  input = gets.chomp
    if input == 'y'
    end_game = 'false'
    else
    end_game = 'true'
    end
  if $current_deck.length < 8
    $current_deck = create_new_deck
    puts "New Deck"
  end
end until end_game == "true"

puts "#{$name}, thanks for playing!"


