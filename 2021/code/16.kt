fun main() {
    testPartOne()
//    testPartTwo()

    val partOne = getVersionSum(input("16.txt").first().decode())
    println("Sum of versions: $partOne")

    val partTwo = input("16_2.txt").first().decode()
    printTree(partTwo)
//     1267468786 too low
}

private fun printTree(step: Step, level: Int = 0) {
    print("  ".repeat(level))
    print("${step.packet} ")
    println(step.operator)
    step.steps.forEach {
        printTree(it, level + 1)
    }
}

private fun testPartOne() {
    require(getVersionSum("38006F45291200".decode()) == 9)
    require(getVersionSum("EE00D40C823060".decode()) == 14)
    require(getVersionSum("8A004A801A8002F478".decode()) == 16)
    require(getVersionSum("620080001611562C8802118E34".decode()) == 12)
    require(getVersionSum("C0015000016115A2E0802F182340".decode()) == 23)
    require(getVersionSum("A0016C880162017C3686B18A3D4780".decode()) == 31)
}

private fun testPartTwo() {
    printTree("C200B40A82".decode())
    require("C200B40A82".decode().packet == 3)
    println("")

    printTree("04005AC33890".decode())
    require("04005AC33890".decode().packet == 54)
    println("")

    printTree("880086C3E88112".decode())
    require("880086C3E88112".decode().packet == 7)
    println("")

    printTree("CE00C43D881120".decode())
    require("CE00C43D881120".decode().packet == 9)
    println("")

    printTree("D8005AC2A8F0".decode())
    require("D8005AC2A8F0".decode().packet == 1)
    println("")

    printTree("F600BC2D8F".decode())
    require("F600BC2D8F".decode().packet == 0)
    println("")

    printTree("9C005AC2F8F0".decode())
    require("9C005AC2F8F0".decode().packet == 0)
    println("")

    printTree("9C0141080250320F1802104A08".decode())
    require("9C0141080250320F1802104A08".decode().packet == 1)
    println("")
}

private fun String.decode(): Step = executeStep(mapNotNull { hexToBinary[it] }.join().toList())
private fun getVersionSum(step: Step): Int = step.version + step.steps.sumOf { getVersionSum(it) }
private fun executeStep(binary: List<Char>): Step = if (binary.typeId() == 4) literal(binary) else operator(binary)

fun operator(binary: List<Char>): Step {
    val bitLength = binary.numOfBitsByMode()
    val lengthType = binaryToDecimal(binary.slice(7 until 7 + bitLength).join())
    val subSteps = mutableListOf<Step>()

    fun packetsBySize(packet: List<Char>) {
        var subBinary = packet
        for (i in 0 until lengthType) {
            val subStep = executeStep(subBinary)
            subSteps.add(subStep)
            subBinary = subStep.remaining
        }
    }

    fun packetsByLength(packet: List<Char>) {
        var subBinary = packet
        do {
            val subStep = executeStep(subBinary)
            subSteps.add(subStep)
            subBinary = subStep.remaining
        } while (subStep.remaining.hasRemainder())
    }

    when (bitLength == 11) {
        true -> packetsBySize(binary.slice(7 + 11))
        false -> packetsByLength(binary.slice(7 + 15 until 7 + 15 + lengthType))
    }

    val remaining = when (bitLength) {
        15 -> binary.slice(7 + 15 + lengthType)
        11 -> subSteps.minBy { it.remaining.size }.remaining
        else -> error("Illegal bit length")
    }

    val value = when (binary.typeId()) {
        0 -> subSteps.sum()
        1 -> subSteps.product()
        2 -> subSteps.min()
        3 -> subSteps.max()
        5 -> subSteps.greater()
        6 -> subSteps.less()
        7 -> subSteps.equal()
        else -> error("Unsupported operation, e.g 4 = literal")
    }

    return Step(
        packet = value,
        operator = intToOperator[binary.typeId()]!!,
        version = binary.version(),
        typeId = binary.typeId(),
        steps = subSteps,
        remaining = remaining,
    )
}

fun List<Step>.sum(): Int = sumOf { it.packet }
fun List<Step>.product(): Int = map { it.packet }.reduce { acc, i -> acc * i }
fun List<Step>.min(): Int = minBy { it.packet }.packet
fun List<Step>.max(): Int = maxBy { it.packet }.packet
fun List<Step>.greater(): Int = if (this[0].packet > this[1].packet) 1 else 0
fun List<Step>.less(): Int = if (this[0].packet < this[1].packet) 1 else 0
fun List<Step>.equal(): Int = if (this[0].packet == this[1].packet) 1 else 0

fun literal(binary: List<Char>): Step {
    fun group(startIndex: Int, lambda: (List<Char>) -> Boolean): List<String> = binary
        .slice(startIndex)
        .windowed(5, 5)
        .takeWhile(lambda)
        .map { it.join() }

    fun List<String>.removePrefix() = map { it.substring(1) }

    var remaining: List<Char> = listOf()

    fun multiGroup(): String {
        val firstBits = group(6) { it[0] == '1' }
        val lastBits = binary.slice(6 + firstBits.sumOf { it.length } until 6 + firstBits.sumOf { it.length } + 5)
        remaining = binary.slice(6 + firstBits.sumOf { it.length } + 5)
        return "${firstBits.removePrefix().join()}${lastBits.slice(1).join()}"
    }

    fun singleGroup(): String {
        val literalBits = group(6) { it[0] == '0' }.first()
        remaining = binary.slice(6 + literalBits.length)
        return literalBits.substring(1)
    }

    val packet = when (binary[6]) {
        '1' -> multiGroup()
        '0' -> singleGroup()
        else -> error("Not a binary value")
    }

    return Step(
        packet = binaryToDecimal(packet),
        version = binary.version(),
        typeId = binary.typeId(),
        remaining = remaining
    )
}

data class Step(
    val packet: Int,
    val operator: String = "",
    val typeId: Int,
    val version: Int,
    val remaining: List<Char>,
    val steps: List<Step> = listOf(),
)

fun <T> List<T>.join(): String = joinToString("")
fun List<Char>.hasRemainder() = isNotEmpty() && any { it != '0' }
fun List<Char>.numOfBitsByMode(): Int = if (this[6] == '0') 15 else 11
fun List<Char>.slice(startIndex: Int): List<Char> = slice(startIndex until size)
fun List<Char>.typeId() = binaryToDecimal(slice(3 until 6).join())
fun List<Char>.version() = binaryToDecimal(slice(0 until 3).join())

private val hexToBinary = mapOf(
    '0' to "0000",
    '1' to "0001",
    '2' to "0010",
    '3' to "0011",
    '4' to "0100",
    '5' to "0101",
    '6' to "0110",
    '7' to "0111",
    '8' to "1000",
    '9' to "1001",
    'A' to "1010",
    'B' to "1011",
    'C' to "1100",
    'D' to "1101",
    'E' to "1110",
    'F' to "1111",
)

private val intToOperator = mapOf(
    0 to "+",
    1 to "*",
    2 to "min",
    3 to "max",
    5 to ">",
    6 to "<",
    7 to "=",
)
