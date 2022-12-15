fun main() {
    solve(input("dec_07_test.txt"), ::part1).also { println(it) }.also { require(it == 2) }
//    solve(input("dec_07.txt"), ::part1).also { println(it) }
//    solve(input("dec_07_test.txt"), ::part2).also { println(it) }.also { require(it == 4) }
//    solve(input("dec_07.txt"), ::part2).also { println(it) }
}

private fun solve(input: List<String>, solvePart: (List<String>) -> Int): Int = solvePart(input)

private fun part1(input: List<String>): Int {

    val map = mutableMapOf<String, Directory>()
    var currentDir = Directory("/")

    input.forEach { line ->
        if (line.contains("$ cd ")) {
            val operation = line.removePrefix("$ cd ")

            if (operation == "..") {
                currentDir = currentDir.parentDirectory ?: map["/"] ?: error("no parent directory")
            } else {
                currentDir = map[operation] ?: Directory(operation)
            }
        }

        if (line.contains("$ ls ")) {

        }
    }
}

data class Directory(
    val name: String,
    val files: List<File> = emptyList(),
    val directories: List<Directory> = emptyList(),
    var parentDirectory: Directory? = null,
) {
    fun addFile(file: File) = copy(files = files + file)
    fun addDir(dir: Directory) = copy(directories = directories + dir)
}

data class File(
    val name: String,
    val size: Long,
)