fun main() {

    part1(input("dec_16_test.txt"))
//    part1(input("dec_16.txt"))
}

private fun part1(input: List<String>) {

    // create valves
    input.forEach { line ->
        val rate = line.dropWhile { it != '=' }.dropLastWhile { it != ';' }.removeSurrounding("=", ";").toInt()
        val name = line.slice(6..7)
        cave[name] = Valve(name, rate)
    }

    // associate with neighbours and parents
    input.forEach { line ->
        val name = line.slice(6..7)

        val entries = line
            .takeLastWhile { if (line.contains("leads")) it != 'e' else it != 's' }
            .drop(1)
            .split(", ")
            .mapNotNull { neighbour -> cave[neighbour] }
            .toMutableList()

        entries.forEach { valve -> valve.parents += cave[name]!! }
        cave[name]!!.valves.addAll(entries)
    }

    // find starting point
    val startingPoint = cave[input.first().slice(6..7)] ?: error("no valve found")

    // start inspection
    inspectValve(startingPoint)

    println(totalPressure)
}

val cave: MutableMap<String, Valve> = mutableMapOf()
val openValves = mutableListOf<String>()
var minute = 0
var totalPressure = 0
var pressure = 0

fun inspectValve(valve: Valve, extraTime: Int = 0) {
    if (minute == 30) return
    minute = minute + 1 + extraTime
    println()
    println("== Minute $minute ==")
    if (openValves.isEmpty()) println("No valves are open.")
    else println("Valve ${openValves.joinToString(" and ")} is open, releasing $pressure pressure.")

    if (valve.rate != 0) {
        if (!valve.open) {
            println("You open valve ${valve.name}.")
            valve.open = true
            openValves.add(valve.name)
            pressure += valve.rate
            totalPressure += ((30 - minute) * valve.rate) // add preassure
            inspectValve(valve)
        }
    }

    decideNext(valve)?.let { (next, cost) ->
        println("You move to valve ${next.name}.")
        inspectValve(next, cost)
    }
}

private fun decideNext(source: Valve): Pair<Valve, Int>? {
    val possibleDestinations = cave.toList().map { it.second }

    var extraCost = 0

    val next = possibleDestinations
        .filter { it != source }
        .sortedByDescending { destination ->
            extraCost = priceInTime(source, destination, 1, emptyList())
            destination.rate * (30 - minute - extraCost)
        }.firstOrNull { !it.open }

    return next?.let { it to extraCost }
}

private fun priceInTime(src: Valve, dst: Valve, cost: Int, visited: List<Pair<Valve, Valve>>): Int =
    if (src.name == dst.name) cost
    else if (src to dst in visited) cost
    else dst.parents.minOf { priceInTime(src, it, cost + 1, visited + (src to dst)) }

data class Valve(
    val name: String,
    val rate: Int,
    val valves: MutableList<Valve> = mutableListOf(),
    val parents: MutableList<Valve> = mutableListOf(),
    var open: Boolean = false,
    var visited: Boolean = false,
)