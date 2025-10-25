package code

val requiredFields = mapOf(
    "byr" to "Birth Year",
    "iyr" to "Issue Year",
    "eyr" to "Expiration Year",
    "hgt" to "Height",
    "hcl" to "Hair Color",
    "ecl" to "Eye Color",
    "pid" to "Passport ID",
)

fun validateField(key: String, value: String): Boolean =
    runCatching {
        when (key) {
            "byr" -> value.length == 4 && value.toInt() in 1920..2002
            "iyr" -> value.length == 4 && value.toInt() in 2010..2020
            "eyr" -> value.length == 4 && value.toInt() in 2020..2030
            "hgt" -> verifyHeight(value)
            "hcl" -> value[0] == '#' && "[0-9a-f]+".toRegex().matches(value.substring(1, 7))
            "ecl" -> listOf("amb", "blu", "brn", "gry", "grn", "hzl", "oth").contains(value)
            "pid" -> value.length == 9 && "[0-9]+".toRegex().matches(value)
            "cid" -> true // ignored
            else -> false // unknown
        }
    }.getOrDefault(false)

private fun verifyHeight(value: String): Boolean =
    if (value.contains("cm")) value.substringBefore("cm").toInt() in 150..193
    else if (value.contains("in")) value.substringBefore("in").toInt() in 59..76
    else false

fun main() {
    calculateValidPassports(input("test-4-invalid.txt")).let { (valid, total) ->
        require(valid == 0 && total == 4) { "Required 0/4 valid passports: $valid/$total" }
        println("$valid/$total valid test passports")
    }

    calculateValidPassports(input("test-4-valid.txt")).let { (valid, total) ->
        require(valid == 4 && total == 4) { "Required 4/4 valid passports: $valid/$total" }
        println("$valid/$total valid test passports")
    }

    calculateValidPassports(input("4.txt")).let { (valid, total) ->
        println("$valid/$total valid passports")
    }
}

fun List<String>.toPassportFields(): Map<String, String> = map { row ->
    row.split(" ")
        .associate { pair ->
            pair.split(":").let { it[0] to it[1] }
        }
}.fold(mutableMapOf()) { acc, map -> acc.apply { putAll(map) } } // accumulate list from several rows

private fun calculateValidPassports(input: List<String>): Pair<Int, Int> {
    val rawPassport = mutableListOf<String>()
    val rawPassports = mutableListOf<List<String>>()

    input.forEach { row ->
        // Passports are separated by blank lines
        when (row.isBlank()) {
            false -> rawPassport.add(row)
            else -> rawPassports.add(rawPassport.toMutableList()).also { rawPassport.clear() }
        }
    }

    val passports = rawPassports.map { it.toPassportFields() }

    val answer = passports.count { fields ->
        requiredFields.all { (key, _) ->
            // For part one skip validateField
            fields.containsKey(key) && validateField(key, fields[key] ?: "unknown")
        }
    }

    return answer to passports.size
}
