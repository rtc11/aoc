package code

fun main() {
    val slopesPart1 = listOf(3 to 1)
    require(7L == accumulateByProduct(input("test-3.txt"), slopesPart1, true))
    val answerPart1 = accumulateByProduct(input("3.txt"), slopesPart1)
    require(answerPart1 == 292L)
    println("Part One: $answerPart1")

    val slopesPart2 = listOf(1 to 1, 3 to 1, 5 to 1, 7 to 1, 1 to 2)
    require(336L == accumulateByProduct(input("test-3.txt"), slopesPart2, true))
    val answerPart2 = accumulateByProduct(input("3.txt"), slopesPart2)
    require(answerPart2 == 9354744432L)
    println("Part Two: $answerPart2")
}

private fun accumulateByProduct(input: List<String>, slopes: List<Pair<Int, Int>>, isTest: Boolean = false): Long {
    fun countTrees(input: List<String>, rightStep: Int = 3, downStep: Int = 1): Int {
        fun String.isNextTree(rowNum: Int, rightStep: Int, downStep: Int): Boolean {
            val colNum = (rowNum / downStep) * rightStep

            // the pattern repeats column-wise, use modulus to "skew" back to start if out of bounds
            return when (this[colNum % length]) {
                '#' -> true
                else -> false
            }
        }

        return input.foldIndexed(0) { index, acc, row ->
            when (index !in 0 until downStep && index % downStep == 0 && row.isNextTree(index, rightStep, downStep)) {
                true -> acc + 1
                false -> acc
            }
        }
    }

    return slopes.map { (rightStep, downStep) ->
        countTrees(input, rightStep, downStep)
    }.fold(1) { accumulated, item ->
        accumulated * item
    }
}
