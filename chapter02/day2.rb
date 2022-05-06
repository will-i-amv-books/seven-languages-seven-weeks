######################
## Day 2
######################

###########
## Defining Functions

# There's no need to define functions inside a class

def tell_the_truth
	puts true
end

tell_the_truth

###########
## Arrays

# Arrays are Ruby’s workhorse ordered collection.

animals = ['lions', 'tigers', 'bears']
puts animals

# Accessing array elements

puts animals[0] # First element
puts animals[2] # Last element
puts animals[10] # Non existing element prints Nil
puts animals[-1] # Last element again
puts animals[0..1] # First 2 elements

puts (0..1).class 

# Arrays can hold any type:

a = []
a[0] = 0
puts a

# Arrays are objects too:

puts [1].class
puts [1].methods.include?('[]')

# Arrays don’t need to be homogeneous.

a = []

a[0] = 'zero'
a[1] = 1
a[2] = ['two', 'things']
puts a

# Multidimensional arrays are just arrays of arrays

a = [[1, 2, 3], [10, 20, 30], [40, 50, 60]]
puts a[0][0]
puts a[1][2]

# Arrays also have the standard push and pop methods

a = [1, 2, 3]

puts '----------'
puts a

a.pop
puts '----------'
puts a

a.pop
puts '----------'
puts a

###########
## Hashes

# A hash is a bunch of key-value pairs:

numbers = {'one' => 1, 'two' => 2}
puts numbers['one']
puts numbers['two']

# Hash keys can be symbols (words preceded with ':')

stuff = {:array => [1, 2, 3], :string => 'Hi, mom!'}

puts stuff[:string]

# Two strings with the same value are distinct object with distinct identity,
# but two symbols with the same value are the same object with the same identity

puts 'string'.object_id == 'string'.object_id

puts :string.object_id == :string.object_id

# Hashes show up in unusual circumstances. 
# For example, Ruby does not support named parameters, 
# but you can simulate them with a hash:

def tell_the_truth(options={})
	if options[:profession] == :lawyer
		puts 'it could be believed that this is almost certainly not false.'
	else
		puts true
	end
end

tell_the_truth
tell_the_truth :profession => :lawyer # No need to type in the braces

###########
## Code blocks and yield

# A code block is a function without a name

3.times {puts 'hiya there, kiddo'}

# Code blocks can take one or more parameters:

animals = ['lions and ', 'tigers and', 'bears', 'oh my']
animals.each {|a| puts a}

# A custom implementation of the times method

class Fixnum
	def my_times
		i = self
		while i > 0
			i = i - 1
			yield
		end
	end
end

3.my_times {puts 'mangy moose'}

# Blocks can also be first-class parameters.

def call_block(&block)
	block.call
end

def pass_block(&block)
	call_block(&block)
end

pass_block {puts 'Hello, block'}

# Delaying execution with blocks

execute_at_noon {puts 'Beep beep... time to get up'}

# Conditionally execute something with blocks

def in_case_of_emergency
	yield if emergency?
end

def in_case_of_emergency do
	use_credit_card
	panic
end

# Enforcing policy with blocks

def within_a_transaction
	begin_transaction
	yield
	end_transaction
end

within_a_transaction do
	things_that
	must_happen_together
end

###########
## Classes

# Unlike other languages, a Ruby class can inherit 
# from only one parent, called a superclass. 

puts 4.class
puts 4.class.superclass
puts 4.class.superclass.superclass
puts 4.class.superclass.superclass.superclass
puts 4.class.superclass.superclass.superclass.superclass

# Implementing a simple tree with a class

class Tree
	attr_accessor :children, :node_name

	def initialize(name, children=[])
		@node_name = name
		@children = children
	end

	def visit(&block)
		block.call self
	end

	def visit_all(&block) # A recursive method
		visit &block
		children.each {|c| c.visit_all &block}
	end
end

ruby_tree = Tree.new(
	"Ruby",
	[
		Tree.new("Reia"),
		Tree.new("MacRuby")
	]
)
puts "Visiting a node"
ruby_tree.visit {|node| puts node.node_name}

puts
puts "visiting entire tree"
ruby_tree.visit_all {|node| puts node.node_name}

###########
## Mixins

# A Module which adds a to_f method to an arbitrary class

module ToFile
	def filename
		"object_#{self.object_id}.txt"
	end
	
	def to_f
		File.open(filename, 'w') {|f| f.write(to_s)}
	end
end

# A class which uses the last module ToFile

class Person
	include ToFile
	attr_accessor :name

	def initialize(name)
		@name = name
	end

	def to_s
		name
	end
end

Person.new('matz').to_f

###########
## Modules, Enumerable, and Sets

# The most critical mixins are the enumerable and comparable mixins. 

# A class wanting to be comparable must implement <=>
# ( a <=> b returns -1 if b is greater, 1 if a is greater, and 0 otherwise)

