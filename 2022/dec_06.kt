fun main() {
    solve(listOf("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), 4).also { require(it.first == 7) }
    solve(listOf("bvwbjplbgvbhsrlpgdmjqwftvncz"), 4).also { require(it.first == 5) }
    solve(listOf("nppdvjthqldpwncqszvftbrmjlhg"), 4).also { require(it.first == 6) }
    solve(listOf("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 4).also { require(it.first == 10) }
    solve(listOf("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 4).also { require(it.first == 11) }
    solve(input("dec_06.txt"), 4).also { println(it) }

    solve(listOf("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), 14).also { require(it.first == 19) }
    solve(listOf("bvwbjplbgvbhsrlpgdmjqwftvncz"), 14).also { require(it.first == 23) }
    solve(listOf("nppdvjthqldpwncqszvftbrmjlhg"), 14).also { require(it.first == 23) }
    solve(listOf("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), 14).also { require(it.first == 29) }
    solve(listOf("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), 14).also { require(it.first == 26) }
    solve(input("dec_06.txt"), 14).also { println(it) }
}

private fun solve(
    input: List<String>,
    windowSize: Int,
): Pair<Int, String> {
    var counter = 0
    val startMarker = input.single()
        .windowed(windowSize, 1)
        .first { potentialStartMarker ->
            when (potentialStartMarker.groupBy { it }.size) {
                windowSize -> true.also { counter += windowSize } // skip start marker
                else -> false.also { counter++ } // not yet started
            }
        }

    return counter to startMarker
}
