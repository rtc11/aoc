import java.math.BigInteger
import kotlin.math.max
import kotlin.math.min
import kotlin.system.measureTimeMillis

fun main() {
//    measureTimeMillis { partOne(cores("22t1.txt")).also { println(it) } }.also { println("Time: $it ms") }
//    measureTimeMillis { partOne(cores("22t2.txt")).also { println(it) } }.also { println("Time: $it ms") }
//    measureTimeMillis { partOne(cores("22.txt")).also { println(it) } }.also { println("Time: $it ms") }
    measureTimeMillis { partTwo(cores("22t3.txt")).also { println(it) } }.also { println("Time: $it ms") }
    measureTimeMillis { partTwo(cores("22.txt")).also { println(it) } }.also { println("Time: $it ms") }
}

private fun partOne(cores: List<Core>): Int = with(mutableSetOf<Cuboid>()) {
    cores.filterNot { core -> core.cuboid.z.first > 50 || core.cuboid.z.last < -50 || core.cuboid.y.first > 50 || core.cuboid.y.last < -50 || core.cuboid.x.first > 50 || core.cuboid.x.last < -50 }
        .forEach { core ->
            for (z in max(core.cuboid.z.first, -50)..min(core.cuboid.z.last, 50)) {
                for (y in max(core.cuboid.y.first, -50)..min(core.cuboid.y.last, 50)) {
                    for (x in max(core.cuboid.x.first, -50)..min(core.cuboid.x.last, 50)) {
                        if (core.state) add(Cuboid(x..x, y..y, z..z))
                        else remove(Cuboid(x..x, y..y, z..z))
                    }
                }
            }
        }
    return size
}

private fun partTwo(cores: List<Core>): ULong {
    var count = mutableMapOf<Cuboid, ULong>()
    cores.forEach { core ->
        val updatedCount = mutableMapOf<Cuboid, ULong>()
        for (a in count) {
            val intersected = core.cuboid.intersects(a.key)
            if (intersected != null)
                updatedCount[intersected] = updatedCount.getOrDefault(intersected, 0.toULong()) - a.value
        }
        if (core.state)
            updatedCount[core.cuboid] = updatedCount.getOrDefault(core.cuboid, 0.toULong()) + 1.toULong()

        count = updateCount(count, updatedCount)
    }
    return count.map { it.key.volume * it.value }.sumOf { it }
}

private fun updateCount(
    origin: Map<Cuboid, ULong>,
    update: Map<Cuboid, ULong>
): MutableMap<Cuboid, ULong> {
    return origin.toMutableMap().apply {
        for (entry in update) {
            val current = origin[entry.key]
            if (current == null) this[entry.key] = entry.value
            else this[entry.key] = current + entry.value
        }
    }
}

private fun cores(file: String): List<Core> {
    fun String.toRange() = split("..")
        .map(String::toInt)
        .zipWithNext()
        .map { (a, b) -> a..b }
        .single()

    return input(file) { line ->
        line.split(" ").let { (state, coord) ->
            val (x, y, z) = coord.split(",").map { it.drop(2).toRange() }
            Core(state == "on", Cuboid(x, y, z))
        }
    }
}

data class Core(val state: Boolean, val cuboid: Cuboid)
data class Cuboid(val x: IntRange, val y: IntRange, val z: IntRange) {
    val volume = ((x.last - x.first + 1) * (y.last - y.first + 1) * (z.last - z.first + 1)).toULong()

    fun intersects(other: Cuboid): Cuboid? {
        val (x0, x1) = max(x.first, other.x.first) to min(x.last, other.x.last)
        val (y0, y1) = max(y.first, other.y.first) to min(y.last, other.y.last)
        val (z0, z1) = max(z.first, other.z.first) to min(z.last, other.z.last)
        return if (x0 <= x1 && y0 <= y1 && z0 <= z1) Cuboid(x0..x1, y0..y1, y0..y1) else null
    }
}
