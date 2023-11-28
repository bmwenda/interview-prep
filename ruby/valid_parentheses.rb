# Given a string with just the characters '(', ')', '{', '}', '[', ']',
# determine if a given input is valid

def valid_parenthesis?(str)
  parens = { ')' => '(', '}' => '{', ']' => '[' }
  stack = []
  str.chars.each do |char|
    if parens.keys.include?(char) && parens[char] == stack[-1]
      stack.pop
    else
      stack.append(char)
    end
  end
  stack.empty?
end
