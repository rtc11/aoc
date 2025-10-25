package code

fun main() {
    val input = input("2.txt") { it.toPolicy() }

    val partOne = input.count { it.isValid() }
    println(partOne)
    if (partOne <= 351) error("wrong solution")

    val partTwo = input.count { it.isValidPartTwo() }
    println(partTwo)
}

private fun Policy.isValid(): Boolean {
    val occurances = password
        .chars()
        .filter { it == char.code }
        .count()

    return occurances in min..max
}

data class Policy(val min: Int, val max: Int, val char: Char, val password: String)

fun String.toPolicy(): Policy = Policy(
    min = this.substringBefore("-").toInt(),
    max = this.substringAfter("-").substringBefore(" ").toInt(),
    char = this.substringBefore(":").last(),
    password = this.substringAfterLast(" "),
)

private fun Policy.isValidPartTwo(): Boolean {
    val characters = password.toCharArray()

    val is1Valid = characters[min-1] == char
    val is2Valid = characters[max-1] == char

    return is1Valid xor is2Valid
}