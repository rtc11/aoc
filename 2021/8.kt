fun main() {
    val signals = input("8.txt") { input -> input.split(" | ") }
        .map { (pattern, output) ->
            val patterns = pattern.split(" ").map(String::toSet)
            val outputs = output.split(" ").map(String::toSet)
            patterns to outputs
        }

    val part1: Int = signals.flatMap { (_, outputs) -> outputs }.count { it.size in listOf(2, 3, 4, 7) }

    val part2: Int = signals.sumOf { (patterns, outputs) ->
        // Initiate with known mappings
        val digitToPattern = mutableMapOf(
            1 to patterns.first { it.size == 2 },
            4 to patterns.first { it.size == 4 },
            7 to patterns.first { it.size == 3 },
            8 to patterns.first { it.size == 7 }
        )
        // 3 overlaps with 1 on 2 places
        // 2 overlaps with 4 on 2 places
        // 5 is the last value not already mapped with length 5
        // do the same for length 6
        with(digitToPattern) {
            put(3, patterns.filter { it.size == 5 }.first { it.intersect(getValue(1)).size == 2 })
            put(2, patterns.filter { it.size == 5 }.first { it.intersect(getValue(4)).size == 2 })
            put(5, patterns.filter { it.size == 5 }.first { it !in values })
            put(6, patterns.filter { it.size == 6 }.first { it.intersect(getValue(1)).size == 1 })
            put(9, patterns.filter { it.size == 6 }.first { it.intersect(getValue(4)).size == 4 })
            put(0, patterns.filter { it.size == 6 }.first { it !in values })
        }
        // flip the association for lookup purpose
        val patternToDigit = digitToPattern.entries.associateBy({ it.value }) { it.key }
        outputs.joinToString("") { pattern -> patternToDigit.getValue(pattern).toString() }.toInt()
    }

    println("Part 1: $part1") // 344
    println("Part 2: $part2") // 1048410
}
