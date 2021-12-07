package code

import java.io.BufferedReader

fun raw(name: String): BufferedReader = {}::class.java.getResource(name)!!.openStream().bufferedReader()
//fun raw(name: String): BufferedReader = object {}.javaClass.getResource(name)!!.openStream().bufferedReader()
fun input(name: String): List<String> = raw(name).readLines()

fun <T> input(name: String, converter: (String) -> T): List<T> =
    input(name).mapNotNull {
        runCatching {
            converter(it)
        }.getOrNull()
    }
