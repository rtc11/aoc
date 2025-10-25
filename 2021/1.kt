fun main() {
    val testInput = input("1.test.txt") { it.toInt() }
    val input = input("1.txt") { it.toInt() }

    // part 1
    require(measureWindowed(1, testInput) == 7)
    println(measureWindowed(1, input))

    // part 2
    require(measureWindowed(3, testInput) == 5)
    println(measureWindowed(3, input))
}

// In groups of X, compare the sum of a group with the sum of the next group.
// Only increase counter if the next group is larger
// A, B, C < B, C, D ?
fun measureWindowed(windowSize: Int = 3, input: List<Int>): Int =
    input.windowed(windowSize).windowed(2).count { (group, nextGroup) ->
        group.sum() < nextGroup.sum()
    }