fun main() {
    partOne("2.test.txt")
    partOne("2.txt")

    partTwo("2.test.txt")
    partTwo("2.txt")
}

private fun partTwo(path: String) {
    fun calculatePosition(input: List<Pair<String, Int>>) {
        var horizontal = 0
        var depth = 0
        var aim = 0

        input.forEach { (direction, unit) ->
            when (direction) {
                "down" -> aim += unit
                "up" -> aim -= unit
                "forward" -> {
                    horizontal += unit
                    depth += aim * unit
                }
            }
        }

        println(horizontal * depth)
    }

    val input = input(path) { row ->
        row.split(" ").let {
            it.first() to it.last().toInt()
        }
    }

    calculatePosition(input)
}

private fun partOne(path: String) {
    fun calculatePosition(input: List<Pair<String, Int>>) {
        var horizontal = 0
        var depth = 0

        input.forEach { (direction, unit) ->
            when (direction) {
                "down" -> depth += unit
                "up" -> depth -= unit
                "forward" -> horizontal += unit
            }
        }

        println(horizontal * depth)
    }

    val input = input(path) { row ->
        row.split(" ").let {
            it.first() to it.last().toInt()
        }
    }

    calculatePosition(input)
}

