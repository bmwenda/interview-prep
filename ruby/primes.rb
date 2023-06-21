# solution using the sieve of eratosthenes: https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

# prime numbers in range 0 - n
def prime_numbers_in_range(n)
  primes = [2]
  3.upto(n) do |num|
    is_prime = true
    primes.each do |prime|
      # if a number has no factor till its squareroot than there is none above that
      # reference: https://studyalgorithms.com/misc/find-the-first-n-prime-numbers-method-2/
      break if prime > Math.sqrt(num).ceil

      if num % prime == 0
        is_prime = false
        break
      end
    end
    primes << num if is_prime
  end
  primes
end

# first n prime numbers
def first_n_primes(n)
  primes = [2]
  num = 3
  loop do
    is_prime = true
    primes.each do |prime|
      break if prime > Math.sqrt(num).ceil

      if num % prime == 0
        is_prime = false
        break
      end
    end

    primes << num if is_prime
    break if primes.size == n

    num += 1
  end
  primes
end
