fun main() {
    input("dec_01_test.txt").let(::part1).also { require(it == 24000) }
    input("dec_01_part1.txt").let(::part1).also(::println)
    input("dec_01_test.txt").let(::part2).also { require(it == 45000) { "was $it" } }
    input("dec_01_part1.txt").let(::part2).also(::println)
}

fun part1(input: List<String>): Int = calories(input).max()
fun part2(input: List<String>): Int = calories(input).sortedDescending().take(3).sum()

fun calories(input: List<String>): List<Int> {
    val calories = mutableListOf<Int>()
    var calorie = 0

    input.forEach {
        if (it != "") calorie += it.toInt()
        else calories.add(calorie).also { calorie = 0 }
    }
    calories.add(calorie)
    return calories
}
