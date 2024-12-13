import std/strutils
import std/sequtils
import std/algorithm

type ordering_rule = (int, int)
type rules = seq[ordering_rule]
type update = seq[int]

type repr = (rules, seq[update])


func parse(input: string): repr =
    var orderings: seq[ordering_rule] = @[]
    var updates:seq[update] = @[]
    let groups = input.split("\n\n")
    for line in groups[0].splitLines:
        let order = line.split("|")
        let rule: ordering_rule = (parseInt(order[0]), parseInt(order[1]))
        orderings.add(rule)
    for line in groups[1].splitLines:
        let pages = line.split(",")
        updates.add(pages.map(parseInt))
    orderings.sort()
    return (orderings, updates)

func validate(rules: rules, update: update): bool = 
    for (a, b) in zip(update[0..^2], update[1..^1]):
        if rules.binarySearch((a, b)) == -1:
            return false
    return true


proc part1(input: repr): int =
    let (rules, updates) = input
    for update in updates:
        if rules.validate(update):
            let middleIdx: int = update.len div 2
            let middlePage = update[middleIdx]
            result += middlePage

proc asComparator(rules: rules): proc (x, y: int): int=
    proc (x, y: int): int = -rules.binarySearch((x, y))

proc part2(input: repr): int =
    let (rules, updates) = input
    for update in updates:
        if not rules.validate(update):
            let orderedUpdate = update.sorted(rules.asComparator)
            assert rules.validate(orderedUpdate)
            let middleIdx: int = orderedUpdate.len div 2
            let middlePage = orderedUpdate[middleIdx]
            result += middlePage

static:
    const test_input = dedent """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47"""
    assert test_input.parse.part1 == 143
    assert test_input.parse.part2 == 123

let parsed = stdin.readAll.parse
echo $part1(parsed)
echo $part2(parsed)