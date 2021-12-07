fun main() {
    val test = input("6.test.txt") { it.split(",").map(String::toInt) }.single()
    val input = input("6.txt") { it.split(",").map(String::toInt) }.single()
    require(test.countFish(18) == 26L)
    require(test.countFish(80) == 5934L)
    require(test.countFish(256) == 26984457539L)
    println(input.countFish(256))
}

fun List<Int>.countFish(days: Int): Long {
    val fish = Fish.init(this)
    for (day in 1..days) fish.nextDay()
    return fish.timer.map { it.value }.sum()
}

data class Fish(val timer: MutableMap<Int, Long>) {
    companion object {
        fun init(init: List<Int>) : Fish {
            val map = mutableMapOf<Int, Long>()
            for (i in 0..8) map[i] = 0
            init.map { map[it] = map[it]!! + 1 }
            return Fish(map)
        }
    }

    fun nextDay() {
        val reset = timer[0]!!
        for (i in 0 until 8) timer[i] = timer[i + 1]!!
        timer[6] = timer[6]!! + reset
        timer[8] = reset
    }
}
