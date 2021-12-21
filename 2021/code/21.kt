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

data class Player(val name: String, var pos: Int, var score: Int) {
    fun move(roll: Int) {
        pos += roll
        while (pos > 10) pos -= 10
    }

    fun scoreInc() {
        score += pos
    }
}

data class Game(var p1: Player, var p2: Player) {
    private var turn: Player = p1
    var rollCount: Int = 0
    var totalRollCount: Int = 0

    fun winner(score: Long): Player? = if (p1.score >= score) p1 else if (p2.score >= score) p2 else null

    fun roll(roll: Int): Game {
        turn.move(roll)
        rollCount++
        totalRollCount++
        if (rollCount == 3) {
            turn.scoreInc()
            turn = if (turn == p1) p2 else p1
            rollCount = 0
        }
        return this
    }

    fun cp(): Game {
        val res = Game(p1.copy(), p2.copy())
        res.turn = if (turn == p1) res.p1 else res.p2
        res.rollCount = rollCount.toString().toInt()
        res.totalRollCount = totalRollCount.toString().toInt()
        return res
    }
}

fun HashMap<Game, Long>.addCount(game: Game, count: Long) {
    this[game] = if (containsKey(game)) this[game]!! + count else count
}

fun quantumRoll(game: Game): List<Game> {
    val games = listOf(game.cp(), game.cp(), game.cp())
    games.forEachIndexed { i, g -> g.roll(i + 1) }
    return games
}

fun playPartTwo(p1Start: Int, p2Start: Int): Long {
    var states: HashMap<Game, Long> = hashMapOf()
    val startGame = Game(Player("p1", p1Start, 0), Player("p2", p2Start, 0))
    states[startGame] = 1

    while (states.any { it.key.winner(21) == null }) {
        val newStates: HashMap<Game, Long> = hashMapOf()

        states.forEach { (game, count) ->
            when (game.winner(21)) {
                null -> quantumRoll(game).forEach { newGame -> newStates.addCount(newGame, count) }
                else -> newStates.addCount(game, count)
            }
        }
        states = newStates
    }

    return states
        .map { entry -> entry.key.winner(21)!!.name to entry.value }
        .groupBy { it.first }
        .mapValues { it.value.sumOf { list -> list.second } }
        .maxOf { it.value }
}
