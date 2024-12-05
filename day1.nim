import std/strutils
import std/algorithm
import std/sequtils

type repr = (seq[int], seq[int])

func parse(input: string): repr =
    var list1: seq[int] = @[]
    var list2: seq[int] = @[]
    for line in input.splitLines:
        var line: seq[string] = splitWhitespace(line)
        list1.add(parseInt(line[0]))
        list2.add(parseInt(line[1]))
    return (list1, list2)

func part1(input: repr): int =
    var (list1, list2) = input
    list1.sort()
    list2.sort()

    var diffs: int
    for (i1, i2) in zip(list1, list2):
        diffs += abs(i2 - i1)
    return diffs

func part2(input: repr): int =
    var (list1, list2) = input

    var score: int
    for item in list1:
        let c = list2.count(item)
        score += item * c
    return score

static:
    const test_input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3"""
    assert test_input.parse.part1 == 11
    assert test_input.parse.part2 == 31

let parsed = stdin.readAll.parse
echo $part1(parsed)
echo $part2(parsed)