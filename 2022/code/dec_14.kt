fun main() {
//    solve(input("dec_14_test.txt"), ::part1).also { println(it) }.also { require(it == 24) }
//    solve(input("dec_14.txt"), ::part1).also { println(it) }
    solve(input("dec_14_test.txt"), ::part2).also { println(it) }.also { require(it == 93) }
    solve(input("dec_14.txt"), ::part2).also { println(it) }
}

private fun solve(input: List<String>, solvePart: (List<String>) -> Int): Int = solvePart(input)

private fun part2(input: List<String>): Int {
    val coordinates = input
        .flatMap { inputLine -> walls(ranges(inputLine)) }
        .addMissingAirAbove()

    val cave = map(coordinates)

    val maxY = cave.maxBy { it.key.second }.key.second + 2

    var sandFilledCave: MutableMap<Pair<Int, Int>, String> = dropSand2(500, 0, cave, maxY)
//    print(sandFilledCave)
    var count = 0

    do {
        sandFilledCave = dropSand2(500, 0, sandFilledCave, maxY)
//        print(sandFilledCave)
        count++
        if (count % 1000 == 0) {
            println(sandFilledCave.count { it.value == "o" })
        }

    } while (sandFilledCave[500 to 0] == "+")

    print(sandFilledCave)
    return sandFilledCave.count { it.value == "o" }
}

private fun part1(input: List<String>): Int {
    val cave = input
        .flatMap { inputLine -> walls(ranges(inputLine)) }
        .addMissingAirAbove()

    var sandFilledCave: MutableMap<Pair<Int, Int>, String> = dropSand(500, 0, map(cave))
//    print(sandFilledCave)

    var sandAmount = sandFilledCave.count { it.value == "o" }

    do {
        sandFilledCave = dropSand(500, 0, sandFilledCave)
//        print(sandFilledCave)
        val newSandAmount = sandFilledCave.count { it.value == "o" }
    } while ((newSandAmount > sandAmount).also { sandAmount = newSandAmount })

    return sandAmount
}

private fun dropSand2(
    x: Int,
    y: Int,
    cave: MutableMap<Pair<Int, Int>, String>,
    maxY: Int
): MutableMap<Pair<Int, Int>, String> {
    if (y >= maxY) {
        return cave
    }
    (cave.minBy { it.key.first }.key.first..cave.maxBy { it.key.first }.key.first).forEach {
        if (cave[it to maxY] == null) cave[it to maxY] = "#"
    }

    // DOWN HAS WALL OR SAND
    return if (cave[x to y + 1] in listOf("#", "o")) {
        // DOWN LEFT IS AIR
        if (cave[x - 1 to y + 1] in listOf(".", null) && y+1 != maxY) {
            dropSand2(x - 1, y + 1, cave, maxY)
        } else if (cave[x + 1 to y + 1] in listOf(".", null) && y+1 != maxY) {
            dropSand2(x + 1, y + 1, cave, maxY)
        } else {
            cave.also { it[x to y] = "o" }
        }

        // DOWN IS BOTTOM FLOOR
    } else if (y + 1 == maxY) {
        cave.also { it[x to y] = "o" }
    }
    // DOWN IS AIR
    else {
        dropSand2(x, y + 1, cave, maxY)
    }
}

private fun dropSand(x: Int, y: Int, cave: MutableMap<Pair<Int, Int>, String>): MutableMap<Pair<Int, Int>, String> {
    val minX = cave.minBy { it.key.first }.key.first
    val maxX = cave.maxBy { it.key.first }.key.first
    val minY = cave.minBy { it.key.second }.key.second
    val maxY = cave.maxBy { it.key.second }.key.second

    if (x < minX || x > maxX || y < minY || y > maxY) {
        return cave // out of bounds
    }

    return if (cave[x to y + 1] in listOf("#", "o")) {
        if (cave[x - 1 to y + 1] in listOf("#", "o") && cave[x + 1 to y + 1] in listOf("#", "o")) {
            cave.also { it[x to y] = "o" }
        } else if (cave[x - 1 to y + 1] in listOf(".", null)) {
            dropSand(x - 1, y + 1, cave)
        } else {
            dropSand(x + 1, y + 1, cave)
        }
    } else {
        dropSand(x, y + 1, cave)
    }
}

private fun ranges(line: String): List<Coordinate> = line
    .split(" -> ")
    .map { coordinates ->
        coordinates
            .split(",")
            .map(String::toInt)
            .let { (x, y) -> Coordinate(x, y) }
    }

private fun walls(ranges: List<Coordinate>): List<Coordinate> = ranges
    .windowed(2, 1) { (from, to) ->
        (minOf(from.x, to.x)..maxOf(from.x, to.x)).flatMap { x ->
            (minOf(from.y, to.y)..maxOf(from.y, to.y)).map { y ->
                Coordinate(x, y)
            }
        }
    }.flatten()

private fun List<Coordinate>.addMissingAirAbove(): List<Coordinate> {
    val cave = map(this)
    return this + (0..minBy { it.y }.y).flatMap { y ->
        (minBy { it.x }.x..maxBy { it.x }.x).mapNotNull { x ->
            if (cave[x to y] == null) {
                Coordinate(x, y, if (x == 500 && y == 0) "+" else ".")
            } else null
        }
    }
}

private fun map(cave: List<Coordinate>): MutableMap<Pair<Int, Int>, String> =
    cave.fold(mutableMapOf()) { acc, coordinate ->
        acc[coordinate.x to coordinate.y] = coordinate.value
        acc
    }

private fun print(map: MutableMap<Pair<Int, Int>, String>) {
    val minX = map.minBy { it.key.first }.key.first
    val maxX = map.maxBy { it.key.first }.key.first
    val minY = map.minBy { it.key.second }.key.second
    val maxY = map.maxBy { it.key.second }.key.second

    for (y in minY..maxY) {
        for (x in minX..maxX) {
            print(map[x to y] ?: ".")
//            print(" ")
        }
        println()
    }
    println()
}

private data class Coordinate(
    val x: Int,
    val y: Int,
    val value: String = "#",
)
