import java.io.BufferedReader
import kotlin.math.pow

fun raw(name: String): BufferedReader = {}::class.java.getResource(name)!!.openStream().bufferedReader()
fun input(name: String): List<String> = raw(name).readLines()
fun <T> input(name: String, converter: (String) -> T): List<T> = input(name).mapNotNull { runCatching { converter(it) }.getOrNull() }

fun binaryToDecimal(binaryString: String): Int = binaryString.reversed()
    .foldIndexed(0.toDouble()) { i, acc, bit -> acc + bit.toString().toDouble() * 2.toDouble().pow(i.toDouble()) }
    .toInt()

fun <A, B> Map<A, B>.flip(): Map<B, A> = entries.associateBy({ it.value }) { it.key }

inline fun <T, R : Comparable<R>> Iterable<T>.minBy(selector: (T) -> R): T = minByOrNull(selector)!!
inline fun <T, R : Comparable<R>> Iterable<T>.maxBy(selector: (T) -> R): T = maxByOrNull(selector)!!
inline fun <K, V, R : Comparable<R>> Map<out K, V>.minBy(selector: (Map.Entry<K, V>) -> R): Map.Entry<K, V> = entries.minByOrNull(selector)!!
inline fun <K, V, R : Comparable<R>> Map<out K, V>.maxBy(selector: (Map.Entry<K, V>) -> R): Map.Entry<K, V> = entries.maxByOrNull(selector)!!

fun <T> List<T>.join(): String = joinToString("")

infix fun <T> List<T>.slice(startIndex: Int): List<T> = slice(startIndex until size - 1)
