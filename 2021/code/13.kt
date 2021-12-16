fun main() {
    val input = input("13.txt")
    val folds = input.takeLastWhile { it != "" }.map { it.substringAfter("fold along ") }
    val xLength = 2 * folds.filter { it.contains("x=") }.map { it.replace("x=", "") }.maxOf { it.toInt() } + 1
    val yLenght = 2 * folds.filter { it.contains("y=") }.map { it.replace("y=", "") }.maxOf { it.toInt() } + 1
    val matrix = Array(yLenght) { CharArray(xLength) { '.' } }
    input.takeWhile { it != "" }.map { it.split(",").map(String::toInt) }.forEach { (x, y) -> matrix[y][x] = '#' }

    fun partOne() = folds.first().let { action ->
        if (action.contains("x=")) matrix.foldOnX(action.replace("x=", "").toInt())
        else matrix.foldOnY(action.replace("y=", "").toInt())
    }

    fun partTwo() {
        var folded = matrix
        folds.forEach { action ->
            folded = if (action.contains("x=")) folded.foldOnX(action.replace("x=", "").toInt())
            else folded.foldOnY(action.replace("y=", "").toInt())
        }
    }

    partOne()
    partTwo()
}

fun Array<CharArray>.foldOnY(fold: Int): Array<CharArray> {
    val folded = sliceArray(0 until fold) // top
    val bottom = takeLast(fold).reversed().toTypedArray() // bottom
    bottom.forEachIndexed { y, xs -> xs.forEachIndexed { x, char -> if (char == '#') folded[y][x] = char } } // merge
    return folded.also { it.print() }
}

fun Array<CharArray>.foldOnX(fold: Int): Array<CharArray> {
    fun CharArray.addReversedRightSide(xs: CharArray, fold: Int) = apply {
        xs.slice(fold until xs.size).reversed().forEachIndexed { x, char -> if (char == '#') this[x] = char }
    }

    return map { xs -> xs.slice(0 until fold).toCharArray().addReversedRightSide(xs, fold) }
        .toTypedArray()
        .also(Array<CharArray>::print)
}

private fun Array<CharArray>.print() {
    forEach { println(it) }
    println(sumOf { y -> y.count { x -> x == '#' } })
    println()
}
