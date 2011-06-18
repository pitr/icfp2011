$current_cell = 0

[
:S,
:K,
:I,
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
].each{|op|eval"def #{op.downcase}(c=$current_cell); pa :#{op},c; end;def #{op.downcase}!(c=$current_cell); op :#{op},c; end;"}

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
def pp(_op, *_p)
  k!
  s!
  send _op
  if _p.length > 1
    pp _p.shift, *_p
  else
    send _p.first unless _p.nil?
  end
end

def slot(c=$current_cell, &block)
  old_cell, $current_cell = $current_cell, c
  yield if block_given?
  $current_cell = old_cell
end
