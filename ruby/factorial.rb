require 'benchmark'

class InvalidInteger < StandardError; end

# recursion
def factorial_recursion(n)
  raise InvalidInteger, 'Number must be greater than zero' if n.negative?
  return 1 if n < 2

  n * factorial_recursion(n - 1)
end

# iteration
def factorial_iter(n)
  raise InvalidInteger, 'Number must be greater than zero' if n.negative?

  factorial = 1
  1.upto(n) do |num|
    factorial *= num
  end
  factorial
end

# Benchmark
Benchmark.bmbm do |x|
  x.report('recursion') { factorial_recursion(10_073) }
  x.report('iteration') { factorial_iter(10_073) }
end

=begin
Rehearsal ---------------------------------------------
recursion   0.049798   0.024016   0.073814 (  0.075264)
iteration   0.045139   0.011237   0.056376 (  0.057772)
------------------------------------ total: 0.130190sec

                user     system      total        real
recursion   0.039090   0.007500   0.046590 (  0.047430)
iteration   0.038264   0.005881   0.044145 (  0.045397)
=end
