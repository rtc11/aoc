import kotlin.system.exitProcess

typealias Board = List<Int>

var wins = mutableMapOf<List<Int>, Boolean>()
var counter = 0
var limit = 0

fun main() {
    val input = input("4.txt")
    val drawOrder = input.first().split(",").map(String::toInt)
    val boards = input
        .subList(1, input.size)
        .asSequence()
        .filter { it != "" }
        .windowed(5, 5)
        .map { board -> board.joinToString(" ").trim().split("\\s+".toRegex()) }
        .map { board -> board.map { it.toInt() } }
        .map { it.also(::println) }
        .toList()

    limit = boards.size

    println()

    drawOrder.forEachIndexed { index, _ ->
        val drawn = drawOrder.subList(0, index).also { println("drawn: $it") }
        boards.forEach { board ->
            bingoRows(board, drawn)
            bingoCols(board, drawn)
        }
    }
}

private fun bingoRows(board: Board, drawn: List<Int>) {
    board.windowed(5, 5).forEach { row ->
        isBingo(row, drawn, board)
    }
}

private fun bingoCols(board: Board, drawn: List<Int>) {
    for (i in 0 until 5) {
        val column = board.filterIndexed { index, _ -> (index + i) % 5 == 0 }
        isBingo(column, drawn, board)
    }
}

private fun isBingo(line: List<Int>, drawn: List<Int>, board: Board) {
    if (line.all { drawn.contains(it) } && !wins.containsKey(board)) {
        println("Bingo: $line")
        board.windowed(5, 5).forEach(::println)
        val unmarkedNums = board.filterNot { drawn.contains(it) }.sum()
        println("$unmarkedNums * ${drawn.last()} = ${unmarkedNums * drawn.last()}")

        wins[board] = true
        counter += 1
        if (counter == limit) {
            println("last board won")
            require(unmarkedNums * drawn.last() > 7644) { "Too low" }
            exitProcess(0)
        }
    }
}

