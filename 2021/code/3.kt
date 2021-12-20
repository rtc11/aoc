import com.diogonunes.jcolor.Ansi.colorize
import com.diogonunes.jcolor.Attribute

typealias Bits = List<Int>
const val DEBUG = true
private fun asListOfInt(row: String) = row.toCharArray().map { char -> char.toString().toInt() }
private fun combineString(input: Bits): String = input.joinToString("") { it.toString() }

fun main() {
    val test = input("3.test.txt") { row -> asListOfInt(row) }
    val input = input("3.txt") { row -> asListOfInt(row) }

    println("Test")
    calculate(test).let { (gamma, epsilon, oxygen, co2) ->
        println("gamma: $gamma epsilon: $epsilon oxygen: $oxygen co2: $co2")
        require(gamma * epsilon == 198) { "Test 1 failed" }
        require(oxygen * co2 == 230) { "Test 2 failed" }
    }

    println("Solution")
    calculate(input).let { (gamma, epsilon, oxygen, co2) ->
        require(gamma * epsilon == 3277364) { "Solution 1 failed" }
        require(oxygen * co2 == 5736383) { "Solution 2 failed" }
    }
}

private fun calculate(input: List<Bits>): List<Int> =
    input.countPerPosition().let { bitCountPerPosition ->
        val gamma = gammaRate(bitCountPerPosition)
        val epsilon = epsilonRate(bitCountPerPosition)
        println("Power consumption: $gamma * $epsilon = ${gamma * epsilon}")

        val oxygen = oxygenRating(input, bitCountPerPosition)
        val co2 = co2Rating(input, bitCountPerPosition)
        println("Life support: $oxygen * $co2 = ${oxygen * co2}")

        listOf(gamma, epsilon, oxygen, co2)
    }

private fun gammaRate(bitCountPerPosition: List<Map<Int, Int>>): Int {
    val bits = bitCountPerPosition.map { bitToCount -> if (bitToCount[0]!! > bitToCount[1]!!) 0 else 1 }
    return binaryToDecimal(combineString(bits))
}

private fun epsilonRate(bitCountPerPosition: List<Map<Int, Int>>): Int {
    val bits = bitCountPerPosition.map { bitToCount -> if (bitToCount[0]!! > bitToCount[1]!!) 1 else 0 }
    return binaryToDecimal(combineString(bits))
}

private fun calculateRating(
    input: List<Bits>,
    bitCountPerPosition: List<Map<Int, Int>>,
    predicate: (Int, List<Map<Int, Int>>, bits: Bits) -> Boolean,
): Int {
    var filteredInput = input
    var filteredBitCount = bitCountPerPosition
    for (pos in 0 until input.first().size) {
        printPosition(filteredInput, pos)
        if (filteredInput.size == 1) break
        filteredInput = filteredInput.filter { predicate(pos, filteredBitCount, it) }
        filteredBitCount = filteredInput.countPerPosition()
    }
    return binaryToDecimal(combineString(filteredInput.single()))
}

private fun oxygenRating(input: List<Bits>, bitMap: List<Map<Int, Int>>): Int =
    calculateRating(input, bitMap) { pos, filteredBitMap, bits -> mostCommonBit(pos, filteredBitMap, bits) }

private fun co2Rating(input: List<Bits>, bitMap: List<Map<Int, Int>>): Int =
    calculateRating(input, bitMap) { pos, filteredBitMap, bits -> leastCommonBit(pos, filteredBitMap, bits) }

fun mostCommonBit(pos: Int, map: List<Map<Int, Int>>, bits: Bits): Boolean =
    when (map[pos][1]!! >= map[pos][0]!!) {
        true -> bits[pos] == 1
        false -> bits[pos] == 0
    }.also { if (DEBUG) if (it) print("$bits", 82) else print("$bits", 196) }

fun leastCommonBit(pos: Int, map: List<Map<Int, Int>>, bits: Bits): Boolean =
    when (map[pos][0]!! > map[pos][1]!!) {
        true -> bits[pos] == 1 // 1 is the least common bit
        false -> bits[pos] == 0 // 0 is the least common bit (or equally)
    }.also { if (DEBUG) if (it) print("$bits", 82) else print("$bits", 196) }

private fun List<Bits>.countPerPosition(): List<Map<Int, Int>> {
    val binaryLength = 0 until this.first().size
    return binaryLength.mapIndexed { pos, _ -> map { it[pos] }.groupBy { it }.mapValues { it.value.size } }
}

fun print(msg: String, color: Int) = print(colorize(msg, Attribute.TEXT_COLOR(color)))

fun printPosition(listOfBits: List<Bits>, index: Int) {
    if (DEBUG) {
        println("")
        val caret = 3 * index + 1
        listOfBits.forEach { bits ->
            val toString = bits.toString()
            print(toString.substring(0, caret), 240)
            print(toString.substring(caret, caret + 1), 33)
            print(toString.substring(caret + 1, toString.length), 240)
        }
        println("")
    }
}
