/* https://adventofcode.com/2023/day/2
--- Part Two ---

The Elf says they've stopped producing snow because they aren't getting any
water! He isn't sure why the water stopped; however, he can show you how to
get to the water source to check it out for yourself. It's just up ahead!

As you continue your walk, the Elf poses a second question: in each game
you played, what is the fewest number of cubes of each color that could
have been in the bag to make the game possible?

Again consider the example games from earlier:

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

  - In game 1, the game could have been played with as few as 4 red, 2
    green, and 6 blue cubes. If any color had even one fewer cube, the
    game would have been impossible.
  - Game 2 could have been played with a minimum of 1 red, 3 green, and 4
    blue cubes.
  - Game 3 must have been played with at least 20 red, 13 green, and 6
    blue cubes.
  - Game 4 required at least 14 red, 3 green, and 15 blue cubes.
  - Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the
    bag.

The power of a set of cubes is equal to the numbers of red, green, and blue
cubes multiplied together. The power of the minimum set of cubes in game 1
is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up
these five powers produces the sum 2286.

For each game, find the minimum set of cubes that must have been present.
What is the sum of the power of these sets? */

; Tested on: X16

%zeropage basicsafe
%option no_sysinit
%encoding iso
%import textio

main {

  uword totalPower

  sub start() {

    ubyte gameId
    uword inAddr = &input + 8
    for gameId in 1 to 100 {

      ubyte minRed = 0
      ubyte minGreen = 0
      ubyte minBlue = 0

      forStart:
      ubyte cubeCount
      if @(inAddr + 1) == ' ' {
        ; Followed by a space, so number is 1 digit
        cubeCount = @(inAddr) ^ 48 ; Subtract 48
        inAddr += 2
      } else {
        ; Number is 2 digits (no triple-digit nums in input)
        cubeCount = (@(inAddr) ^ 48) * 10 + (@(inAddr + 1) ^ 48)
        inAddr += 3
      }

      when @(inAddr) {
        'r' -> {
          if (cubeCount > minRed) minRed = cubeCount
          inAddr += 3
        }
        'g' -> {
          if (cubeCount > minGreen) minGreen = cubeCount
          inAddr += 5
        }
        'b' -> {
          if (cubeCount > minBlue) minBlue = cubeCount
          inAddr += 4
        }
      }

      if @(inAddr) == '\n' {
        totalPower += minRed as uword * minGreen as uword * minBlue as uword
;        txt.print_ub(minRed)
;        txt.spc()
;        txt.print_ub(minGreen)
;        txt.spc()
;        txt.print_ub(minBlue)
;        txt.spc()
;        txt.print_uw(totalPower)
;        txt.nl()

        if gameId < 9 inAddr += 9
        else if gameId < 99 inAddr += 10
        else inAddr += 11
        continue
      }

      inAddr += 2
      goto forStart

    }

    txt.nl()
    txt.print_uw(totalPower)
    txt.nl()

  }

  input:
    %asmbinary "input/day02.txt"

}