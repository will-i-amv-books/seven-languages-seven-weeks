######################
## Day 1
######################

###########
## Breaking the Ice

# Hello World

"Hi ho, Io" print

# Cloning objects is easy

Vehicle := Object clone

# Objects have slots, where a collection of slots is like a hashmap. 
# We assign something to a slot with ':=', and we can refer to each slot with a key

Vehicle description := "Something to take you places"

# Trying to assign a new slot with '=' raises an exception

Vehicle nonexistingSlot = "This won't work."

# We can get the value from a slot by sending the slot's name to the object:

Vehicle description print

#  We can look at the names of all the slots on Vehicle like this:

Vehicle slotNames print

# Every object has a 'type' slot by default

Vehicle type print
Object type print

###########
## Objects, Prototypes, and Inheritance

"""
Given a car that's also a vehicle, how you would model a ferrari object 
that is an instance of a car? (without classes).
"""

# First, let's create a Car object

Car := Vehicle clone
Car slotNames
Car type print

# Then we create a ferrari object, as follows

ferrari := Car clone

# But the last ferrari object is not custom type, 
# instead it's an object of type Car

ferrari type print

# If you wanted ferrari to be a cusotm type, it should begin 
# with an uppercase letter, as follows

Ferrari := Car clone
Ferrari type print

# Notice that 'Ferrari' has slots, but 'ferrari' doesn't.
# So a coding convention rather than a full language feature is usde 
# to distinguish between types and instances

Ferrari slotNames print
ferrari slotNames print

###########
## Methods

# A simple method

method("So, you've come for an argument." println)

# A method is also an object, so you can get its type

method() type

# Since a method is an object, we can assign it to a slot:

Car drive := method("Vroom" println)

# If a slot has a method, invoking the slot invokes the method:

Car drive

# You can get the contents of slots, whether they are variables or methods, 
# as follows:

Car getSlot("drive") print

# If the slot doesn't exist, getSlot will give you your parent's slot:

Car getSlot("type") print

# You can get the prototype of a given object, as follows:

Car proto print

# There's a master namespace called Lobby that contains 
# all the named objects. You can see it as follows

Lobby print

###########
## Lists and Maps

# A list is an ordered collection of objects of any type. 
# Lists are created and modified as follows:

toDos := list("find my car", "find Continuum Transfunctioner")
toDos append("Find a present")
toDos size print

# Lists also convenience methods for math and 
# to deal with the list as other data types, such as stacks:

mylist := list(1, 2, 3, 4)
mylist average print
mylist sum print
mylist at(1) print
mylist append(5) print
mylist pop print
mylist prepend(0) print
list() isEmpty print

# A map is a collection of key-value pairs. 
# Maps are created and modified as follows:

elvis := Map clone
elvis atPut("home", "Graceland") # Add key-value pair
elvis atPut("style", "rock and roll")
elvis at("home") # Show value from key
elvis asObject print  # Convert map to object
elvis asList print # Convert map to list
elvis keys print
elvis size print

###########
## true, false, nil, and singletons

# Conditions are similar to those of other object-oriented languages:

(4 < 5) print
(4 <= 3) print
(true and false) print
(true and true) print
(true or true) print
(true or false) print
(4 < 5 and 6 > 7) print
(true and 6) print
(true and 0) print

# true, false and nil are singletons (Cloning them returns the same value):

true clone print
false clone print
nil clone print

# Custom singletons can be created redefining the 'clone' method, as follows:

Highlander := Object clone
Highlander clone := Highlander

Highlander clone # Now returns itself

# Two clones from a singleton are always equal:

fred := Highlander clone
mike := Highlander clone
(fred == mike) print

# Two clones from Object are not generally equal:

one := Object clone
two := Object clone
(one == two) print

###########
## Exersises for day 1

"""
• Evaluate 1 + 1 and then 1 + 'one'. Is Io strongly typed or weakly typed? Support your answer with code.
"""

# This works fine

result1 := 1 + 1
result1 print

# This raises the following exception:
# Exception: argument 0 to method '+' must be a Number, not a 'Sequence'

result2 := 1 + 'one'
result2 print

# From the last examples, io is strongly typed (operating with incompatible types is illegal).

"""
Is 0 true or false? What about the empty string? Is nil true or false?
Support your answer with code.
"""

# 0 is true:

(0 and true) print

# The empty string is true:

("" and true) print

# nil is false:

(nil and true) print

"""
How can you tell what slots a prototype supports?
"""

# By sending it the 'slotNames' message

YOUR_PROTOTYPE slotNames println  # It will print the list of slots

"""
What is the difference between = (equals), := (colon equals), 
and ::= (colon colon equals)? When would you use each one?
"""

# From iolanguage.com's documentation:
# = Assigns value to slot if it exists, otherwise raises exception 
# := Creates slot, assigns value
# ::= Creates slot, creates setter, assigns value

"""
Run an Io program from a file.
"""

io YOUR_FILE.io

"""
Execute the code in a slot given its name
"""

MyObject := Object clone

MyObject my_method := method("The first method" println) # A single method
MyObject execute_method_by_name := (
    method(name, perform(name)) # A method that accepts another method name and executes it
)
MyObject execute_method_by_name("my_method")
