//val mapped = mutableSetOf<Pair<Int, Int>>()
fun main() {
    val input = input("9.txt") { row -> row.toList().map { it.toString().toInt() } }
    val lowPoints = mutableMapOf<Pair<Int, Int>, Int>()

    for (y in input.indices) {
        for (x in 0 until input[0].size) {
            with(
                listOf(
                    input.getOrNull(y - 1)?.get(x),
                    input.getOrNull(y + 1)?.get(x),
                    input[y].getOrNull(x - 1),
                    input[y].getOrNull(x + 1)
                )
            ) { if (all { it == null || it > input[y][x] }) lowPoints[y to x] = input[y][x] }
        }
    }

    // first is y and second is x in input[y][x]
    fun Pair<Int, Int>.neighbours(): List<Pair<Int, Int>> = listOf(
        (first - 1 to second) to input.getOrNull(first - 1)?.get(second),
        (first + 1 to second) to input.getOrNull(first + 1)?.get(second),
        (first to second - 1) to input[first].getOrNull(second - 1),
        (first to second + 1) to input[first].getOrNull(second + 1)
    ).filter { it.second != null }.map { it.first }

    fun getBasinSize(point: Pair<Int, Int>): Int {
        val visited = mutableSetOf(point)
        with(mutableListOf(point)) {
            while (isNotEmpty())
                removeFirst()
                    .neighbours()
                    .filter { it !in visited }
                    .filter { (y, x) -> input[y][x] != 9 }
                    .let {
                        visited.addAll(it)
                        addAll(it)
                    }
        }
        return visited.size
    }

    val part2 = lowPoints.map { getBasinSize(it.key) }.sortedDescending().take(3).reduce { i, acc -> acc * i }
    val part1 = lowPoints.map { it.value + 1 }.reduce { a, b -> a + b }
    println("part1: $part1")
    println("part2: $part2")
}


