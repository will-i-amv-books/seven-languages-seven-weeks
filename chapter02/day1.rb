######################
## Day 1
######################

###########
## Using Ruby with the Console

# Hello World

puts 'hello, world'

language = 'Ruby'
puts "hello, #{language}"

###########
## The programming model

# Ruby is a pure object-oriented language, even numbers are:

puts 4

puts 4.class 

puts 4.methods

###########
## Decisions

# Ruby has conditional expressions like most common languages

x = 4
puts x < 5
puts x <= 4
puts x > 4

# Both true and false are first-class objects

puts false.class
puts true.class

# You can conditionally execute code with if, unless and else:

x = 4

puts 'This appears to be false.' unless x == 4 # Prints nil
puts 'This appears to be true.' if x == 4

if x == 4 
	puts 'This appears to be true.' 
end

unless x == 4
	puts 'This appears to be false.'
else
	puts 'This appears to be true.'
end

puts 'This appears to be true.' if not true # Prints nil
puts 'This appears to be true.' if !true

# while and until are similar:

x = 0
x = x + 1 while x < 10
puts x

x = 10
x = x - 1 until x == 1
puts x

x = 0
while x < 10
	x = x + 1
	puts x
end

# You can use values other than true and false as expressions too:

puts 'This appears to be true.' if 1 # Truthy
puts 'This appears to be true.' if 'random string' # Truthy, but throws warning 
puts 'This appears to be true.' if 0 # Truthy (!)
puts 'This appears to be true.' if true # Obviously Truthy
puts 'This appears to be true.' if false # Falsy
puts 'This appears to be true.' if nil # Falsy

# You can use relational operators inside expressions too:

puts true && false
puts true || false
puts false && false
puts true && this_will_cause_an_error # Undefined variable
puts false && this_will_not_cause_an_error # Undefined variable, but evaluates to false nonetheless
puts true || this_will_not_cause_an_error # Undefined variable, but evaluates to true nonetheless
puts true | this_will_cause_an_error # The | executes the whole expression
puts true | false

###########
## Duck Typing

# Ruby is strongly typed (raises an error when types collide):

puts 4 + 'four' # Type error
puts 4.class
puts (4.0).class
puts 4 + 4.0 # Result converted to float

# Ruby is dynamically typed (does type checking at runtime):

def add_them_up
	4 + 'four'
end

add_them_up

# Classes don’t have to inherit from the same parent to be used in the same way. 
# This is an example of Duck Typing

i = 0
a = ['100', 100.0]
while i < 2
	puts a[i].to_i # Convert to integer, no matter if the element is str or float
	i = i + 1
end

###########
## Exercises for Day 1

"""
For the string “Hello, Ruby,” find the indexes of the word 'Ruby'.
"""
string = 'Hello, Ruby'
splitted_string =  string.scan /\w|\s|[,]/

splitted_string.each do |letter|
	if ['R', 'u', 'b', 'y'].include? letter
        puts splitted_string.index(letter)
	end
end

"""
Print your name 10 times.
"""

for number in 0..9 do
   puts 'William'
end 

"""
Print the string 'This is sentence number 1', 
where the number 1 changes from 1 to 10.
"""

for number in 1..10 do
	puts "This is sentence number #{number}"
end 

"""
Run a Ruby program from a file.
"""

rb YOUR_PROGRAM.rb

"""
Bonus problem: 

Write a program that picks a random number. 
Let a player guess the number, telling the player whether the guess is too low or too high.
(Hint: rand(10) will generate a random number from 0 to 9, and
gets will read a string from the keyboard that you can translate to an integer.)
"""

puts "Enter the element you want to guess:"
input_number = gets.chomp.to_i
random_numnber = rand(10)

if (input_number == random_numnber)
	puts "You guessed it!"
elsif (input_number > random_numnber)
	puts "Number too high!"
else
	puts "Number too low!"
end
