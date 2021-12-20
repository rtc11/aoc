import java.io.BufferedReader
import kotlin.math.pow

fun raw(name: String): BufferedReader = {}::class.java.getResource(name)!!.openStream().bufferedReader()
fun input(name: String): List<String> = raw(name).readLines()

fun <T> input(name: String, converter: (String) -> T): List<T> =
    input(name).mapNotNull { runCatching { converter(it) }.getOrNull() }

fun binaryToDecimal(binaryString: String): Int = binaryString.reversed()
    .foldIndexed(0.toDouble()) { i, acc, bit -> acc + bit.toString().toDouble() * 2.toDouble().pow(i.toDouble()) }
    .toInt()

fun <A, B> Map<A, B>.flip(): Map<B, A> = entries.associateBy({ it.value }) { it.key }

inline fun <T, R : Comparable<R>> Iterable<T>.minBy(selector: (T) -> R): T = minByOrNull(selector)!!
inline fun <T, R : Comparable<R>> Iterable<T>.maxBy(selector: (T) -> R): T = maxByOrNull(selector)!!
