/* https://adventofcode.com/2023/day/3
You and the Elf eventually reach a gondola lift station; he says the
gondola lift will take you up to the water source, but this is as far as he
can bring you. You go inside.

It doesn't take long to find the gondolas, but there seems to be a problem:
they're not moving.

"Aaah!"

You turn around to see a slightly-greasy Elf with a wrench and a look of
surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working
right now; it'll still be a while before I can fix it." You offer to help.

The engineer explains that an engine part seems to be missing from the
engine, but nobody can figure out which one. If you can add up all the part
numbers in the engine schematic, it should be easy to work out which part
is missing.

The engine schematic (your puzzle input) consists of a visual
representation of the engine. There are lots of numbers and symbols you
don't really understand, but apparently any number adjacent to a symbol,
even diagonally, is a "part number" and should be included in your sum.
(Periods (.) do not count as a symbol.)

Here is an example engine schematic:

467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..

In this schematic, two numbers are not part numbers because they are not
adjacent to a symbol: 114 (top right) and 58 (middle right). Every other
number is adjacent to a symbol and so is a part number; their sum is 4361.

Of course, the actual engine schematic is much larger. What is the sum of
all of the part numbers in the engine schematic? */

; Tested on: X16

%zeropage basicsafe
%option no_sysinit
%import textio
%import floats

main {

  ; Symbols: #$%&*+-/=@

  ; Utilising VERA FX for this addition might be marginally faster?
  ; Of course, it would break C64 compatibility.
  ; "If you set one of the inputs of the multiplier to 1,
  ; you can add 16-bit numbers to a 32-bit accumulator."
  uword sum
  ubyte sumHigh ; Bits 16-23 of sum

  sub start() {

    ; Thoughts:
    ; Initially I attempted to scan for symbols and then determine adjacent
    ; numbers from there. But it got far too complicated. If we take "above" as
    ; an example, a three-digit number can be centred above the symbol. Or it
    ; can be offset one left or right. Or it might not even be three digits.
    ; And that's before we get onto diagonals!
    ;
    ; However, such an approach would've been able to take advantage of the
    ; fact there are no symbols on the first or last lines, or the first and
    ; last 3 columns, as well as the fact there is never a symbol immediately
    ; followed by another symbol.

    uword inAddr = &input

    do {

      ubyte numLength = 0
      uword number
      if @(inAddr) >= '0' { ; No short-circuit eval in Prog8
        if @(inAddr) <= '9' {

          ; We have found a number
          numLength = 1
          inAddr++
          if @(inAddr) >= '0' {
            if @(inAddr) <= '9' {
              numLength++ ; 2
              inAddr++
              if @(inAddr) >= '0' {
                if @(inAddr) <= '9' {
                  numLength++ ; 3
                  inAddr++
                }
              }
            }
          }

          bool symbolAdjacent = false

          ; Check right direction for symbol.
          ; We already know there isn't a number at this position.
          if @(inAddr) != iso:'.' {
            if @(inAddr) != iso:'\n' {
              symbolAdjacent = true
              goto ifSymAdj
            }
          }

          ; Check left direction for symbol.
          ; There can't be a number at this position.
          if @(inAddr - numLength - 1) != iso:'.' {
            if @(inAddr - numLength - 1) != iso:'\n' {
              symbolAdjacent = true
              goto ifSymAdj
            }
          }

          ; Astonishingly, the input data never has a number directly above or
          ; below another one. Therefore, it is safe to assume anything that
          ; isn't a dot or \n is a symbol.

          ; Check up for symbol.
          uword tmpAddr = inAddr - numLength - 142
          repeat numLength + 2 {
            if @(tmpAddr) != iso:'.' {
              if @(tmpAddr) != iso:'\n' {
                symbolAdjacent = true
                goto ifSymAdj
              }
            }
            tmpAddr++
          }

          ; Check down for symbol.
          tmpAddr = inAddr - numLength + 140
          repeat numLength + 2 {
            if @(tmpAddr) != iso:'.' {
              if @(tmpAddr) != iso:'\n' {
                symbolAdjacent = true
                goto ifSymAdj
              }
            }
            tmpAddr++
          }

          ifSymAdj:
          if symbolAdjacent {
            when numLength{
              3 -> {
                number = ((@(inAddr - 1) ^ 48) + ((@(inAddr - 2) ^ 48) * 10)) +
                         ((@(inAddr - 3) ^ 48) as uword * 100)
              }
              2 -> {
                number = (@(inAddr - 1) ^ 48) + ((@(inAddr - 2) ^ 48) * 10)
              }
              1 -> {
                number = @(inAddr - 1) ^ 48
              }
            }

            sum += number
            if_cs sumHigh++

          }

        }
      }

      inAddr++

    } until inAddr >= &padding2

    txt.nl()
    floats.print_f((sumHigh as float * 65536.0) + sum as float)
    txt.nl()

  }

  ; By adding additional blank rows, it is safe for the program to blindly
  ; check above the top row and below the bottom for symbols.
  padding1:
    %asmbinary "input/day03-padding.txt"

  input:
    %asmbinary "input/day03.txt"

  padding2:
    %asmbinary "input/day03-padding.txt"

}