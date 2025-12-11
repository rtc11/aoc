import std::io, std::time::clock, std::collections::list;

const usz GRAPH_SIZE = 17576;
const ulong MAX_ULONG = 0xFFFFFFFFFFFFFFFF;

alias Neighbours = List{usz};
alias Graph = List{Neighbours};

fn void main() => @pool() {
    Clock c = clock::now();
    io::printfn("part1 %d %s", part1("input.txt"), c.mark());
    io::printfn("part2 %d %s", part2("input.txt"), c.mark());
}

fn usz part1(String file_name) {
    Graph* graph_ptr = allocator::new(tmem, Graph);
    *graph_ptr = parse(file_name);
    return paths(graph_ptr, "you", "out");
}

fn usz part2(String file_name) {
    Graph* graph_ptr = allocator::new(tmem, Graph);
    *graph_ptr = parse(file_name);
    ulong one = paths(graph_ptr, "svr", "fft") * paths(graph_ptr, "fft", "dac") * paths(graph_ptr, "dac", "out");
    ulong two = paths(graph_ptr, "svr", "dac") * paths(graph_ptr, "dac", "fft") * paths(graph_ptr, "fft", "out");
    return one + two;
}

fn Graph parse(String file_name) {
    String input = (String) file::load(tmem, file_name)!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    Graph graph;
    for(int i; i< GRAPH_SIZE; i++) graph.push({});
    foreach(row: rows) {
        String[] edges = row.tsplit(" ");
        usz from_idx = edges[0][:^1].to_index(); 
        for (usz i = 1; i < edges.len; i++) {
            graph[from_idx].push(edges[i].to_index()); 
        }
    }
    return graph;
}

fn ulong dfs(Graph* graph, ulong* cache, usz node, usz end) {
    if (node == end) return 1UL;
    if (cache[node] != MAX_ULONG) return cache[node];
    ulong result = 0UL;
    Neighbours neighbours = graph.get(node); 
    foreach (next_node: neighbours) result += dfs(graph, cache, next_node, end);
    cache[node] = result;
    return result;
}

fn ulong paths(Graph* graph, String from, String to) {
    ulong* cache = allocator::new(tmem, ulong[GRAPH_SIZE]); 
    for(usz i; i < GRAPH_SIZE; i++) cache[i] = MAX_ULONG;
    return dfs(graph, cache, from.to_index(), to.to_index());
}

fn usz String.to_index(self) {
    usz idx;
    foreach(i, b: self) idx = 26 * idx + (usz)(b - 'a');
    return idx;
}

