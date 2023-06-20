# prime numbers in range 0 - n
def prime_numbers_in_range(n)
  primes = [2]
  3.upto(n) do |num|
    next if primes.any? { |divisor| num % divisor == 0 }

    primes << num
  end
  primes
end

# first n prime numbers
def first_n_primes(n)
  primes = [2]
  num = 3
  loop do
    if primes.any? { |divisor| num % divisor == 0 }
      num += 1
      next
    end

    primes << num
    break if primes.size == n

    num += 1
  end
  primes
end
