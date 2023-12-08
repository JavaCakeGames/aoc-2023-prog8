/* https://adventofcode.com/2023/day/1

The newly-improved calibration document consists of lines of text; each
line originally contained a specific calibration value that the Elves now
need to recover. On each line, the calibration value can be found by
combining the first digit and the last digit (in that order) to form a
single two-digit number.

For example:

1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet

In this example, the calibration values of these four lines are 12, 38, 15,
and 77. Adding these together produces 142.

Consider your entire calibration document. What is the sum of all of the
calibration values? */

; Tested on: X16, C64

%zeropage basicsafe
%option no_sysinit
%encoding iso
%import textio

main {

  ubyte firstDigit, lastDigit = 255
  uword totalCalibration

  sub start() {

;    txt.iso()

    uword inI
    for inI in &input to &input + 21495 { ; File length - 1
      if firstDigit == 255 { ; First digit not yet found
        if @(inI) >= '0' { ; No short-circuit eval
          if @(inI) <= '9' firstDigit = @(inI) ^ 48 ; subtract 48
        }
      }
      ; Cannot become if-else because some lines only have 1 digit
      if @(inI) != '\n' {
        if @(inI) >= '0' {
          if @(inI) <= '9' lastDigit = @(inI) ^ 48
        }
      } else {
;        txt.print_ub(firstDigit * 10 + lastDigit)
;        txt.nl()
        totalCalibration += firstDigit * 10 + lastDigit
        firstDigit = 255
      }

;      if inI > 3000 break

    }

    txt.nl()
    txt.print_uw(totalCalibration)
    txt.nl()

  }

  input:
    %asmbinary "input/day01.txt"

}
