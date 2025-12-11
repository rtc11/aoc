import std::io;
import std::time::clock;
import std::collections::list;
import std::collections::set;
import std::collections::map;
import std::sort;
import std::math;

alias Graph = HashMap{String, Node*};
alias Path = List{Node*};

struct Node {
    String name;
    List{Node*} neighbours;
}

fn bool Node.eq(self, Node other) @operator(==) => self.name == other.name;
macro uint Node.hash(self) => self.name.hash();

long p1;
long p2;

fn void main() => @pool() {
    Clock c = clock::now();
    defer io::printfn("part1 %d %s", p1, c.mark());
    defer io::printfn("part2 %d %s", p2, c.mark());

    solve(1, "input.txt", "you")!!;
    solve(2, "input.txt", "svr")!!;
}


fn void? solve(int part, String file_name, String start_name) 
{
    String input = (String) file::load(tmem, file_name)!!;
    String[] rows = input.tsplit("\n", skip_empty:true);

    Graph map;
    Node* start;
    Node* end;
    foreach(row : rows) {
        String[] parts = row.tsplit(" ");
        String name = parts[0][:^1];
        Node* n = map.@get_or_set(name, allocator::new(tmem, Node, { .name = name })); 
        if (n.name == start_name) start = n;
        foreach(dest : parts[1..]) {
            Node* neigh = map.@get_or_set(dest, allocator::new(tmem, Node, { .name = dest })); 
            if (neigh.name == "out") end = neigh;
            n.neighbours.push(neigh);
        }
    }
    List{Path} paths;
    List{Node*} current_path;
    current_path.push(start);
    HashSet{String} visit;
    dfs(start, end, current_path, paths, part, visit);
}

fn void dfs(Node* current, Node* end, List{Node*} current_path, List{Path} all_paths, int part, HashSet{String} visit)
{
    if (visit.contains(current.name)) return;
    visit.add(current.name);

    if (*current == *end) {
        if (part == 1) p1++;

        if (part == 2) {
            bool fft = false;
            bool dac = false;
            foreach(n: current_path) {
                if (n.name == "fft") fft = true;
                if (n.name == "dac") dac = true;
            }
            if (fft && dac) p2++;
        }

        Path complete_path;
        foreach(ptr: current_path) complete_path.push(ptr);
        all_paths.push(complete_path);
    }

    foreach(neighbour : current.neighbours) {
        current_path.push(neighbour);
        dfs(neighbour, end, current_path, all_paths, part, visit); 
        current_path.remove_last()!!;
    }
    visit.remove(current.name);
}

