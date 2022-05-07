######################
## Day 2
######################

###########
## Conditionals and Loops

# An infinite loop (Control+C to break out):

loop("getting dizzy..." print)

# A standard while loop:

i := 1
while(i <= 11, 
    i print; 
    i = i + 1
); # A semicolon concatenates two distinct messages
"This one goes up to 11" print

# The last code implemented as a for loop:

for(i, 1, 11, i print); "This one goes up to 11" print

# The last code, but with step size of 2

for(i, 1, 11, 2, i print); "This one goes up to 11" print

# Examples of conditionals:

if(true, "It is true." print, "It is false." print)

if(false) then("It is true" print) else("It is false" print)

###########
## Operators

# You can see all available operators as follows:

OperatorTable print

# To add the 'xor', we need to add it to 'OperatorTable', as follows:

OperatorTable addOperator("xor", 11)

# Next, we need to implement the xor method on true and false:

true xor := method(bool, if(bool, false, true))
false xor := method(bool, if(bool, true, false))

# Then we can test it:

true xor true print
true xor false print
false xor true print
false xor false print

###########
## Messages

# Let's create a couple of objects: 
# * The postOffice that gets messages 
# * The mailer that delivers them:

postOffice := Object clone
postOffice packageSender := method(call sender)

mailer := Object clone
mailer deliver := method(postOffice packageSender)

# Now, the mailer can deliver a message, as follows:

mailer deliver print

# We can also get the target of the message, as follows:

postOffice messageTarget := method(call target)
postOffice messageTarget print

# We can get the original message name and arguments, as follows:

postOffice messageArgs := method(call message arguments)
postOffice messageName := method(call message name)
postOffice messageArgs("one", 2, :three) print
postOffice messageName print

# We can implement control structures with messages. 
# For example, we can implement 'unless' as follows:

unless := method(
    (
        call sender doMessage(call message argAt(0))
    ) ifFalse(
        call sender doMessage(call message argAt(1))
    ) ifTrue(
        call sender doMessage(call message argAt(2))
    )
)

unless(1 == 2, write("One is not two\n"), write("one is two\n"))

###########
## Reflection

# The following code creates 2 objects and then works its way up 
# the prototype chain with the 'ancestors' method:

Object ancestors := method(
    prototype := self proto
    if(prototype != Object,
        writeln("Slots of ", prototype type, "\n---------------")
        prototype slotNames foreach(slotName, writeln(slotName))
        writeln
        prototype ancestors
    )
)

Animal := Object clone
Animal speak := method("ambiguous animal noise" print)

Duck := Animal clone
Duck speak := method("quack" print)
Duck walk := method("waddle" print)

disco := Duck clone
disco ancestors

###########
## Exersises for day 1

"""
1. A Fibonacci sequence starts with two 1s. Each subsequent number 
is the sum of the two numbers that came before: 1, 1, 2, 3, 5, and so on. 
Write a program to find the nth Fibonacci number. 
As a bonus, solve the problem with recursion and with loops.
"""

"With recursion: \n" print

fib_recur := method(num, 
    if(num <= 1, 
        num, 
        fib_recur(num - 1) + fib_recur(num - 2)
    )
)

fib_recur(0) print
fib_recur(10) print

"With iteration: \n" print

fib_loop := method(num, 
    old := 0
    new := 1
    next := 0
    for(i, num, 1, -1, 
        next = old + new
        old = new
        new = next
    )
    old
)

fib_loop(0) print
fib_loop(10) print

"""
2. How would you change / to return 0 if the denominator is zero?
"""

# Overriding the / method, as follows:

Number my_division := Number getSlot("/")
Number / = method(denom, 
    if(denom == 0, 
        0, 
        self my_division(denom)
    )
)

4 / 2 print
4 / 0 print

"""
3. Write a program to add up all of the numbers in a two-dimensional array.
"""

sum_array := method(array, array flatten reduce(+))
sum_array(list(1, 2, 3, 4, 5, 6)) print
sum_array(list(1, 2, list(3, 3, 3), 4, 5)) print

"""
4. Add a slot called myAverage to a list that computes the average of
all the numbers in a list. 
What happens if there are no numbers in a list? 
(Bonus: Raise an Io exception if any item in the list is not a number.)
"""

List myAverage := method(
    no_digits := select(x, x asNumber() isNan()) size > 0
    if(no_digits, 
        Exception raise("There's a non-numeric item in the list")
    )
    flat_list := self flatten
    flat_list reduce(+) / flat_list size
)

list(1, 2, 3, 4, 5, 6) myAverage print
list(1, 2, 3, 4, 5, "a") myAverage print

"""
5. Write a prototype for a two-dimensional list. 
The dim(x, y) method should allocate a list of y lists that are x elements long. 
set(x, y, value) should set a value, and get(x, y) should return that value.
"""

List2D := List clone
List2D dim := method(x, y, 
    y repeat(
        inner := list()
        x repeat(inner push(nil))
        self append(inner) 
    ) 
)
List2D get := method(x, y, 
    self at(x) at(y)
)
List2D set := method(x, y, value,
    self at(x) atPut(y, value)
)

"Creating a 3x3 matrix:" print
my_matrix := List2D clone
my_matrix dim(3, 3) print

"\nSetting the element (1, 2):" print
my_matrix set(1, 2, "Foo")
my_matrix print

"\nGetting the elements (1, 1) and (1, 2):" print
my_matrix get(1, 2) print
my_matrix get(1, 1) print

"""
6. Bonus: Write a transpose method so that (new_matrix get(y, x)) ==
matrix get(x, y) on the original list.
"""

flipFirst2Args := method(slotName,
    self getSlot(slotName) setArgumentNames(
        list( 
            self getSlot(slotName) argumentNames at(1), 
            self getSlot(slotName) argumentNames at(0),
            self getSlot(slotName) argumentNames rest rest
        ) flatten
    )
)
List2D transpose := method(
    self get = flipFirst2Args("get")
    self set = flipFirst2Args("set")
)

"Original matrix:" print
"(1, 2): " print; my_matrix get(1, 2) print
"(2, 1): " print; my_matrix get(2, 1) print

"Transposed matrix:" print
my_matrix transpose
"(1, 2): " print; my_matrix get(1, 2) print
"(2, 1): " print; my_matrix get(2, 1) print

"""
7. Write the matrix to a file, and read a matrix from a file.
"""

"Write to a file:" print
file := File with("matrix.txt")
file remove
file openForUpdating
file write(my_matrix join(", "))
file close

"Read from a file:" print
file = File with("matrix.txt")
file openForReading
lines := file readLines
file close

"""
8. Write a program that gives you ten tries to guess a random number from 1 to 100. 
If you would like,  give a hint of 'hotter' or 'colder' after the first guess.
"""

randomNumber := ((Random value) * 100 + 1) floor
i := 0
guess := 0
while(i < 10 and guess != randomNumber,
    ("Enter a number between 1 and 100: (guess " .. i+1 .. " of 10): ") print
    guess = ReadLine readLine
    guess = if(guess asNumber isNan, 0, guess asNumber)
    if(guess > randomNumber, "Too high" print)
    if(guess < randomNumber, "Too low" print)
    i = i + 1
)

if(guess == randomNumber, 
    "You guessed it." print, 
    "Too many attemps. Play again" print
)