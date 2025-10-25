fun main() {
    solve(input("dec_04_test.txt"), ::part1).also { println(it) }.also { require(it == 2) }
    solve(input("dec_04.txt"), ::part1).also { println(it) }
    solve(input("dec_04_test.txt"), ::part2).also { println(it) }.also { require(it == 4) }
    solve(input("dec_04.txt"), ::part2).also { println(it) }
}

private fun solve(input: List<String>, solvePart: (List<String>) -> Int): Int = solvePart(input)

private fun part1(input: List<String>): Int {
    return input.count { pairs ->
        val (elfA, elfB) = pairs.split(",").map { it.split("-").map { id -> id.toInt() } }

        val (elfAMin, elfAMax) = elfA.min() to elfA.max()
        val (elfBMin, elfBMax) = elfB.min() to elfB.max()

        (elfBMin >= elfAMin && elfBMax <= elfAMax) || (elfAMin >= elfBMin && elfAMax <= elfBMax)
    }
}

private fun part2(input: List<String>): Int {
    return input.count { pairs ->
        val (a, b) = pairs.split(",").map { it.split("-").map { id -> id.toInt() } }

        val aRange = (a.min() .. a.max())

        aRange.any {
            it >= b.min() && it <= b.max()
        }

    }
}