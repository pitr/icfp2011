$current_cell = 0

{
  :s => :S,
  :k => :K,
  :i => :I
}.each{|m,op|eval"def #{m}(c=$current_cell); pa :#{op},c; end;def #{m}!(c=$current_cell); op :#{op},c; end;"}

[
:zero,
:succ,
:dbl,
:get,
:put, # === KI
:inc,
:dec,
:attack,
:help,
:copy,
:revive,
:zombie
].each{|op|eval"def #{op}(c=$current_cell); pa :#{op},c; end;def #{op}!(c=$current_cell); op :#{op},c; end;"}

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

# Applies a _p function
def pp(_op, _p, c=$current_cell)
  k! c
  s! c
  pa _op, c
  pa _p, c
end

def slot(c, &block)
  old_cell, $current_cell = $current_cell, c
  yield block
  $current_cell = old_cell
end
