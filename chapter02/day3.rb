######################
## Day 3
######################

###########
## Open classes

# You can change the definition of any class at any time, to add behavior. 
# Here’s an example from the Rails framework:

# We are literally redefining String and Nil!!

class NilClass 
	def blank?
		true
	end
end

class String
	def blank?
		self.size == 0
	end
end

["", "person", nil].each do |element|
	puts element unless element.blank?
end

# As another example of open classes, consider an API that 
# redefines the Numeric class to express all distance as inches:

class Numeric
    def inches
        self
    end

    def feet
        self * 12.inches
    end

    def yards
        self * 3.feet
    end

    def miles
        self * 5280.feet
    end

    def back
        self * -1
    end

    def forward
		self
    end
end

puts 10.miles.back
puts 2.feet.forward

###########
## method_missing()

# With 'method_missing()', we can implement roman numerals as follows

class Roman
	def self.method_missing name, *args
		roman = name.to_s
		roman.gsub!("IV", "IIII")
		roman.gsub!("IX", "VIIII")
		roman.gsub!("XL", "XXXX")
		roman.gsub!("XC", "LXXXX")
		(
			roman.count("I") +
			roman.count("V") * 5 +
			roman.count("X") * 10 +
			roman.count("L") * 50 +
			roman.count("C") * 100
		)
	end
end

puts Roman.X
puts Roman.XC
puts Roman.XII
puts Roman.X

###########
## Modules

# Consider a program to open a CSV file based on the name of the class

class ActsAsCsv
	def read
		file = File.new(self.class.to_s.downcase + '.txt')
		@headers = file.gets.chomp.split(', ')
		file.each do |row|
			@result << row.chomp.split(', ')
		end
	end

	def headers
		@headers
	end

	def csv_contents
		@result
	end

	def initialize
		@result = []
		read
	end
end

class RubyCsv < ActsAsCsv 
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect

# Next, we take the file and attach that behavior to a class with a module method. 
# In this case, the method opens up the class and dumps in all the behavior 
# related to CSV files:

class ActsAsCsv
    def self.acts_as_csv
        define_method 'read' do
            file = File.new(self.class.to_s.downcase + '.txt')
            @headers = file.gets.chomp.split(', ')
            file.each do |row|
                @result << row.chomp.split(', ')
            end
        end
    
        define_method "headers" do
			@headers
        end
        
        define_method "csv_contents" do
			@result
        end
        
        define_method 'initialize' do
            @result = []
            read
        end
    end
end

class RubyCsv < ActsAsCsv
    acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect

# The last class can be implemented with a module, as follows

module ActsAsCsv
    def self.included(base)
        base.extend ClassMethods
    end
    
    module ClassMethods
        def acts_as_csv
            include InstanceMethods
        end
    end
    
    module InstanceMethods
        attr_accessor :headers, :csv_contents

        def read
            @csv_contents = []
            filename = self.class.to_s.downcase + '.txt'
            file = File.new(filename)
            @headers = file.gets.chomp.split(', ')
            file.each do |row|
                @csv_contents << row.chomp.split(', ')
            end
        end

        def initialize
            read
        end
    end
end

class RubyCsv
    # No inheritance! You can mix it in
    include ActsAsCsv
    acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.csv_contents.inspect

###########
## Exercises for Day 2

"""
Modify the CSV application to support an each method to return a CsvRow object. 
Use method_missing on that CsvRow to return the value for the column for a given heading.

For example, for the file:

	one, two
	lions, tigers

Allow an API that works like this:

	csv = RubyCsv.new
	csv.each {|row| puts row.one}

This should print 'lions'.
"""

module ActsAsCsv
    def self.included(base)
        base.extend ClassMethods
    end

    module ClassMethods
        def acts_as_csv
            include InstanceMethods
        end
    end

    module InstanceMethods
        attr_accessor :headers, :csv_rows

        def read
            @csv_rows = []
            file = File.new(self.class.to_s.downcase + '.txt')
            @headers = file.gets.chomp.split(', ')
            file.each do |row|
                csv_contents = row.chomp.split(', ')
                @csv_rows << CsvRow.new(@headers, csv_contents)
            end
        end

        def initialize
            read
        end

        def each &block
            @csv_rows.each &block
        end

    end

    class CsvRow
        attr_accessor :header_row, :content_row

        def initialize(header_row, content_row)
            @header_row = header_row
            @content_row = content_row
        end

        def method_missing name, *args
            content_index = @header_row.index(name.to_s)
            return @content_row[content_index]
        end
    end
end

class RubyCsv 
    include ActsAsCsv
    acts_as_csv
end

csv = RubyCsv.new
csv.each{|row| puts row.one}
