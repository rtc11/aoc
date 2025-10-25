import java.util.*

fun main() {
    solve(input("dec_05_test.txt"), ::part1).also { println(it) }.also { require(it == "CMZ") }
    solve(input("dec_05.txt"), ::part1).also { println(it) }
    solve(input("dec_05_test.txt"), ::part2).also { println(it) }.also { require(it == "MCD") }
    solve(input("dec_05.txt"), ::part2).also { println(it) }
}

private fun solve(
    input: List<String>,
    moveCrates: (MutableMap<Int, Stack<Crate>>, List<Instruction>) -> Map<Int, Stack<Crate>>,
): String {
    val inputStacks = input.takeWhile { it != "" }

    val stackIds = inputStacks.takeLast(1)
        .joinToString()
        .windowed(4, 4, true)
        .map { it.replace(" ", "").toInt() }

    val stacks = inputStacks.dropLast(1).flatMap { Crate.parse(stackIds, it) }
        .filter { it.name != "" }
        .groupBy { it.stackId }
        .toSortedMap()
        .map {
            val stack = Stack<Crate>()
            stack.addAll(it.value.reversed())
            it.key to stack
        }
        .toMap()

    val instructions = input.drop(inputStacks.size + 1).map(Instruction::parse)

    return moveCrates(stacks.toMutableMap(), instructions)
        .map { stack -> stack.value.pop() }
        .joinToString { it.name.removeSurrounding("[", "]") }
        .replace(", ", "")
}

data class Crate(val stackId: Int, val name: String) {
    companion object {
        fun parse(stackIds: List<Int>, line: String): List<Crate> = line
            .windowed(4, 4, true)
            .mapIndexed { index, crate ->
                val stackId = stackIds[index]
                val name = crate.removeSurrounding("[", "]").replace(" ", "")
                Crate(stackId, name)
            }
    }
}

data class Instruction(val size: Int, val from: Int, val to: Int) {
    companion object {
        fun parse(line: String): Instruction {
            val move = line.replace("move ", "").takeWhile { it != ' ' }.toInt()
            val from = line.removePrefix("move $move ").replace("from ", "").takeWhile { it != ' ' }.toInt()
            val to = line.removePrefix("move $move from $from ").replace("to ", "").takeWhile { it != ' ' }.toInt()
            return Instruction(move, from, to)
        }
    }
}

private fun part1(stacks: MutableMap<Int, Stack<Crate>>, instructions: List<Instruction>): Map<Int, Stack<Crate>> {
    instructions.forEach { instruction ->
        val source = stacks[instruction.from]!!
        val dest = stacks[instruction.to]!!
        for (i in 1..instruction.size) dest.push(source.pop())
        stacks[instruction.from] = source
        stacks[instruction.to] = dest
    }
    return stacks
}

private fun part2(stacks: MutableMap<Int, Stack<Crate>>, instructions: List<Instruction>): Map<Int, Stack<Crate>> {
    instructions.forEach { instruction ->
        val source = stacks[instruction.from]!!
        val dest = stacks[instruction.to]!!
        val cratesToMove = source.takeLast(instruction.size)
        for (i in 1..instruction.size) source.pop()
        dest.addAll(cratesToMove)
        stacks[instruction.from] = source
        stacks[instruction.to] = dest
    }
    return stacks
}
