# Given a string with just the characters '(', ')', '{', '}', '[', ']',
# determine if a given input is valid

# borrowing from acceptable sequences and dyck paths: https://brilliant.org/wiki/catalan-numbers/
# all sequences of each parens must add to 0
def valid_parenthesis?(str)
  paren_refs = { '(' => 1, ')' => -1, '{' => 2, '}' => -2, '[' => 3, ']' => -3 }
  values = []
  str.chars.each { |char| values << paren_refs[char] }

  values.sum == 0
end
