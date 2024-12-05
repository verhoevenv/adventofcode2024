import std/strutils
import std/sequtils
import std/sugar

type repr = seq[seq[int]]

func parse(input: string): repr =
    result = @[]
    for line in input.splitLines:
        var line: seq[string] = splitWhitespace(line)
        result.add(line.map(parseInt))

func `-`(a: seq[int], b: seq[int]): seq[int] =
    result = @[]
    for idx, (i1, i2) in pairs(zip(a, b)):
        result.add(i1 - i2)

func isSafe(levels: seq[int]): bool = 
    let diffs = levels[1..^1] - levels[0..^2]
    let increasing = diffs[0] > 0
    if increasing:
        if any(diffs, x => x <= 0):
            return false
        if any(diffs, x => not (x in 1..3)):
            return false
    else:
        if any(diffs, x => x >= 0):
            return false
        if any(diffs, x => not (x in (-3)..(-1))):
            return false
    return true

proc isDampenedSafe(report: seq[int]): bool =
    for i in 0..<report.len:
        var copy = seq(report)
        copy.delete(i)
        if copy.isSafe:
            return true
    return false

proc part1(input: repr): int =
    input.map(isSafe).count(true)

proc part2(input: repr): int =
    input.map(isDampenedSafe).count(true)

static:
    assert isSafe(@[7, 6, 4, 2, 1])
    assert isDampenedSafe(@[7, 6, 4, 2, 1])
    assert not isSafe(@[1, 2, 7, 8, 9])
    assert not isDampenedSafe(@[1, 2, 7, 8, 9])
    assert not isSafe(@[1, 3, 2, 4, 5])
    assert isDampenedSafe(@[1, 3, 2, 4, 5])

    const test_input = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9"""
    assert test_input.parse.part1 == 2
    assert test_input.parse.part2 == 4

let parsed = stdin.readAll.parse
echo $part1(parsed)
echo $part2(parsed)