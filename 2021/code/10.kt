import java.math.BigInteger

fun main() {
    println(part1())
    println(part2())
}

fun part1() =
    with(mapOf(')' to 3, ']' to 57, '}' to 1197, '>' to 25137)) {
        input("10.txt")
            .map(::removePairs)
            .mapNotNull { it.toCharArray().firstOrNull { char -> char in keys } }
            .sumOf { this[it]!! }
    }

fun removePairs(code: String): String = with(listOf("()", "[]", "<>", "{}")) {
    generateSequence(code) { prev -> fold(prev) { acc, pair -> acc.replace(pair, "") } }
        .zipWithNext()
        .takeWhile { it.first != it.second }
        .last()
        .second
}

fun part2() =
    with(mapOf(')' to 1, ']' to 2, '}' to 3, '>' to 4)) {
        val opposite = mapOf('<' to '>', '(' to ')', '[' to ']', '{' to '}')
        input("10.txt")
            .asSequence()
            .map(::removePairs)
            .filterNot { it.toCharArray().any { char -> char in keys } }
            .map { it.reversed() }
            .map { remaining -> remaining.fold(0.toBigInteger()) { acc, char -> acc * 5 + this[opposite[char]]!! } }
            .sorted()
            .toList()
            .let { it[it.size / 2] }
    }

operator fun BigInteger.times(other: Int): BigInteger = multiply(other.toBigInteger())
operator fun BigInteger.plus(other: Int): BigInteger = add(other.toBigInteger())
