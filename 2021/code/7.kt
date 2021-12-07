import kotlin.math.abs

fun main() {
    val test = input("7.test.txt") { it.split(",").map(String::toInt) }.single()
    val input = input("7.txt") { it.split(",").map(String::toInt) }.single()

    calculateCheapestFuelConsumption(test)
    calculateCheapestFuelConsumption(input)
    calculateCheapestFuelConsumption2(test)
    calculateCheapestFuelConsumption2(input)
}

private fun calculateCheapestFuelConsumption(test: List<Int>) {
    val (min, max) = test.sorted().let { it.first() to it.last() }
    val fuel = mutableMapOf<Int, Int>()
    for (i in min..max) fuel[i] = test.sumOf { abs(it - i) }
    println(fuel.minOf { it.value })
}

private fun calculateCheapestFuelConsumption2(test: List<Int>) {
    val (min, max) = test.sorted().let { it.first() to it.last() }
    val fuel = mutableMapOf<Int, Int>()
    for (i in min..max) fuel[i] = test.sumOf { (1..abs(it - i)).sum() }
    println(fuel.minOf { it.value })
}