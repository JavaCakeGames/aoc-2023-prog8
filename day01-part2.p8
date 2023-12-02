/* https://adventofcode.com/2023/day/1
--- Part Two ---

Your calculation isn't quite right. It looks like some of the digits are
actually spelled out with letters: one, two, three, four, five, six, seven,
eight, and nine also count as valid "digits".

Equipped with this new information, you now need to find the real first and
last digit on each line. For example:

two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen

In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
Adding these together produces 281.

What is the sum of all of the calibration values? */

; Tested on: X16, C64 (remove @requirezp)

%zeropage basicsafe
%option no_sysinit
%import textio

main {

  ubyte @requirezp firstDigit = 255
  ubyte @requirezp lastDigit = 255
  uword @requirezp totalCalibration

  ; one, two, six, four, five, nine, three, seven, eight
  ubyte[5] @requirezp wordBuffer

  sub start() {

    uword inI
    for inI in &input to &input + 21495 { ; File length - 1

      ; Append current to wordBuffer
      wordBuffer[0] = wordBuffer[1]
      wordBuffer[1] = wordBuffer[2]
      wordBuffer[2] = wordBuffer[3]
      wordBuffer[3] = wordBuffer[4]
      wordBuffer[4] = @(inI)

      if firstDigit == 255 { ; First digit not yet found
        if wordBuffer[4] >= '0' and wordBuffer[4] <= '9' {
          firstDigit = wordBuffer[4] ^ 48 ; subtract 48
        } else { ; Oh gosh, it might be written out
          when wordBuffer[4] {
            iso:'e' -> {
              ; one, five, nine, three
              if wordBuffer[2] == iso:'i' {
                ; five, nine
                when wordBuffer[1] {
                  iso:'f' -> {
                    if wordBuffer[3] != iso:'v' goto whenEnd1
                    firstDigit = 5
                  }
                  iso:'n' -> {
                    if wordBuffer[3] != iso:'n' goto whenEnd1
                    firstDigit = 9
                  }
                }
              } else {
                ; one, three
                when wordBuffer[2] {
                  iso:'o' -> {
                    if wordBuffer[3] != iso:'n' goto whenEnd1
                    firstDigit = 1
                  }
                  iso:'r' -> {
                    if wordBuffer[0] != iso:'t' goto whenEnd1
                    if wordBuffer[1] != iso:'h' goto whenEnd1
                    if wordBuffer[3] != iso:'e' goto whenEnd1
                    firstDigit = 3
                  }
                }
              }
            }
            iso:'n' -> {
              ; seven
              if wordBuffer[0] != iso:'s' goto whenEnd1
              if wordBuffer[1] != iso:'e' goto whenEnd1
              if wordBuffer[2] != iso:'v' goto whenEnd1
              if wordBuffer[3] != iso:'e' goto whenEnd1
              firstDigit = 7
            }
            iso:'o' -> {
              ; two
              if wordBuffer[2] != iso:'t' goto whenEnd1
              if wordBuffer[3] != iso:'w' goto whenEnd1
              firstDigit = 2
            }
            iso:'r' -> {
              ; four
              if wordBuffer[1] != iso:'f' goto whenEnd1
              if wordBuffer[2] != iso:'o' goto whenEnd1
              if wordBuffer[3] != iso:'u' goto whenEnd1
              firstDigit = 4
            }
            iso:'t' -> {
              ; eight
              if wordBuffer[0] != iso:'e' goto whenEnd1
              if wordBuffer[1] != iso:'i' goto whenEnd1
              if wordBuffer[2] != iso:'g' goto whenEnd1
              if wordBuffer[3] != iso:'h' goto whenEnd1
              firstDigit = 8
            }
            iso:'x' -> {
              ; six
              if wordBuffer[2] != iso:'s' goto whenEnd1
              if wordBuffer[3] != iso:'i' goto whenEnd1
              firstDigit = 6
            }
          }
        }
      }

      whenEnd1:

      ; Cannot become if-else because some lines only have 1 digit
      if wordBuffer[4] >= '0' and wordBuffer[4] <= '9' {
        lastDigit = wordBuffer[4] ^ 48
      } else { ; Oh gosh, it might be written out
        when wordBuffer[4] {
          iso:'e' -> {
            ; one, five, nine, three
            if wordBuffer[2] == iso:'i' {
              ; five, nine
              when wordBuffer[1] {
                iso:'f' -> {
                  if wordBuffer[3] != iso:'v' goto whenEnd2
                  lastDigit = 5
                }
                iso:'n' -> {
                  if wordBuffer[3] != iso:'n' goto whenEnd2
                  lastDigit = 9
                }
              }
            } else {
              ; one, three
              when wordBuffer[2] {
                iso:'o' -> {
                  if wordBuffer[3] != iso:'n' goto whenEnd2
                  lastDigit = 1
                }
                iso:'r' -> {
                  if wordBuffer[0] != iso:'t' goto whenEnd2
                  if wordBuffer[1] != iso:'h' goto whenEnd2
                  if wordBuffer[3] != iso:'e' goto whenEnd2
                  lastDigit = 3
                }
              }
            }
          }
          iso:'n' -> {
            ; seven
            if wordBuffer[0] != iso:'s' goto whenEnd2
            if wordBuffer[1] != iso:'e' goto whenEnd2
            if wordBuffer[2] != iso:'v' goto whenEnd2
            if wordBuffer[3] != iso:'e' goto whenEnd2
            lastDigit = 7
          }
          iso:'o' -> {
            ; two
            if wordBuffer[2] != iso:'t' goto whenEnd2
            if wordBuffer[3] != iso:'w' goto whenEnd2
            lastDigit = 2
          }
          iso:'r' -> {
            ; four
            if wordBuffer[1] != iso:'f' goto whenEnd2
            if wordBuffer[2] != iso:'o' goto whenEnd2
            if wordBuffer[3] != iso:'u' goto whenEnd2
            lastDigit = 4
          }
          iso:'t' -> {
            ; eight
            if wordBuffer[0] != iso:'e' goto whenEnd2
            if wordBuffer[1] != iso:'i' goto whenEnd2
            if wordBuffer[2] != iso:'g' goto whenEnd2
            if wordBuffer[3] != iso:'h' goto whenEnd2
            lastDigit = 8
          }
          iso:'x' -> {
            ; six
            if wordBuffer[2] != iso:'s' goto whenEnd2
            if wordBuffer[3] != iso:'i' goto whenEnd2
            lastDigit = 6
          }
          iso:'\n' -> {
;            txt.print_ub(firstDigit * 10 + lastDigit)
;            txt.nl()
            totalCalibration += firstDigit * 10 + lastDigit
            firstDigit = 255
          }
        }
      }

      whenEnd2:

      ;if inI > 4000 break

    }

    txt.nl()
    txt.print_uw(totalCalibration)
    txt.nl()

  }

  input:
    %asmbinary "input/day01.txt"

}