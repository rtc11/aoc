fun main() {
    solve(input("dec_02_test.txt"), ::part1).also { require(it == 15) }
    solve(input("dec_02.txt"), ::part1).also(::println).also { require(it == 14264) }
    solve(input("dec_02_test.txt"), ::part2).also { require(it == 12) }
    solve(input("dec_02.txt"), ::part2).also(::println).also { require(it == 12382) }
}

private fun solve(input: List<String>, solvePart: (opponent: Action, you: Action) -> Int): Int = input.sumOf { game ->
    val (opponent, you) = game.split(" ").map {
        when (it) {
            "A", "X" -> Action.Rock
            "B", "Y" -> Action.Paper
            else -> Action.Scissor
        }
    }
    solvePart(opponent, you)
}

private fun part1(opponent: Action, you: Action): Int = you.battle(opponent)

private fun part2(opponent: Action, you: Action): Int =
    when (you) {
        Action.Rock -> opponent.dominative.battle(opponent)
        Action.Paper -> opponent.battle(opponent)
        Action.Scissor -> opponent.submassive.battle(opponent)
    }

sealed class Action(private val actionPoints: Int) {
    abstract val dominative: Action
    abstract val submassive: Action

    fun battle(opponent: Action): Int = actionPoints + when (opponent) {
        submassive -> 0
        dominative -> 6
        else -> 3
    }

    object Rock : Action(1) {
        override val dominative: Action = Scissor
        override val submassive: Action = Paper
    }

    object Paper : Action(2) {
        override val dominative: Action = Rock
        override val submassive: Action = Scissor
    }

    object Scissor : Action(3) {
        override val dominative: Action = Paper
        override val submassive: Action = Rock
    }
}
