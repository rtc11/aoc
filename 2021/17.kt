import kotlin.math.abs

fun main() {
    val test = "target area: x=20..30, y=-10..-5"
    val (xRange, yRange) = test.drop(13).split(", ").let { (x, y) ->
        val xRange = x.drop(2).split("..").map { it.toInt() }.sorted().let { (x0, x1) -> x0..x1 }
        val yRange = y.drop(2).split("..").map { it.toInt() }.sorted().let { (y0, y1) -> y0..y1 }
        xRange to yRange
    }

    for (y in yRange.last until abs(yRange.first)) {
        for (x in 0 until xRange.last) {
            if (x == 0 && y == 0) print("S")
            else if (x in xRange && y in yRange) print("T")
            else print(".")
        }
        println()
    }
}
