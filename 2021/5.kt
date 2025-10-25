fun main() {
    val map = mutableMapOf<Pair<Int, Int>, Int>() // coordinate to occurances
    input("5.txt") { it.toVents() }.forEach {
        if (it.horizontal()) it.xRange().forEach { x -> map[x to it.y1] = map.getOrPut(x to it.y1) { 0 } + 1 }
        else if (it.vertical()) it.yRange().forEach { y -> map[it.x1 to y] = map.getOrPut(it.x1 to y) { 0 } + 1 }
        else for (i in 0 until it.xRange().size) {
            val x = if (it.x1 < it.x2) it.x1 + i else it.x1 - i // +i for increased 45 degree slope and -i for decreased
            val y = if (it.y1 < it.y2) it.y1 + i else it.y1 - i
            map[x to y] = map.getOrPut(x to y) { 0 } + 1
        }
    }
    println(map.filterValues { it >= 2 }.map { it.value }.count()) // every count larger than 1 (overlaps)
}

fun String.toVents(): Vents = split("->").let { (from, to) ->
    val (x1, y1) = from.trim().split(",").map { it.toInt() }
    val (x2, y2) = to.trim().split(",").map { it.toInt() }
    Vents(x1, y1, x2, y2)
}

data class Vents(val x1: Int, val y1: Int, val x2: Int, val y2: Int) {
    fun vertical(): Boolean = x1 == x2  // frozen x
    fun horizontal(): Boolean = y1 == y2
    fun xRange(): List<Int> = (x1..x2) + (x2..x1).toList() // range only goes one way
    fun yRange(): List<Int> = (y1..y2) + (y2..y1).toList()
}
