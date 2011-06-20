## Team

* Nissan Pow (npow)
* Peter Vernigorov (pitr)

## Languages

1. Python - abandoned implementation of VM
2. Ruby - bots and DSL

## Highlights

We wrote a Ruby-powered DSL to convert LISP-like expressions
into "Lambda The Gathering" terms. For example,

```ruby
slot 12 do
    lisp :attack, :zero, [:dbl, [:succ, :zero]], [:get, :zero]
end
```

Also, some macros to help use numbers and lots, like so

```ruby
slot(12) { lisp :attack, :num0, :slot21, :num9999 }
```

Also, check out our bots, in src/ folder