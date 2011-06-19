$current_cell = 0
$we_go_second = false

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
  $stdout.puts "1"
  $stdout.puts op.to_s
  $stdout.puts c.to_s
  $stdout.flush
  _record_proponents_move 1, op, c
  _read_opponents_move
end

def pa(op, c=$current_cell)
  $stdout.puts "2"
  $stdout.puts c.to_s
  $stdout.puts op.to_s
  $stdout.flush
  _record_proponents_move 2, op, c
  _read_opponents_move
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

# analyzer

def _read_opponents_move
  typ = $stdin.gets.to_i
  case typ
  when 1
    op = $stdin.gets.strip
    cell = $stdin.gets.to_i
  when 2
    cell = $stdin.gets.to_i
    op = $stdin.gets.strip
  end
end

if $we_go_second = (ARGV.shift.to_i == 1)
  _read_opponents_move
end
