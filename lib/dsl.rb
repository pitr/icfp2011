$current_cell = 0

[:S,:K,:I,:zero,:succ,:dbl,:get,:put,:inc,
:dec,:attack,:help,:copy,:revive,:zombie
].each{|op|eval"def #{op.to_s.downcase}(c=$current_cell); pa :#{op},c; end;def #{op.to_s.downcase}!(c=$current_cell); op :#{op},c; end;"}

def method_missing(_op)
  # adds operator numXXX, where XXX is any number
  if _op.to_s =~ /^num(\d+)$/
    num = $1.to_i
    if num == 0
      zero
    elsif num %2 == 0 # even
      lisp :dbl, "num#{num/2}".to_sym
    else # odd
      lisp :succ, "num#{num-1}".to_sym
    end
  # adds operator slotYYY, where YYY is any slot number
  elsif _op.to_s =~ /^slot(\d+)$/
    lisp :get, "num#{$1}".to_sym
  else
    super
  end
end

def op(op, c=$current_cell)
  return op.each {|op2| op op2, c} if op.is_a? Array
  puts 1
  puts op.to_s
  puts c
end

def pa(op, c=$current_cell)
  return op.each {|op2| p op2, c} if op.is_a? Array
  puts 2
  puts c
  puts op.to_s
end

# shortcut to an SK trick
def sk! ; k! ; s! ; end

# Applies a _p function
# returns _op(_p0(_p1(p2(...))))
def pp(_op, *_p)
  sk!
  send _op
  if _p.length > 1
    pp _p.shift, *_p
  else
    send _p.first unless _p.nil?
  end
end

# Builds code for ya
# lisp(
#   :s, :i, :i, [:get, [:succ, :zero]]
# )
def lisp(*ops)
  case ops.length
  when 1
    send ops.first
  when 2
    sk!
      lisp *ops[0]
      lisp *ops[1]
  when 3
    sk! ; sk! ; sk! ; s
      lisp *ops[0]
      sk! ; k ; lisp *ops[2]
      lisp *ops[1]
  when 4
    sk! ; sk! ; sk! ; sk! ; s
      lisp *ops[0]
      sk! ; k ; lisp *ops[2]
      lisp *ops[1]
      lisp *ops[3]
  end
end

def slot(c=$current_cell, &block)
  old_cell, $current_cell = $current_cell, c
  yield if block_given?
  $current_cell = old_cell
end
