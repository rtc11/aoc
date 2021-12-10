import java.math.BigInteger

fun main() {
    println(part1())
    println(part2())
}

fun part1() = with(mapOf(')' to 3, ']' to 57, '}' to 1197, '>' to 25137)) {
    input("10.txt")
        .map(::removePairs)
        .mapNotNull { it.toCharArray().firstOrNull { bracket -> bracket in keys } } // discard valid lines
        .sumOf { endBracket -> this[endBracket]!! }
}

fun part2() = with(mapOf(')' to 1, ']' to 2, '}' to 3, '>' to 4)) {
    val opposite = mapOf('<' to '>', '(' to ')', '[' to ']', '{' to '}')
    input("10.txt")
        .map(::removePairs)
        .filterNot { it.toCharArray().any { bracket -> bracket in keys } } // discard corrupted lines
        .map(String::reversed) // expected closing order
        .map { remaining -> remaining.fold(0.toBigInteger()) { acc, bracket -> acc * 5 + this[opposite[bracket]]!! } }
        .sorted()
        .let { scores -> scores[scores.size / 2] } // middle value
}

fun removePairs(code: String): String =
    generateSequence(code, ::removeBracket)
        .zipWithNext() // windowed(2)
        .takeWhile { (codeBeforeRemoval, codeAfterRemoval) -> codeBeforeRemoval != codeAfterRemoval }
        .last() // last version of codeBefore and codeAfter ::removeBracket
        .second // code after last successful removal

// [({(<(())[]>[[{[]{<()<>> results in [({(<()>[[{{<>
fun removeBracket(code: String) = with(listOf("()", "[]", "<>", "{}")) {
    fold(code) { acc: String, pair: String -> acc.replace(pair, "") }
}

operator fun BigInteger.times(other: Int): BigInteger = multiply(other.toBigInteger())
operator fun BigInteger.plus(other: Int): BigInteger = add(other.toBigInteger())
