class InvalidInteger < StandardError; end

# recursion
def factorial(n)
  raise InvalidInteger, 'Number must be greater than zero' if n.negative?
  return 1 if n < 2

  n * factorial(n - 1)
end

# iteration
# def factorial(n)
# end
