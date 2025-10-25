import com.diogonunes.jcolor.Ansi
import com.diogonunes.jcolor.Attribute
import java.util.*

fun main() {
    val input = input("15.txt") // 467 462 too high
    part1(input)
    part2(input)
}

private fun part1(input: List<String>) {
    val cave = input.map { row -> row.map { risk -> risk.digitToInt() }.toIntArray() }.toTypedArray()
    val totalRisk = cave.traverse()
    println(totalRisk)
}

private fun part2(input: List<String>) {
    val cave = input.map { row -> row.map { risk -> risk.digitToInt() }.toIntArray() }.toTypedArray()
    val totalRisk = cave.traverse(Matrix(cave.first().size * 5 - 1, (cave.size * 5) - 1))
    println(totalRisk)
}

private fun Array<IntArray>.traverse(dest: Matrix = Matrix(first().lastIndex, lastIndex)): Int {
    val queue = PriorityQueue<Path>().apply { add(Path(Matrix(0, 0), 0)) }
    val visited = mutableSetOf<Matrix>()

    while (queue.isNotEmpty()) {
        val path = queue.poll()
        if (path.point == dest) return path.totalRisk
        if (path.point !in visited) {
            visited.add(path.point)
            path.point
                .neighbors()
                .filter { it.x in (0..dest.x) && it.y in (0..dest.y) }
                .forEach { queue.offer(Path(it, path.totalRisk + this[it])) }
        }
    }
    error("no path")
}

data class Matrix(val x: Int, val y: Int) {
    fun neighbors(): List<Matrix> = listOf(
        Matrix(x, y + 1),
        Matrix(x, y - 1),
        Matrix(x + 1, y),
        Matrix(x - 1, y)
    )
}

data class Path(val point: Matrix, val totalRisk: Int) : Comparable<Path> {
    override fun compareTo(other: Path): Int = totalRisk - other.totalRisk
}

private operator fun Array<IntArray>.get(point: Matrix): Int {
    val dx = point.x / this.first().size
    val dy = point.y / this.size
    val originalRisk = this[point.y % this.size][point.x % this.first().size]
    val newRisk = (originalRisk + dx + dy)
    return newRisk.takeIf { it < 10 } ?: (newRisk - 9)
}

private fun print(text: String, color: Int) = print(Ansi.colorize(text, Attribute.TEXT_COLOR(color)))
private fun printPosition(input: List<String>, path: List<Node>) {
    val (gray, red) = 7 to 1
    input.forEachIndexed { y, row ->
        row.forEachIndexed { x, item ->
            path.firstOrNull { it.name.split(",").map(String::toInt).let { (x1, y1) -> x1 == x && y1 == y } }
                ?.let { print(item.toString(), red) } ?: print(item.toString(), gray)
        }
        println()
    }
}
