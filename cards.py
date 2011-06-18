#!/usr/bin/env python

import sys

proponent = 0
opponent = 1

def I(idx, x):
    return x

class Slot:
    def __repr__(self):
        return "{%d, %s}" % (self.v, self.f)
    def __init__(self):
        self.f = I
        self.v = 10000

class Error:
    pass

y = []
z = []
for x in xrange(256):
    y += [Slot()]
    z += [Slot()]
slots = [y, z]

def isValidSlot(i):
    if (not type(i) is int):
        raise Error()
    return i >= 0 and i <= 255

def isSlotDead(player, i):
    return slots[player][i] == 0 or slots[player][i] == -1

############################ CARDS ############################
def succ(idx, n):
    if (not type(n) is int):
        raise Error()
    if (n < 65535):
        return n+1
    else:
        return 65535

def dbl(idx, n):
    if (not type(n) is int):
        raise Error()
    if (n < 32768):
        return n*2
    else:
        return 65535

def get(idx, i):
    if ((not isValidSlot(i)) or (isSlotDead(idx, i))):
        raise Error()
    return slots[idx][i].f

def put(idx, x):
    return I

def S(idx, f):
    return (lambda g: (lambda x: (lambda h, y: h(y))(f(x), g(x))))

def K(idx, x):
    return (lambda y: x)

def inc(idx, i):
    if (not type(i) is int):
        raise Error()
    v = slots[idx][i].v
    if (isValidSlot(i)):
        slots[idx][i].v += 1
    else:
        pass
    return I

def dec(idx, i):
    if (not type(i) is int):
        raise Error()
    v = slots[(idx + 1) % 2][255].v
    if (v > 0):
        slots[(idx + 1) % 2][255].v -= 1
    else:
        pass
    return I

def attack(idx, i):
    return (lambda j: (lambda n: processAttack(idx, i, j, n)))

# helper for attack()
def processAttack(idx, i, j, n):
    if ((not type(n) is int) or (not isValidSlot(i)) or (n > slots[idx][i].v)):
        raise Error()
    slots[idx][i].v -= n
    if (isSlotDead((idx + 1) % 2, 255-j)):
        pass
    else:
        if (not isValidSlot(j)):
            raise Error()
        slots[(idx + 1) % 2][255-j].v -= min(slots[(idx + 1) % 2][255-j].v, int(n*9/10))
    return I

def help(idx, i):
    return (lambda j: (lambda n: processHelp(idx, i, j, n)))

def processHelp(idx, i, j, n):
    if ((not type(n) is int) or (not isValidSlot(i)) or (n > slots[idx][i].v)):
        raise Error()
    slots[idx][i].v -= n
    if (not isValidSlot(j)):
        raise Error()
    if (not isSlotDead(j)):
        slots[idx][j].v += int(n*11/10)
        slots[idx][j].v = min(slots[idx][j].v, 65535)
    return I

def copy(idx, i):
    if (not isValidSlot(i)):
        raise Error()
    return slots[(idx + 1) % 2][i].f

def revive(idx, i):
    if (not isValidSlot(i)):
        raise Error()
    if (slots[idx][i].v <= 0):
        slots[idx][i].v = 1 
    else:
        pass
    return I

def zombie(idx, i):
    return (lambda x: zombieHelper(idx, i, x))

def zombieHelper(idx, i, x):
    if (not isValidSlot(i)):
        raise Error()
    if (isSlotDead(i)):
        slots[(idx + 1) % 2][255-i] = x
    else:
        raise Error()
    return I

######################## END CARDS ############################

L = {
        "I": I,
        "zero": 0,
        "succ": succ,
        "dbl": dbl,
        "get": get,
        "put": put,
        "S": S,
        "K": K,
        "inc": inc,
        "dec": dec,
        "attack": attack,
        "help": help,
        "copy": copy,
        "revive": revive,
        "zombie": zombie
    }

def printSlots(idx):
    for i in xrange(256):
        s = slots[idx][i]
        if (s.v != 10000 or s.f != I):
            print i,"=",s
    print "(slots {10000,I} are omitted)"

def opp(idx):
    print "*** player %d's turn, with slots:\n" % idx 
    print "PROPONENT\n"
    printSlots(proponent)
    print "\n"
    print "OPPONENT\n"
    printSlots(opponent)
    print "\n"
    try:
        x = raw_input("(1) apply card to slot, or (2) apply slot to card?\n")
        if (x == "2"):
            slot = int(raw_input("slot no?\n"))
            name = raw_input("card name?\n")
            card = L[name]
            slots[idx][slot].f = slots[idx][slot].f(idx, card)
            print "player %d applied slot %d to card %s" % (idx, slot, name)
        elif (x == "1"):
            name = raw_input("card name?\n")
            slot = int(raw_input("slot no?\n"))
            card = L[name]
            slots[idx][slot].f = card(idx, slots[idx][slot].f)
            print "player %d applied card %s to slot %d" % (idx, name, slot)
        else:
            sys.exit(0)
    except Error:
        pass
    except KeyError:
        pass

def main():
    global proponent, opponent
    if (len(sys.argv) >= 1 and sys.argv[0] == 0):
        pass
    else:
        proponent = 1
        opponent = 0

    turn = 0
    if (opponent == 0):
        while turn < 10000:
            opp(opponent)
            opp(proponent)
            turn += 1
    else:
        while turn < 10000:
            opp(proponent)
            opp(opponent)
            turn += 1

if __name__ == "__main__":
    main()
