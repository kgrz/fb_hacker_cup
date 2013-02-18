require 'minitest/autorun'
require 'pry'

class TestInput < MiniTest::Unit::TestCase
  def setup
    @input = Input.new(File.join(File.dirname(__FILE__), "../input.txt"))
  end

  def test_no_of_testcases
    assert_equal 5, @input.no_of_testcases
  end

  def test_digits
    assert_equal [4,1,5,2,3], @input.digits
  end
end



class Input
  attr_accessor :file, :testcases, :no_of_testcases
  def initialize(input = File.join(File.dirname(__FILE__), "../input.txt"))
    @file = File.new(input)
    @testcases = []
    process_file
  end

  def process_file
    @no_of_testcases = file.gets.chomp.to_i
    file.each_slice(11) do |text|
      @testcases << TestCase.new(text)
    end
  end

  def digits
    @testcases.map(&:no_of_digits)
  end
end

class String
  def first
    self.strip.split("\n").first
  end
  
  def [](*args)
    self.strip.split("\n").send(:[], *args)
  end
end

class TestCase
  attr_accessor :no_of_digits, :war_matrix, :result
  def initialize(testcase)
    @result = []
    @no_of_digits = testcase.first.chomp.to_i
    @war_matrix = testcase[1..-1].map do |matrix|
      matrix.chomp.split(" ").map(&:to_i)
    end
  end

  def from_number
    0
  end

  def to_number
    10**no_of_digits - 1
  end

  def is_at_war?(arg1, arg2)
    war_matrix[arg1][arg2] == 0 ? false : true 
  end
  
  def check(number, arity)
    return true if number/arity == 0
    if is_at_war?(number%10, number/arity%10)
      return false
    else
      check(number/10, arity)
     end
  end

  def process_result
    (from_number..to_number).each do |number|
      @result << number if(check(number, 10) && check(number, 100))
    end
    @result.delete_if { |x| x == 0 }
  end
end



class TestTestCase < MiniTest::Unit::TestCase
  def setup
    @string = %Q{
    4
    0 1 1 0 0 1 1 1 1 1
    1 0 0 1 0 0 0 1 1 1
    1 0 0 1 1 1 0 1 0 1
    0 1 1 1 1 0 0 0 0 1
    0 0 1 1 0 1 1 0 1 0
    1 0 1 0 1 0 1 1 0 1
    1 0 0 0 1 1 1 0 0 0
    1 1 1 0 0 1 0 1 0 1
    1 1 0 0 1 0 0 0 0 1
    1 1 1 1 0 1 0 1 1 0
    }
    @array= [
    "4\n",
    "0 1 1 0 0 1 1 1 1 1\n",
    "1 0 0 1 0 0 0 1 1 1\n",
    "1 0 0 1 1 1 0 1 0 1\n",
    "0 1 1 1 1 0 0 0 0 1\n",
    "0 0 1 1 0 1 1 0 1 0\n",
    "1 0 1 0 1 0 1 1 0 1\n",
    "1 0 0 0 1 1 1 0 0 0\n",
    "1 1 1 0 0 1 0 1 0 1\n",
    "1 1 0 0 1 0 0 0 0 1\n",
    "1 1 1 1 0 1 0 1 1 0\n"
    ]
    @testcase_string = TestCase.new(@string)
    @testcase_array  = TestCase.new(@array)
  end

  def test_no_of_digits_when_string_is_passed
    assert_equal 4, @testcase_string.no_of_digits
  end
  
  def test_no_of_digits_when_string_is_passed
    assert_equal 4, @testcase_array.no_of_digits
  end
  
  def test_war_matrix
    @matrix = [
    [0, 1, 1, 0, 0, 1, 1, 1, 1, 1],
    [1, 0, 0, 1, 0, 0, 0, 1, 1, 1],
    [1, 0, 0, 1, 1, 1, 0, 1, 0, 1],
    [0, 1, 1, 1, 1, 0, 0, 0, 0, 1],
    [0, 0, 1, 1, 0, 1, 1, 0, 1, 0],
    [1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
    [1, 0, 0, 0, 1, 1, 1, 0, 0, 0],
    [1, 1, 1, 0, 0, 1, 0, 1, 0, 1],
    [1, 1, 0, 0, 1, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 0, 1, 0, 1, 1, 0]
    ]
    assert_equal @matrix, @testcase_array.war_matrix
    @testcase_array.process_result
    puts (@testcase_array.result.count%(10**9+7))
  end
end

Input.new.testcases.each do |testcase|
  testcase.process_result
  puts testcase.result.count
end
