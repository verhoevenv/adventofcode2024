import std/strutils
import regex

type mul = (int,int)
type repr = seq[mul]

func parse1(input: string): repr =
    for m in findAll(input, re2"mul\((\d{1,3}),(\d{1,3})\)"):
        let m1 = parseInt(input[m.group(0)])
        let m2 = parseInt(input[m.group(1)])
        result.add((m1, m2))

func find_smaller(coll: seq[int], n: int): int = 
    result = -1
    for item in coll:
        if item > n:
            return
        else:
            result = item

func parse2(input: string): repr =
    var muls = newSeq[(int, (int, int))]()
    var dos = newSeq[int]()
    var donts = newSeq[int]()
    for m in findAll(input, re2"mul\((\d{1,3}),(\d{1,3})\)"):
        let m1 = parseInt(input[m.group(0)])
        let m2 = parseInt(input[m.group(1)])
        muls.add((m.boundaries.a, (m1, m2)))
    for m in findAll(input, re2"do\(\)"):
        dos.add(m.boundaries.a)
    for m in findAll(input, re2"don't\(\)"):
        donts.add(m.boundaries.a)
    for (pos, mul) in muls:
        let last_do = dos.find_smaller(pos)
        let last_dont = donts.find_smaller(pos)
        if last_do > last_dont or last_dont == -1:
            result.add(mul)

func calc(input: repr): int =
    for (m1, m2) in input:
        result += m1 * m2

static:
    const test_input1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    assert test_input1.parse1.calc == 161
    const test_input2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert test_input2.parse2.calc == 48

let input = stdin.readAll
echo $input.parse1.calc
echo $input.parse2.calc