# Given a hash = { a: { b: { c: 42, d: 'foo' }, d: 'bar' }, e: 'baz' }
# Flatten it to: { :a_b_c=>42, :a_b_d=>"foo", :a_d=>"bar", :e=>"baz" }

def flatten_hash(hash, parent_keys = [])
  # this will be a local scope for each recursive call, i.e each flat_hash is actually a different variable
  # Hence this won't overwrite another function's value
  flat_hash = {}
  hash.each do |key, val|
    current_keys = parent_keys + [key]
    if val.is_a?(Hash)
      flat_hash.merge!(flatten_hash(val, current_keys)) # as each recursive call returns its result, we merge the hashes
    else
      flat_hash[current_keys.join('_').to_sym] = val
    end
  end
  flat_hash
end
