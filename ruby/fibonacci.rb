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
  x.report('No cache') { (0..35).map { |n| fibonacci(n) }  }
  x.report('With cache') { (0..35).map { |n| Fibonacci.new.fibonacci(n) } }
  x.report('Iteration') { (0..35).map { |n| fibonacci_iter(n) } }
  x.report('Array reduce') { array_reduce(35) }
end

=begin
Rehearsal ------------------------------------------------
No cache       3.972048   0.003780   3.975828 (  3.983086)
With cache     0.000231   0.000001   0.000232 (  0.000233)
Iteration      0.000088   0.000001   0.000089 (  0.000088)
Array reduce   0.000023   0.000001   0.000024 (  0.000024)
--------------------------------------- total: 3.976173sec

                   user     system      total        real
No cache       3.944449   0.004067   3.948516 (  3.955024)
With cache     0.000204   0.000004   0.000208 (  0.000201)
Iteration      0.000084   0.000003   0.000087 (  0.000081)
Array reduce   0.000026   0.000003   0.000029 (  0.000023)
=end
