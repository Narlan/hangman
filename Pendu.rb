require 'colorize'


def clear()
  system "cls" or system "clear"
end


def create_hidden_word(word_to_find)
  word_to_find = word_to_find.split("")
  hidden_word = []
  word_to_find.each {|letter| hidden_word.push("_ ")}
  return hidden_word.join()
end


def letter_in_word_to_find(word_to_find, guess)
  if guess.length > 1
    return false
  end
  return true if word_to_find.count(guess) > 0
end


def update_hidden_word(hidden_word, word_to_find, guess)

  hidden_word = hidden_word.split("")
  word_to_find = word_to_find.split("")
  hidden_word.delete(" ")
  cpt = 0

  for letter in word_to_find

    if letter == guess
      hidden_word[cpt] = guess
    end

    cpt = cpt + 1

  end

  return hidden_word.join(" ")

end


def getting_a_letter(letters_list, lifes, hidden_word, word_to_find)

  guess = ""

  while guess == "" || guess == "\n" || (guess.length != word_to_find.length && guess.length != 1)
    ask_user_to_give_letter(lifes, hidden_word, letters_list, "Suggest a letter or a full word: ", word_to_find)
    guess = gets.downcase.chomp.strip
  end

  while letters_list.include?(guess)
    ask_user_to_give_letter(lifes, hidden_word, letters_list, "You already suggested this letter, try again: ", word_to_find)
    guess = gets.downcase.chomp.strip
  end

  while guess.length > 1 && guess != word_to_find
    lifes = lifes - 1
    letters_list.push(guess)
    ask_user_to_give_letter(lifes, hidden_word, letters_list, "'#{guess}' is not the good word, try again: ", word_to_find)
    guess = gets.downcase.chomp.strip
  end

  letters_list.push(guess)

  return guess, letters_list

end


def ask_user_to_give_letter(lifes, hidden_word, letters_list, prompt, word_to_find)
  clear()
  puts "You have #{lifes} lives: #{hidden_word}"
  print "Suggested: "
  letters_list.each do |letter|
    if letter_in_word_to_find(word_to_find, letter)
      print letter.green + ", "
    else
      print letter.red + ", "
    end
  end
  print "\n#{prompt}"
end


def continue?()
  choice = ""
  print "Do you want to continue? [y/n] "
  choice = gets.chomp.downcase
  unless choice == "y" || choice == "yes"
    exit()
  end
end


while true
  round_running = true
  word_to_find = ""

  while word_to_find == "" || word_to_find == "\n" || word_to_find.split().length == 0
    clear()
    print "Set the word to guess: "
    word_to_find = gets.chomp.downcase
  end

  word_to_find = word_to_find.split()
  word_to_find = word_to_find.join("")
  hidden_word = create_hidden_word(word_to_find)

  lifes = 11
  guess = "nothing_yet"
  letters_list = []

  while round_running

    guess, letters_list = getting_a_letter(letters_list, lifes, hidden_word, word_to_find)

    if letter_in_word_to_find(word_to_find, guess)
      hidden_word = update_hidden_word(hidden_word, word_to_find, guess)
    else
      lifes = lifes - 1
    end

    if guess == word_to_find || hidden_word.count("_") == 0
      clear()
      puts "Congratulation, you won! The word was: #{word_to_find.upcase.green} !"
      continue?()
      round_running = false
    end

    if lifes == 0
      clear()
      puts "You failed! The word was: #{word_to_find.upcase.green} !"
      continue?()
      round_running = false
    end
  end
end
