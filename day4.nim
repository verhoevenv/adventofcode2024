import std/strutils
import std/tables

type xy = (int, int)
type direction = enum
    n, ne, e, se, s, sw, w, nw

func offset(dir: direction): xy =
    case dir
        of n: (-1, 0)
        of ne: (-1, 1)
        of e: (0, 1)
        of se: (1, 1)
        of s: (1, 0)
        of sw: (1, -1)
        of w: (0, -1)
        of nw: (-1, -1)

func `+`(a: xy, b: xy): xy =
    (a[0] + b[0], a[1] + b[1])


type repr = Table[xy, char]


func parse(input: string): repr =
    let lines = input.splitLines
    for y, line in lines.pairs:
        for x, c in line.pairs:
            result[(x,y)] = c

func wordAt(grid: repr, loc: xy, dir: direction, length: int): string =
    var pos = loc
    var word = ""
    for i in 0..<length:
        if not grid.hasKey(pos):
            return word
        let c = grid[pos]
        word.add(c)
        pos = pos + dir.offset
    return word

func hasXMAS(grid: repr, loc: xy, dir: direction): bool = 
    return grid.wordAt(loc, dir, 4) == "XMAS"

func `hasX-MAS`(grid: repr, loc: xy): bool = 
    let word1 = grid.wordAt(loc + ne.offset, sw, 3)
    let word2 = grid.wordAt(loc + nw.offset, se, 3)
    return (word1 == "MAS" or word1 == "SAM") and
            (word2 == "MAS" or word2 == "SAM")

proc part1(input: repr): int =
    var count = 0
    for loc, c in input:
        for dir in direction:
            if input.hasXMAS(loc, dir):
                inc count
    return count

proc part2(input: repr): int =
    var count = 0
    for loc, c in input:
        if input.`hasX-MAS`(loc):
            inc count
    return count

static:
    const test_input = dedent """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX"""
    assert test_input.parse.part1 == 18
    assert test_input.parse.part2 == 9

let parsed = stdin.readAll.parse
echo $part1(parsed)
echo $part2(parsed)