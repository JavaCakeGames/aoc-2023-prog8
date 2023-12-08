/* https://adventofcode.com/2023/day/6

As the race is about to start, you realize the piece of paper with race
times and record distances you got earlier actually just has very bad
kerning. There's really only one race - ignore the spaces between the
numbers on each line.

So, the example from before:

Time:      7  15   30
Distance:  9  40  200

...now instead means this:

Time:      71530
Distance:  940200

Now, you have to figure out how many ways there are to win this single
race. In this example, the race lasts for 71530 milliseconds and the record
distance you need to beat is 940200 millimeters. You could hold the button
anywhere from 14 to 71516 milliseconds and beat the record, a total of
71503 ways!

How many ways can you beat the record in this one much longer race? */

; Tested on: X16, virtual

%zeropage basicsafe
%option no_sysinit
%import textio
%import floats

main {

  ; Input:
  float time = 35937366.0
  float distance = 212206012011044.0

  ; Takes approximately 100 minutes to run on Commander X16.
  ; So let's call it 800 minutes on Commodore 64.
  ; Obviously this is a stupid approach - there are faster ways.

  sub start() {

    float minButtonTime
    float maxButtonTime

    txt.print("calculating min time...\n")
    float buttonTime = 1
    repeat {
      float dst = buttonTime * (time - buttonTime)
      if dst > distance {
        minButtonTime = buttonTime
        break
      }
      buttonTime++
    }

    txt.print("calculating max time...\n")
    buttonTime = time - 1
    repeat {
      dst = buttonTime * (time - buttonTime)
      if dst > distance {
        maxButtonTime = buttonTime
        break
      }
      buttonTime--
    }

    txt.nl()
    floats.print_f(maxButtonTime - minButtonTime + 1)
    txt.nl()

  }

}
