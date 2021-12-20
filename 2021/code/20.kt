fun main() {
    input("20.test.txt").countLit(2) // 35
    input("20.test.txt").countLit(50) // 3351

    input("20.txt").countLit(2) // 5395
    input("20.txt").countLit(50) // 19959 an 18967 is too high
}

fun List<String>.countLit(iterations: Int) {
    val img = takeLastWhile { l -> l != "" }.enlarge(iterations + 3)
    val alg = first()
    recursive(img, alg, iterations)
//        .print()
        .slice(2 until img.size - 2)
        .map { it.slice(2 until it.length - 2) }
        .sumOf { it.count { c -> c == '#' } }
        .let { println("Part One $it") }
}

private fun recursive(img: List<String>, alg: String, times: Int): List<String> =
    when (times) {
        0 -> img
        else -> recursive(img.enhance(alg), alg, times - 1)
    }

private fun List<String>.enlarge(times: Int = 1): List<String> = map { ".$it." }
    .toMutableList()
    .apply {
        add(0, ".".repeat(first().length))
        add(".".repeat(first().length))
    }
    .let { if (times - 1 > 0) it.enlarge(times - 1) else it }

private fun List<String>.getNeightbours(x: Int, y: Int): String {
    var res = ""
    for (i in listOf(-1, 0, 1))
        for (j in listOf(-1, 0, 1))
            res += this[y + i][x + j]
    return res
}

private fun List<String>.enhance(alg: String): List<String> {
    return mapIndexed { yIndex, y ->
        y.mapIndexed { xIndex, x ->
            if (yIndex > 0 && xIndex > 0 && yIndex < size - 1 && xIndex < first().length - 1) {
                val binary = getNeightbours(xIndex, yIndex).map { if (it == '.') "0" else "1" }.join()
                alg[binaryToDecimal(binary)]
            } else x
        }.join()
    }
}

private fun List<String>.print(): List<String> = onEach { y -> println(y.map { x -> "$x" }.join()) }.also { println() }
