######################
## Day 3
######################

###########
## Domain-Specific Languages

# Say you want to represent phone numbers in this form:

{
    "Bob Smith": "5195551212",
    "Mary Walsh": "4162223434"
}

# To do this, we need to alter Io to interpret the last code as an Io hash.
# A possible implementation is as follows:

OperatorTable addAssignOperator(":", "atPutNumber")
curlyBrackets := method(
    r := Map clone
    call message arguments foreach(arg,
        r doMessage(arg)
    )
    r
)
Map atPutNumber := method(
    self atPut(
        call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
        call evalArgAt(1)
    )
)

# We can test the last code as follows:

s := File with("phonebook.txt") openForReading contents
phoneNumbers := doString(s)
phoneNumbers keys println
phoneNumbers values println

###########
## Io's method_missing

# Let's build a XML generator. For example, we want to express this:

"""
<body>
    <p> This is a simple paragraph. </p>
</body>
"""
# Like this:

body(
    p("This is a simple paragraph.")
)

# To do it, we need use Io's 'forward' method, which is similar 
# to ruby's 'missing method', as follows:

Builder := Object clone
Builder forward := method(
    writeln("<", call message name, ">")
    call message arguments foreach(arg,
        content := self doMessage(arg);
        if(content type == "Sequence", writeln(content))
    )
    writeln("</", call message name, ">")
)

Builder ul(
    li("Io"),
    li("Lua"),
    li("JavaScript")
)

###########
## Concurrency
###########

###########
## Coroutines

# Consider the following code:

vizzini := Object clone
vizzini talk := method(
    "Fezzik, are there rocks ahead?" println
    yield
    "No more rhymes now, I mean it." println
    yield
)

fezzik := Object clone
fezzik rhyme := method(
    yield
    "If there are, we'll all be dead." println
    yield
    "Anybody want a peanut?" println
)

vizzini @@talk; fezzik @@rhyme
Coroutine currentCoroutine pause

###########
## Actors

# In Io, sending an asynchronous message to an object makes it an actor. 
# For example, consider two objects called faster and slower:

slower := Object clone
faster := Object clone

# Next, we'll add a method called start to each:

slower start := method(wait(2); writeln("slowly"))
faster start := method(wait(1); writeln("quickly"))

# We can call both methods sequentially with simple messages, as follows:

slower start; faster start

# But we can make each object run in its own thread 
# by preceding each message with @@, as follows:

slower @@start; faster @@start; wait(3)

###########
## Futures

# Consider a method that takes a long time to execute:

futureResult := URL with("http://google.com/") @fetch

# We can execute the last method and do something else immediately 
# until the result is available, as follows:

// This line will execute immediately
writeln("Do something immediately while fetch goes on in background...")

# Then, we can use the future value as follows:

// This line will block until the computation is complete
writeln("fetched ", futureResult size, " bytes") 

###########
## Exersises for day 3

"""
1. Enhance the XML program to add spaces to show the indentation structure.
"""

Builder := Object clone
Builder indentLevel := 0
Builder makeIndent := method(spaces := ""
    indentLevel repeat(spaces = spaces .. " ")
    spaces
)
Builder forward = method(
    writeln(makeIndent() .. "<", call message name, ">")
    numberSpaces := 4
    indentLevel = indentLevel + numberSpaces
    call message arguments foreach(arg,
        content := self doMessage(arg);
        if(content type == "Sequence", writeln(makeIndent() .. content))
    )
    indentLevel = indentLevel - numberSpaces
    writeln(makeIndent() .. "</", call message name, ">")
)

"\nXML with indented syntax (4 spaces per indent):" println
Builder ul(
    li("Io"),
    li("Lua"),
    li("JavaScript")
)

"""
2. Create a list syntax that uses brackets.
"""

squareBrackets := method(
    call message arguments
)

"\nSquare bracket list syntax:" println
[1, 2, 3, 4, 5] println
["a", "b", "c", "d", "e"] println


"""
3. Enhance the XML program to handle attributes. 
If the first argument is a map (use the curly brackets syntax), 
add attributes to the XML program. 
For example: book({'author': 'Tate'}...) would print <book author='Tate>
"""

OperatorTable addAssignOperator(":", "atPutNumber")
Map atPutNumber := method(
    self atPut(
        call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
        call evalArgAt(1)
    )
)
curlyBrackets := method(
    r := Map clone
    call message arguments foreach(arg,
        r doMessage(arg)
    )
    r
)
Map printAsAttributes := method(
    self foreach(k, v,
        write(" " .. k .. "=\"" .. v .. "\"")
    )
)
Builder forward = method(
    write(makeIndent() .. "<", call message name)
    indentLevel = indentLevel + 1
    isFirst := true
    call message arguments foreach(arg,
        if(isFirst,
            if(arg name == "curlyBrackets", 
                (self doMessage(arg)) printAsAttributes
            )

            write(">\n")
            isFirst = false
        )
        content := self doMessage(arg)
        if(content type == "Sequence", 
            writeln(makeIndent() .. content)
        )
    )
    indentLevel = indentLevel - 1
    writeln(makeIndent() .. "</", call message name, ">")
)

"\nBuilder syntax with attributes:" println
s := File with("builder_syntax.txt") openForReading contents
doString(s)
