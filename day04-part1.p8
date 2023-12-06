/* https://adventofcode.com/2023/day/4
--- Day 4: Scratchcards ---

The gondola takes you up. Strangely, though, the ground doesn't seem to be
coming with you; you're not climbing a mountain. As the circle of Snow
Island recedes below you, an entire new landmass suddenly appears above
you! The gondola carries you to the surface of the new island and lurches
into the station.

As you exit the gondola, the first thing you notice is that the air here is
much warmer than it was on Snow Island. It's also quite humid. Is this
where the water source is?

The next thing you notice is an Elf sitting on the floor across the station
in what seems to be a pile of colorful square cards.

"Oh! Hello!" The Elf excitedly runs over to you. "How may I be of service?"
ou ask about water sources.

"I'm not sure; I just operate the gondola lift. That does sound like
something we'd have, though - this is Island Island, after all! I bet the
gardener would know. He's on a different island, though - er, the small
kind surrounded by water, not the floating kind. We really need to come up
with a better naming scheme. Tell you what: if you can help me with
something quick, I'll let you borrow my boat and you can go visit the
gardener. I got all these scratchcards as a gift, but I can't figure out
what I've won."

The Elf leads you over to the pile of colorful cards. There, you discover
dozens of scratchcards, all with their opaque covering already scratched
off. Picking one up, it looks like each card has two lists of numbers
separated by a vertical bar (|): a list of winning numbers and then a list
of numbers you have. You organize the information into a table (your puzzle
input).

As far as the Elf has been able to figure out, you have to figure out which
of the numbers you have appear in the list of winning numbers. The first
match makes the card worth one point and each match after the first doubles
the point value of that card.

For example:

Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11

In the above example, card 1 has five winning numbers (41, 48, 83, 86, and
17) and eight numbers you have (83, 86, 6, 31, 17, 9, 48, and 53). Of the
numbers you have, four of them (48, 83, 17, and 86) are winning numbers!
That means card 1 is worth 8 points (1 for the first match, then doubled
three times for each of the three matches after the first).

  - Card 2 has two winning numbers (32 and 61), so it is worth 2 points.
  - Card 3 has two winning numbers (1 and 21), so it is worth 2 points.
  - Card 4 has one winning number (84), so it is worth 1 point.
  - Card 5 has no winning numbers, so it is worth no points.
  - Card 6 has no winning numbers, so it is worth no points.

So, in this example, the Elf's pile of scratchcards is worth 13 points.

Take a seat in the large pile of colorful cards. How many points are they
worth in total? */

; Tested on: X16

%zeropage basicsafe
%option no_sysinit
%import textio
%import floats ; For timing

