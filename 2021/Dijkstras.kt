data class Node(val name: String, val cost: Int)
data class Graph<T>(val nodes: Set<T>, val edges: Map<T, Set<T>>, val weights: Map<Pair<T, T>, Int>)

object Dijkstras {
    fun <T> shortestPaths(graph: Graph<T>, start: T): Map<T, T?> {
        val traversed: MutableSet<T> = mutableSetOf()
        val delta = graph.nodes.associateWith { Int.MAX_VALUE }.toMutableMap().apply { this[start] = 0 }
        val previous: MutableMap<T, T?> = graph.nodes.associateWith { null }.toMutableMap()

        while (traversed != graph.nodes) {
            val node: T = delta.filterNot { traversed.contains(it.key) }.minBy { it.value }.key

            graph.edges[node]?.minus(traversed)?.forEach { neighbor ->
                val newPath = delta.getValue(node) + graph.weights.getValue(Pair(node, neighbor))

                if (newPath < delta.getValue(neighbor)) {
                    delta[neighbor] = newPath
                    previous[neighbor] = node
                }
            }

            traversed.add(node)
        }

        return previous.toMap()
    }

    fun <T> shortestPath(shortestPathTree: Map<T, T?>, start: T, end: T): List<T> {
        fun pathTo(start: T, end: T): List<T> {
            if (shortestPathTree[end] == null) return listOf(end)
            return listOf(pathTo(start, shortestPathTree[end]!!), listOf(end)).flatten()
        }

        return pathTo(start, end)
    }
}
