fun main() {
    val (p1test, p2test) = 4 to 8
    val (p1, p2) = 6 to 7

    playPartOne(p1test - 1, p2test - 1).also(::println).also { require(it == 739785) }
    playPartOne(p1 - 1, p2 - 1).also(::println)
    playPartTwo(p1test, p2test).also(::println).also { require(it == 444356092776315L) }
    playPartTwo(p1, p2).also(::println)
}

private fun playPartOne(p1Pos: Int, p2Pos: Int, p1Score: Int = 0, p2Score: Int = 0, rolls: Int = 0, die: Int = 0): Int {
    fun roll(roll: Int): Int = (if (die + roll % 100 == 0) 100 else die + roll % 100)
    fun move(from: Int, times: Int): Int = (from + times) % 10

    val newP1Pos = move(p1Pos, roll(1) + roll(2) + roll(3))
    val newP1Score = p1Score + newP1Pos + 1 // score is 1 indexed
    if (newP1Score >= 1000) return p2Score * (rolls + 3)
    val newP2Pos = move(p2Pos, roll(4) + roll(5) + roll(6))
    val newP2Score = p2Score + newP2Pos + 1 // score is 1 indexed
    if (newP2Score >= 1000) return p1Score * (rolls + 6)

    return playPartOne(newP1Pos, newP2Pos, newP1Score, newP2Score, rolls + 6, roll(6))
}

data class Player(val name: String, var pos: Int, var score: Int = 0) {
    fun move(roll: Int) {
        pos += roll
        while (pos > 10) pos -= 10
    }

    fun increaseScore() {
        score += pos
    }
}

data class Game(var p1: Player, var p2: Player) {
    private var turn: Player = p1
    var rollCount: Int = 0

    fun winner(score: Long): Player? = if (p1.score >= score) p1 else if (p2.score >= score) p2 else null

    fun roll(roll: Int): Game {
        turn.move(roll)
        if (++rollCount == 3) { // switch turn?
            turn.increaseScore()
            turn = if (turn == p1) p2 else p1
            rollCount = 0
        }
        return this
    }

    // custom copy to save memory
    fun cp(): Game = Game(p1.copy(), p2.copy()).apply {
        turn = if (this@Game.turn == p1) p1 else p2
        rollCount = this@Game.rollCount
    }
}

fun quantumRoll(game: Game): List<Game> = listOf(game.cp(), game.cp(), game.cp()).mapIndexed { i, g ->
    g.roll(i + 1) // 1 2 3
}

fun playPartTwo(p1Start: Int, p2Start: Int): Long {
    var states: HashMap<Game, Long> = hashMapOf()
    val initialGame = Game(Player("p1", p1Start), Player("p2", p2Start))
    states[initialGame] = 1

    fun HashMap<Game, Long>.addCount(game: Game, count: Long) =
        when (containsKey(game)) {
            true -> this[game] = this[game]!! + count // increase similar game
            false -> this[game] = count // add current state
        }

    // while active games
    while (states.any { (game, _) -> game.winner(21) == null }) {
        val newStates: HashMap<Game, Long> = hashMapOf()

        states.forEach { (game, count) ->
            when (game.winner(21)) {
                null -> quantumRoll(game).forEach { newGame -> newStates.addCount(newGame, count) } // split universe
                else -> newStates.addCount(game, count) // keep state
            }
        }
        states = newStates
    }

    return states
        .map { (game, wins) -> game.winner(21)!!.name to wins }
        .groupingBy { (player, _) -> player }
        .fold(0L) { totalWins, (_, wins) -> totalWins + wins }
        .maxOf { (_, totalWins) -> totalWins }
}