main {

  uword totalPoints

  sub start() {

    ; First 10 columns of each row can be ignored
    uword inAddr = &input + 10
    ubyte[10] @zp winningNums
    ; Potential optimisation:
    ; Shift winning numbers down when found and have them zero-terminated to
    ; avoid checking each winning number multiple times.
    ; In practice, this doesn't save any time. Do not retry!
    repeat 204 { ; lines

      uword points = 0 ; Contains up to 512

      ; Manually unrolled loop from 0 to 9
      if @(inAddr) != iso:' ' winningNums[0] = (@(inAddr) ^ 48) * 10
      else winningNums[0] = 0
      winningNums[0] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[1] = (@(inAddr) ^ 48) * 10
      else winningNums[1] = 0
      winningNums[1] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[2] = (@(inAddr) ^ 48) * 10
      else winningNums[2] = 0
      winningNums[2] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[3] = (@(inAddr) ^ 48) * 10
      else winningNums[3] = 0
      winningNums[3] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[4] = (@(inAddr) ^ 48) * 10
      else winningNums[4] = 0
      winningNums[4] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[5] = (@(inAddr) ^ 48) * 10
      else winningNums[5] = 0
      winningNums[5] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[6] = (@(inAddr) ^ 48) * 10
      else winningNums[6] = 0
      winningNums[6] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[7] = (@(inAddr) ^ 48) * 10
      else winningNums[7] = 0
      winningNums[7] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[8] = (@(inAddr) ^ 48) * 10
      else winningNums[8] = 0
      winningNums[8] += @(inAddr + 1) ^ 48
      inAddr += 3 ; Advance to next number
      if @(inAddr) != iso:' ' winningNums[9] = (@(inAddr) ^ 48) * 10
      else winningNums[9] = 0
      winningNums[9] += @(inAddr + 1) ^ 48
      inAddr += 5 ; Extra advancement due to vertical bar

      ; Manually unrolled loop, repeat 25, each number on ticket
      ; Could be unrolled further at expense of PRG size
      repeat 5 { ; Each number on ticket
        ubyte thisNum = 0
        if @(inAddr) != iso:' ' thisNum = (@(inAddr) ^ 48) * 10
        thisNum += @(inAddr + 1) ^ 48
        ; Manually unrolled loops from 0 to 9 - iterate through winning numbers
        if points > 0 {
          if thisNum == winningNums[0] points *= 2
          else if thisNum == winningNums[1] points *= 2
          else if thisNum == winningNums[2] points *= 2
          else if thisNum == winningNums[3] points *= 2
          else if thisNum == winningNums[4] points *= 2
          else if thisNum == winningNums[5] points *= 2
          else if thisNum == winningNums[6] points *= 2
          else if thisNum == winningNums[7] points *= 2
          else if thisNum == winningNums[8] points *= 2
          else if thisNum == winningNums[9] points *= 2
        } else {
          if thisNum == winningNums[0] points = 1
          else if thisNum == winningNums[1] points = 1
          else if thisNum == winningNums[2] points = 1
          else if thisNum == winningNums[3] points = 1
          else if thisNum == winningNums[4] points = 1
          else if thisNum == winningNums[5] points = 1
          else if thisNum == winningNums[6] points = 1
          else if thisNum == winningNums[7] points = 1
          else if thisNum == winningNums[8] points = 1
          else if thisNum == winningNums[9] points = 1
        }

        inAddr += 3

        thisNum = 0
        if @(inAddr) != iso:' ' thisNum = (@(inAddr) ^ 48) * 10
        thisNum += @(inAddr + 1) ^ 48
        ; Manually unrolled loops from 0 to 9 - iterate through winning numbers
        if points > 0 {
          if thisNum == winningNums[0] points *= 2
          else if thisNum == winningNums[1] points *= 2
          else if thisNum == winningNums[2] points *= 2
          else if thisNum == winningNums[3] points *= 2
          else if thisNum == winningNums[4] points *= 2
          else if thisNum == winningNums[5] points *= 2
          else if thisNum == winningNums[6] points *= 2
          else if thisNum == winningNums[7] points *= 2
          else if thisNum == winningNums[8] points *= 2
          else if thisNum == winningNums[9] points *= 2
        } else {
          if thisNum == winningNums[0] points = 1
          else if thisNum == winningNums[1] points = 1
          else if thisNum == winningNums[2] points = 1
          else if thisNum == winningNums[3] points = 1
          else if thisNum == winningNums[4] points = 1
          else if thisNum == winningNums[5] points = 1
          else if thisNum == winningNums[6] points = 1
          else if thisNum == winningNums[7] points = 1
          else if thisNum == winningNums[8] points = 1
          else if thisNum == winningNums[9] points = 1
        }

        inAddr += 3

        thisNum = 0
        if @(inAddr) != iso:' ' thisNum = (@(inAddr) ^ 48) * 10
        thisNum += @(inAddr + 1) ^ 48
        ; Manually unrolled loops from 0 to 9 - iterate through winning numbers
        if points > 0 {
          if thisNum == winningNums[0] points *= 2
          else if thisNum == winningNums[1] points *= 2
          else if thisNum == winningNums[2] points *= 2
          else if thisNum == winningNums[3] points *= 2
          else if thisNum == winningNums[4] points *= 2
          else if thisNum == winningNums[5] points *= 2
          else if thisNum == winningNums[6] points *= 2
          else if thisNum == winningNums[7] points *= 2
          else if thisNum == winningNums[8] points *= 2
          else if thisNum == winningNums[9] points *= 2
        } else {
          if thisNum == winningNums[0] points = 1
          else if thisNum == winningNums[1] points = 1
          else if thisNum == winningNums[2] points = 1
          else if thisNum == winningNums[3] points = 1
          else if thisNum == winningNums[4] points = 1
          else if thisNum == winningNums[5] points = 1
          else if thisNum == winningNums[6] points = 1
          else if thisNum == winningNums[7] points = 1
          else if thisNum == winningNums[8] points = 1
          else if thisNum == winningNums[9] points = 1
        }

        inAddr += 3

        thisNum = 0
        if @(inAddr) != iso:' ' thisNum = (@(inAddr) ^ 48) * 10
        thisNum += @(inAddr + 1) ^ 48
        ; Manually unrolled loops from 0 to 9 - iterate through winning numbers
        if points > 0 {
          if thisNum == winningNums[0] points *= 2
          else if thisNum == winningNums[1] points *= 2
          else if thisNum == winningNums[2] points *= 2
          else if thisNum == winningNums[3] points *= 2
          else if thisNum == winningNums[4] points *= 2
          else if thisNum == winningNums[5] points *= 2
          else if thisNum == winningNums[6] points *= 2
          else if thisNum == winningNums[7] points *= 2
          else if thisNum == winningNums[8] points *= 2
          else if thisNum == winningNums[9] points *= 2
        } else {
          if thisNum == winningNums[0] points = 1
          else if thisNum == winningNums[1] points = 1
          else if thisNum == winningNums[2] points = 1
          else if thisNum == winningNums[3] points = 1
          else if thisNum == winningNums[4] points = 1
          else if thisNum == winningNums[5] points = 1
          else if thisNum == winningNums[6] points = 1
          else if thisNum == winningNums[7] points = 1
          else if thisNum == winningNums[8] points = 1
          else if thisNum == winningNums[9] points = 1
        }

        inAddr += 3

        thisNum = 0
        if @(inAddr) != iso:' ' thisNum = (@(inAddr) ^ 48) * 10
        thisNum += @(inAddr + 1) ^ 48
        ; Manually unrolled loops from 0 to 9 - iterate through winning numbers
        if points > 0 {
          if thisNum == winningNums[0] points *= 2
          else if thisNum == winningNums[1] points *= 2
          else if thisNum == winningNums[2] points *= 2
          else if thisNum == winningNums[3] points *= 2
          else if thisNum == winningNums[4] points *= 2
          else if thisNum == winningNums[5] points *= 2
          else if thisNum == winningNums[6] points *= 2
          else if thisNum == winningNums[7] points *= 2
          else if thisNum == winningNums[8] points *= 2
          else if thisNum == winningNums[9] points *= 2
        } else {
          if thisNum == winningNums[0] points = 1
          else if thisNum == winningNums[1] points = 1
          else if thisNum == winningNums[2] points = 1
          else if thisNum == winningNums[3] points = 1
          else if thisNum == winningNums[4] points = 1
          else if thisNum == winningNums[5] points = 1
          else if thisNum == winningNums[6] points = 1
          else if thisNum == winningNums[7] points = 1
          else if thisNum == winningNums[8] points = 1
          else if thisNum == winningNums[9] points = 1
        }

        inAddr += 3

      }

      totalPoints += points
      inAddr += 10

    }

    txt.nl()
    txt.print_uw(totalPoints) ; 27454
    txt.nl()
    floats.print_f(ti())
    txt.nl()

  }

  sub ti() -> float {
    ubyte a
    ubyte x
    ubyte y
    %asm{{
        jsr cbm.RDTIM
        sta p8_a
        stx p8_x
        sty p8_y
    }}
    return (a as float) + 256 * (x as float + 256 * (y as float))
  }

  input:
    %asmbinary "input/day04.txt"

}