/* https://adventofcode.com/2023/day/1
--- Day 1: Trebuchet?! ---

Something is wrong with global snow production, and you've been selected to
take a look. The Elves have even given you a map; on it, they've used stars
to mark the top fifty locations that are likely to be having problems.

You've been doing this long enough to know that to restore snow operations,
you need to check all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on
each day in the Advent calendar; the second puzzle is unlocked when you
complete the first. Each puzzle grants one star. Good luck!

You try to ask why they can't just use a weather machine ("not powerful
enough") and where they're even sending you ("the sky") and why your map
looks mostly blank ("you sure ask a lot of questions") and hang on did you
just say the sky ("of course, where do you think snow comes from") when you
realize that the Elves are already loading you into a trebuchet ("please
hold still, we need to strap you in").

As they're making the final adjustments, they discover that their
calibration document (your puzzle input) has been amended by a very young
Elf who was apparently just excited to show off her art skills.
Consequently, the Elves are having trouble reading the values on the
document.

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
%import textio

main {

  const ubyte LF = 10 ; ISO chars don't work on non-X16 targets in Prog8 9.6
  ubyte firstDigit = 255
  ubyte lastDigit = 255
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
      if @(inI) != LF {
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