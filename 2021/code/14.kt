import java.math.BigInteger

fun main() {

    val (polymer, lookup) = input("14t").let { input ->
        val polymer = input.first()
        val pairs = input.takeLastWhile { it != "" }
            .map { it.split(" -> ") }
            .associate { it[0] to it[1].single() }
        polymer to pairs
    }

    partOne(lookup, polymer)
    partTwo(lookup, polymer)
}

private fun partTwo(lookup: Map<String, Char>, polymer: String) {
    fun grow2(polymer: Map<String, BigInteger>): Map<String, BigInteger> {
        val newPolymer = polymer.toMutableMap()
        polymer.filter { t -> lookup[t.key] != null }.forEach { map ->
            val (a, b) = lookup[map.key]!!.let {
                val a = "${map.key[0]}$it"
                val b = "$it${map.key[1]}"
                a to b
            }
            newPolymer[map.key] = newPolymer[map.key]!! - 1.toBigInteger()
            if (newPolymer[map.key]!! == 0.toBigInteger()) newPolymer.remove(map.key)
            val na = newPolymer.getOrPut(a) { 0.toBigInteger() }
            val nb = newPolymer.getOrPut(b) { 0.toBigInteger() }
            newPolymer[a] = maxOf(na + 1, na * 2)
            newPolymer[b] = maxOf(nb + 1, nb * 2)
        }
        return newPolymer
    }

    fun recursive2(polymer: Map<String, BigInteger>, times: Int): Map<String, BigInteger> {
        if (times == 0) return polymer
        val next = grow2(polymer)
        return recursive2(next, times - 1)
    }


    val polymer2 = polymer.windowed(2).associateWith { 1.toBigInteger() }
    val res2 = recursive2(polymer2, 10)
    println(res2)

    val groups2Left = res2.entries.groupingBy { it.key[0] }.fold(0.toBigInteger()) { acc, _ -> acc + 1 }
    val groups2Right = res2.entries.groupingBy { it.key[1] }.fold(0.toBigInteger()) { acc, _ -> acc + 1 }
    val max1 = maxOf(groups2Left.maxOf { it.value }, groups2Right.maxOf { it.value })
    val min1 = minOf(groups2Left.minOf { it.value }, groups2Right.minOf { it.value })
    println("part2: ${max1 - min1}")
}

private fun partOne(lookup: Map<String, Char>, polymer: String) {
    fun grow(polymer: String): String = polymer.windowed(2)
        .filter { lookup[it] != null }
        .map { it.toMutableList().apply { add(1, lookup[it]!!) } }
        .reduce { acc, list ->
            acc.apply {
                if (acc.last() == list.first()) addAll(list.slice(1))
                else addAll(list)
            }
        }.join()
        .also(::println)

    fun recursive(polymer: String, times: Int): String {
        if (times == 0) return polymer
        val next = grow(polymer)
        return recursive(next, times - 1)
    }

    val resultPolymer = recursive(polymer, 10)
    val groups = resultPolymer.groupingBy { it }.fold(0.toBigInteger()) { acc, _ -> acc + 1 }
    val part1 = groups.maxOf { it.value } - groups.minOf { it.value }
    println("part1: $part1")
}
