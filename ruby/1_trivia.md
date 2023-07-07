### String vs Symbol
- symbols are immutable while strings are mutable
- symbols of the same name refer to the same object i.e have the same object id while strings of the same name are different objects each time
- It’s faster to compare symbols for equality since they are the same object. Strings are slower because the values need to be compared instead of just the object ids
- symbols are not garbage collected and can potentially cause memory bloat if overused

Further reading:
- [differences-between-symbols-strings-in-ruby](https://www.gaurishsharma.com/2013/04/understanding-differences-between-symbols-strings-in-ruby.html)

### Super() vs super
- super(): invokes the parent method without any arguments, as presumably expected.
- super: invokes the parent method with the same arguments that were passed to the child method. An argument error will occur if the arguments passed to the child method don’t match what the parent is expecting.

### String interpolation vs concatenation
Which is better? Generally interpolation is better because:
1. It is more efficient because it does not create new string objects. This mostly comes into play when large strings are involved
2. Easier to read, extend and modify

### defined?
checks if a variable is defined or not. Returns nil if the variable is not defined. A few things about defined:
- it is one of the few things in Ruby that ends in a question mark, but doesn’t follow the usual convention to return either true or false
- it can tell the difference between a nil value & a variable that has never been set before. It makes sense because even a variable with a nil value has been defined.
- it is keyword, not a method

### Even further reading
- [ruby gotchas](https://docs.google.com/presentation/d/1cqdp89_kolr4q1YAQaB-6i5GXip8MHyve8MvQ_1r6_s/edit#slide=id.gd9ccd329_00)
