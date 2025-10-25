package code

fun main() {
    val input = input("1.txt") { it.toInt() }

    val partOne = sumTwo(input, expected = 2020) { a, b ->
        a * b
    }
    println(partOne)

    val partTwo = sumThree(input, expected = 2020) { a, b, c ->
        a * b * c
    }
    println(partTwo)
}

fun sumTwo(input: List<Int>, expected: Int = 2020, expression: (Int, Int) -> Int): Int? {
    input.forEach { left ->
        input.forEach { right ->
            when (left + right) {
                expected -> return expression(left, right)
            }
        }
    }
    return null
}

fun sumThree(input: List<Int>, expected: Int = 2020, expression: (Int, Int, Int) -> Int): Int? {
    input.forEach { left ->
        input.forEach { right ->
            input.forEach { middle ->
                when (left + right + middle) {
                    expected -> return expression(left, middle, right)
                }
            }
        }
    }
    return null
}
