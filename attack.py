#!/usr/bin/env python

def opp():
    a = raw_input()
    b = raw_input()
    c = raw_input()
    print a
    print b
    print c

def doubleUp(i):
    # load zero
    print 2
    print i
    print "zero"

    # add 1
    print 1
    print "succ"
    print i

    # change value of slot i to 65535
    for i in xrange(16):
        print 1
        print "dbl"
        print i

# S(K(attack(zero)(zero)))(get)
def loadAttack(i):
    print 2
    print i
    print "attack"
    print 2
    print i
    print "zero"
    print 2
    print i
    print "zero"
    print 1
    print "K"
    print i
    print 1
    print "S"
    print i
    print 2
    print i
    print "get"

# get(zero)
def copyZeroSlot(i):
    print 2
    print i
    print "get"
    print 2
    print i
    print zero

def main():
    # load attack function into slot 0
    loadAttack(0)

    # copy attack function to slots 1..255
    for i in xrange(1, 256):
        copyZeroSlot(i)

    # clear out slot 0
    print "1\nput\n0"
    doubleUp(0)

if __name__ == '__main__':
    main()
