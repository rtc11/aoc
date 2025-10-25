fun main() {
    solve(input("dec_03_test.txt"), ::part1).also { println(it) }.also { require(it == 157) }
    solve(input("dec_03.txt"), ::part1).also { println(it) }.also { require(it == 7737) }
    solve(input("dec_03_test.txt"), ::part2).also { println(it) }.also { require(it == 70) }
    solve(input("dec_03.txt"), ::part2).also { println(it) }.also { require(it == 2697) }
}

private fun solve(input: List<String>, solvePart: (List<String>) -> Int): Int = solvePart(input)

private fun part1(input: List<String>): Int {
    fun singleUnion(a: String, b: String) = a.toList().filter { b.contains(it) }.distinct().single()

    return input.sumOf { rucksack ->
        val halfRucksack = rucksack.length / 2
        val compartments = rucksack.windowed(halfRucksack, halfRucksack).also { require(it.size == 2) }
        val commonItem = singleUnion(compartments[0], compartments[1])
        withPriority(commonItem).second
    }
}

private fun part2(input: List<String>): Int {
    fun singleUnion(a: String, b: String, c: String) =
        a.toList().filter { b.contains(it) && c.contains(it) }.distinct().single()

    return input.windowed(3, 3) { rucksacks ->
        val (a, b, c) = rucksacks
        val badge = singleUnion(a, b, c)
        withPriority(badge).second
    }.sum()
}

private fun withPriority(char: Char) = char to if (char.isUpperCase()) char.code - 38 else char.code - 96
