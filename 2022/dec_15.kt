import kotlin.math.abs

fun main() {

    part1(input("dec_15_test.txt"), 10)
//    part1(input("dec_15.txt"), 2000000)
}

private fun part1(input: List<String>, row: Int) {

    val yRow = mutableMapOf<Int, Int>()
    val sensors = input.map(Sensor::parse)

    sensors.forEach { sensor ->
        val distY = abs(row - sensor.point.y)
        val rowLength = (sensor.dist() - distY) * 2

        if (sensor.isRightOfBeacon()) {
            for (x in sensor.beacon.x..sensor.beacon.x + rowLength) {
                yRow.putIfAbsent(x, row)
            }
        } else {
            for (x in sensor.beacon.x - rowLength..sensor.beacon.x) {
                yRow.putIfAbsent(x, row)
            }
        }
    }

    println("part1: ${yRow.size}")
    println(yRow.toSortedMap())
}

data class Point<X, Y>(val x: X, val y: Y)

data class Sensor(val point: Point<Int, Int>, val beacon: Point<Int, Int>) {
    fun dist() = abs(point.x - beacon.x) + abs(point.y - beacon.y)
    fun isRightOfBeacon() = point.x > beacon.x

    companion object {
        fun parse(str: String): Sensor =
            Sensor(
                point = str.takeWhile { it != ':' }.replace("Sensor at ", "").toPoint(),
                beacon = str.dropWhile { it != ':' }.replace(": closest beacon is at ", "").toPoint(),
            )
    }
}

private fun String.toPoint(): Point<Int, Int> = this.split(", ").let { (x, y) ->
    Point(
        x = x.replace("x=", "").toInt(),
        y = y.replace("y=", "").toInt(),
    )
}
