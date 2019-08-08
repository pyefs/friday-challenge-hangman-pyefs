old_sync = $stdout.sync
$stdout.sync = true
require 'colorize'
require 'tty-prompt'
@prompt = TTY::Prompt.new
@masih = nil
def splash
    puts %Q{
          888                                                           
          888                                                           
          888                                                           
          88888b.  8888b. 88888b.  .d88b. 88888b.d88b.  8888b. 88888b.  
          888 "88b    "88b888 "88bd88P"88b888 "888 "88b    "88b888 "88b 
          888  888.d888888888  888888  888888  888  888.d888888888  888 
          888  888888  888888  888Y88b 888888  888  888888  888888  888 
          888  888"Y888888888  888 "Y88888888  888  888"Y888888888  888 
                                      8888                              
                                  Y8b d88P                              
                                  "Y88P"                               
            }
end
def hgman_msg(num)
  case num
  when '0'
    system("cls")
    puts "-------------------------------------------------------------------------------".colorize(:blue)
    puts
    puts " -> WELCOME TO HANGMAN v1.0 BETA <- ".colorize(:light_black).colorize(:background => :red).center(100)
    splash
    puts "-------------------------------------------------------------------------------".colorize(:blue)
    puts
    puts
  when '1'
    puts "\r\n-> Okay! I'm going to hang myself anyway. Good bye!\r\n"
  when '2'
    puts "\r\n-> Huh?! You don't know how to play this game?"
    puts "\r\n-> Here, help yourself:\r\n"
    puts "-> https://www.wikihow.com/Play-Hangman".colorize(:yellow)
    puts "\r\n\r\n"
  when '3'
    puts "\r\n"
    puts "\r\n\r\nHell Yeah #{@name.colorize(:light_black).colorize(:background => :red)}! You're amazing. Let's play!"
    sleep 1.0
    puts "\r\n\r\nGame is Starting.. Please Wait.."
    sleep 1.0
    puts "\r\n\r\nGenerating words list.." 
end

def selection_screen
  @choices = [
    {  name: 'Play Now', value: 1 },
    {  name: 'How To Play', value: 2 },
    {  name: 'Exit', value: 3 }
  ]
  @choice = @prompt.select("Select an option", @choices)
  sleep 1.5
  if @choice == 3
    hgman_msg(1)
    exit
  elsif @choice == 2
    hgman_msg(2)
    selection_screen
    sleep 0.5
  end
  @name = @prompt.ask("Please enter your name:", required: true, value: "Noob_Player-001")
  hgman_msg(3)
end

#--------------------------------------------------------------------
def wordscan
  @wlist = IO.readlines("x.txt")
  @wrand = rand(0..@wlist.size)
  @wrtemp = @wlist[@wrand].chomp.to_s     
  until @wrtemp.length >= 4
    @wrand = rand(0..@wlist.size)
    @wrtemp = @wlist[@wrand].chomp.to_s
  end
  @ans = @wrtemp
  puts @ans
  @wlist.delete_at(@wrand)
end

def hidden(word)
  word.split("").map do |huruf| @masih.include?(huruf.downcase) ? " _ " : " " + huruf.downcase + " "
    end
  end
  .join("")
end

def betul?(teka)
  @ans.include?(teka)
end
def sudah?(teka)
  @guessed.include?(teka)
end
def kalau_betul(teka)
  @masih = @masih.delete(@teka)
end
def kalah?
  @chance_left <= 0
end
def menang?
  @masih.length == 0
end
def roll_questions
  @chance_left -= 1
  kalah? ? game(lose) : game(show)
  @teka = gets.chomp.upcase 
  sudah?(@teka) ? game(sudahteka) : game(checking)
  !betul?(@teka) ? game(salahteka) : game(correct)
  menang? ? game(win) : game(lose)
end
def add_score(name, wins, loses, round)
  case round
  when 'w'
    @wintotal += 1
  when 'l'
    @losetotal += 1
  end
  #@table.include?(name) 
end

def game(cond)
  case cond
  when 'sudahteka'
    puts "You have ALREADY guessed that character previously!"
    roll_questions
  when 'salahteka'
    puts "Your answer -- #{@teka} -- is wrong lol"
    roll_questions
  when 'correct'
    puts "Yay! You have guessed the right letter!"
  when 'win'
    puts "CONGRATULATIONS! You have guess the word!"
    puts "The answer is -- #{@ans.upcase} --. Well done!"
    add_score(@name, @wintotal, @losetotal, "w")
  when 'lose'
    puts "You have used up all of your chances. TOO BAD!"
    puts
    puts "The answer is -- #{@ans.upcase} --. Can you even..? lol"
    puts "Better luck next time, #{@name.upcase}!"
    add_score(@name, @wintotal, @losetotal, "l")
  when 'show'
    puts
    puts
    puts " ------------------------------------------------------------ ".center(100)
    puts
    puts " #{@hidden(@masih)} ".center(100)
    puts
    puts " '#{ans.length} letters' ".center(100)
    puts " #{chances_left} remaining ".center(100)
    puts
    puts " Previous Guesses: ".center(100)
    puts " #{@guessed.to_a.join(" ").upcase} ".center(100)
    puts
    puts " AVAILABLE LETTERS: ".center(100)
    puts
    puts " #{@remaining.split("").join(" ")}.upcase".center(100)
    puts
    puts " >> Enter 1 letter at a time only ".center(10)
  end
end

def game_init
  @teka = 0
  @chance_left = 10
  @remaining =  "abcdefghijklmnopqrstuvwxyz"
  @semua = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  @ans_s = []  
  @guessed = []

end

hgman_msg(1)
sleep 1.5
selection_screen
game_init
@wordscan
roll_question