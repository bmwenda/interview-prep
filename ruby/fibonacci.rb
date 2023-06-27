require 'benchmark'

def fibonacci(n)
  raise StandardError, 'Number is negative' if n < 0
  return n if n < 2

  fibonacci(n - 1) + fibonacci(n - 2)
end

# with cache
# store the computed value of each number in a hash, i.e { 0 => 0, 1 => 1, 2 => 1, ...n => value }
class Fibonacci
  def initialize
    @cache = {}
  end

  def fibonacci(n)
    raise StandardError, 'Number is negative' if n < 0

    if n < 2
      @cache[n] = n
    else
      @cache[n] ||= fibonacci(n - 1) + fibonacci(n - 2)
    end
  end
end

# iteration
def fibonacci_iter(n)
  first_number = 0
  second_number = 1

  0.upto(n) do
    first_number, second_number = second_number, first_number + second_number
  end
  first_number
end

# reduce method
def array_reduce(n)
  (0..n).reduce([0, 1]) { |result| result << result.last(2).reduce(:+) }
end

Benchmark.bmbm do |x|
  x.report('No cache') { (1..35).map { |n| fibonacci(n) }  }
  x.report('With cache') { (1..35).map { |n| Fibonacci.new.fibonacci(n) } }
  x.report('Iteration') { (0..35).map { |n| fibonacci_iter(n) } }
  x.report('Array reduce') { (0..35).reduce([0, 1]) { |result| result << result.last(2).reduce(:+) } }
end

=begin
Rehearsal ------------------------------------------------
No cache       3.947039   0.006088   3.953127 (  3.965162)
With cache     0.000191   0.000001   0.000192 (  0.000193)
Iteration      0.000121   0.000012   0.000133 (  0.000244)
Array reduce   0.000023   0.000001   0.000024 (  0.000024)
--------------------------------------- total: 3.953476sec

                   user     system      total        real
No cache       3.983022   0.004200   3.987222 (  3.994640)
With cache     0.000199   0.000003   0.000202 (  0.000196)
Iteration      0.000082   0.000003   0.000085 (  0.000080)
Array reduce   0.000026   0.000003   0.000029 (  0.000023)
=end
