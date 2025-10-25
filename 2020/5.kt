package code

import kotlin.math.pow

fun main() {
    input("test-5.txt").forEachIndexed { i, it ->
        when (i) {
            0 -> require(calc(it) == 357) { "$it should be 357" }
            1 -> require(calc(it) == 567) { "$it should be 567" }
            2 -> require(calc(it) == 119) { "$it should be 119" }
            3 -> require(calc(it) == 820) { "$it should be 820" }
        }
    }

    val partOne = input("5.txt") { calc(it) }.maxOrNull()
    println("Part one: $partOne")

    // 108 is too low
//    val seats = mutableMapOf<Int, Int>()
//    for (i in 0..127) seats[i] = -1
//    input("5.txt").forEach { seats[row(it)] = col(it) }
//    seats.filterValues { it == -1 }.forEach { println("Part two: $it") }

    val partTwoInput = input("5.txt") { calc(it) }.sorted()
    partTwoInput.forEachIndexed { index, item ->
        when (index + 100) {
            item -> {}
            else -> {
                runCatching {
                    if (partTwoInput[index + 1] == index + 101 && partTwoInput[index - 1] == index + 99) println("Your seat: $item")
                }
            }
        }
    }
}

fun calc(code: String): Int = row(code) * 8 + col(code)
fun row(code: String): Int = binaryToInt(code.substring(0 until 7), zero = 'F', one = 'B')
fun col(code: String): Int = binaryToInt(code.substring(7 until 10), zero = 'L', one = 'R')

fun binaryToInt(input: String, zero: Char = '0', one: Char = '1'): Int {
    val binaryString = input.replace(zero.toString(), "0").replace(one.toString(), "1")
    return binaryString.reversed().foldIndexed(0.toDouble()) { i, acc, bit ->
        acc + bit.toString().toDouble() * 2.toDouble().pow(i.toDouble())
    }.toInt()
}