puts 'begin' <=> 'end'
puts 'same' <=> 'same'
puts 'end' <=> 'begin'

# A class wanting to be enumerable must implement the 'each' method,
# such as the Array class

a = [5, 3, 4, 1]
puts a.sort
puts a.any? {|i| i > 6}
puts a.any? {|i| i > 4}
puts a.all? {|i| i > 4}
puts a.all? {|i| i > 0}
puts a.collect {|i| i * 2}
puts a.select {|i| i % 2 == 0 } # even
puts a.select {|i| i % 2 == 1 } # odd
puts a.max
puts a.member?(2)

# You can do reducing operations on arrays with 'inject'

a = [5, 3, 4, 1]
puts a.inject(0) {|sum, i| sum + i}
puts a.inject {|sum, i| sum + i}
puts a.inject {|product, i| product * i}


a.inject(0) do |sum, i|
	puts "sum: #{sum} i: #{i} sum + i: #{sum + i}"
	sum + i
end

###########
## Exercises for Day 2

"""
Find out how to access files with and without code blocks. 
What is the benefit of the code block?
"""

# Accessing files without code blocks

file = File.open("myfile.txt", "w+")
file.puts "Foo Bar Foo Bar Foo Bar Foo Bar"
file.close

# Accessing files with code blocks (more readable and less error-prone)

File.open("myfile.txt", "w+") {
	|file| file.puts "Foo Bar Foo Bar Foo Bar Foo Bar"
}

puts IO.read("tmp.txt")
puts IO.read("tmp2.txt")

"""
How would you translate a hash to an array? Can you translate arrays to hashes?
Can you iterate through a hash?
"""

# Hash to array

my_hash = {'a'=>1, 'b'=>2,'c'=>3,}
my_array = my_hash.to_a
puts my_array

# Array to hash

my_array = ['a', 'b', 'c']
my_hash = my_array.map.with_index{ |x, i| [i, x] }.to_h
puts my_hash

# Hashes can be iterated as follows

my_hash = {"a" => 1, "b" => 2}
my_hash.each do |key, value|
	puts "#{key} = #{value}"
end

"""
You can use Ruby arrays as stacks. What other common data structures do arrays support?
"""

# Queues

my_queue = [].push("1").push("2")
my_queue.unshift("a").unshift("b")
p my_queue
puts my_queue.shift
puts my_queue.shift
puts my_queue.pop
puts my_queue.pop
		
# Bags/sets

my_bag = [1, 2, 3, 3, 4, 5]
p my_bag

my_set = my_bag.uniq
other_set = [3, 5]
p my_set
p my_set & other_set

# Matrixes

my_matrix = [[1,2,3],[4,5,6],[7,8,9]]
p my_matrix
p my_matrix.transpose

"""
Print the contents of an array of sixteen numbers, four numbers at a time, using just each. 
Now, do the same with each_slice in Enumerable.
"""
	
# Using each

arr = (1..16)
for i in (0..3)
	slice = arr.to_a[(i*4)..(i*4 + 3)]
	puts "#{slice}"
end

# Using each_slice

arr = (1..16)
arr.each_slice(4){|x| p x}
		
"""
The Tree class was interesting, but it did not allow you to specify 
a new tree with a clean user interface. 
Let the initializer accept a nested structure with hashes and arrays. 

You should be able to specify a tree like this: 

my_tree = {
	'grandpa' => {
		'dad' => {
			'child 1' => {}, 
			'child 2' => {} 
		}, 
		'uncle' => {
			'child 3' => {}, 
			'child 4' => {} 
		} 
	}
}
"""

class Tree
    attr_accessor :children, :node_name

    def initialize(name, children=[])
        if name.respond_to?('keys') then
            root_node = name.first
            name = root_node[0]
            children = root_node[1]
        end        
        if children.respond_to?('keys') then
            children = children.map {
                |child_name, grandchildren| Tree.new(child_name, grandchildren)
            }
        end
        @node_name = name
        @children = children
    end

    def visit(&block)
        block.call self
    end

    def visit_all(&block)
        visit(&block)
        children.each {|c| c.visit_all(&block)}
    end
end


tree = {
    'grandpa' => {
		'dad' => {
			'child 1' => {}, 
			'child 2' => {}
		}, 
		'uncle' => {
			'child 3' => {}, 
			'child 4' => {}
		} 
	}
}
ruby_tree = Tree.new(tree)
ruby_tree.visit_all{|node| p node.node_name}

"""
Write a simple grep that will print the lines of a file having any occurrences 
of a phrase anywhere in that line. 
You will need to do a simple regular expression match and read lines from a file. 
(This is surprisingly simple in Ruby.) If you want, include line numbers.
"""

def match_phrase(filename, phrase)
    regex = Regexp.new(phrase)
    File.foreach(filename) {
        |line| puts "#{line}" if regex =~ line
    }
end

filename = 'myfile.txt'
phrase = 'This Is Alice'
match_phrase(filename, phrase)
