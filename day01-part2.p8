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

  ubyte firstDigit = 255
  ubyte lastDigit = 255
  uword totalCalibration

  ; one, two, six, four, five, nine, three, seven, eight
  ubyte[5] @zp wordBuffer

  sub start() {

    uword inI
    for inI in &input to &input + 21495 { ; File length - 1

      ; Append current to wordBuffer
      wordBuffer[0] = wordBuffer[1]
      wordBuffer[1] = wordBuffer[2]
      wordBuffer[2] = wordBuffer[3]
      wordBuffer[3] = wordBuffer[4]
      wordBuffer[4] = @(inI)

      if wordBuffer[4] >= '0' and wordBuffer[4] <= '9' {
        lastDigit = wordBuffer[4] ^ 48 ; subtract 48
        if firstDigit == 255 firstDigit = lastDigit
      } else { ; Oh gosh, it might be written out
        when wordBuffer[4] {
          iso:'e' -> {
            ; one, five, nine, three
            if wordBuffer[2] == iso:'i' {
              ; five, nine
              when wordBuffer[1] {
                iso:'f' -> {
                  if wordBuffer[3] != iso:'v' continue
                  lastDigit = 5
                  if firstDigit == 255 firstDigit = 5
                }
                iso:'n' -> {
                  if wordBuffer[3] != iso:'n' continue
                  lastDigit = 9
                  if firstDigit == 255 firstDigit = 9
                }
              }
            } else {
              ; one, three
              when wordBuffer[2] {
                iso:'o' -> {
                  if wordBuffer[3] != iso:'n' continue
                  lastDigit = 1
                  if firstDigit == 255 firstDigit = 1
                }
                iso:'r' -> {
                  if wordBuffer[0] != iso:'t' continue
                  if wordBuffer[1] != iso:'h' continue
                  if wordBuffer[3] != iso:'e' continue
                  lastDigit = 3
                  if firstDigit == 255 firstDigit = 3
                }
              }
            }
          }
          iso:'n' -> {
            ; seven
            if wordBuffer[0] != iso:'s' continue
            if wordBuffer[1] != iso:'e' continue
            if wordBuffer[2] != iso:'v' continue
            if wordBuffer[3] != iso:'e' continue
            lastDigit = 7
            if firstDigit == 255 firstDigit = 7
          }
          iso:'o' -> {
            ; two
            if wordBuffer[2] != iso:'t' continue
            if wordBuffer[3] != iso:'w' continue
            lastDigit = 2
            if firstDigit == 255 firstDigit = 2
          }
          iso:'r' -> {
            ; four
            if wordBuffer[1] != iso:'f' continue
            if wordBuffer[2] != iso:'o' continue
            if wordBuffer[3] != iso:'u' continue
            lastDigit = 4
            if firstDigit == 255 firstDigit = 4
          }
          iso:'t' -> {
            ; eight
            if wordBuffer[0] != iso:'e' continue
            if wordBuffer[1] != iso:'i' continue
            if wordBuffer[2] != iso:'g' continue
            if wordBuffer[3] != iso:'h' continue
            lastDigit = 8
            if firstDigit == 255 firstDigit = 8
          }
          iso:'x' -> {
            ; six
            if wordBuffer[2] != iso:'s' continue
            if wordBuffer[3] != iso:'i' continue
            lastDigit = 6
            if firstDigit == 255 firstDigit = 6
          }
          iso:'\n' -> {
;            txt.print_ub(firstDigit * 10 + lastDigit)
;            txt.nl()
            totalCalibration += firstDigit * 10 + lastDigit
            firstDigit = 255
          }
        }
      }
    }

    txt.nl()
    txt.print_uw(totalCalibration)
    txt.nl()

  }

  input:
    %asmbinary "input/day01.txt"

}