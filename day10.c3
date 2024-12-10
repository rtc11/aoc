import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

def Map = List(<String>);
def Pos = isz[<2>];
def Queue = List(<Pos>);

macro uint Pos.hash(Pos s) => string::tformat("%s", s).hash();

fn long! part1()
{
	String input = (String) file::load_temp(FILE)!;
    input = input.trim();

    Map map;
    map.temp_init();

    Queue queue;
    Queue trail;

    String[] lines = input.tsplit("\n");
    foreach(x, line: lines) {
        if (!line.len) continue;
        map.push(line);
        foreach(y, ch: line) {
            if (ch == '0') trail.push({x, y});
        }
    }

    usz sum;
    foreach(t: trail) {
        queue.clear();
        queue.temp_init();
        queue.push(t);
        sum += trail_length(map, queue)!;
    }

	return sum;
}

Pos[4] directions = {
    { 1, 0},
    {-1, 0},
    { 0, 1},
    { 0,-1},
};

fn usz! trail_length(Map map, Queue queue)
{
    Pos pos;
    char cur;
    HashMap(<Pos, bool>) visited;
    visited.temp_init();
    
    while LOOP: (queue.len())
    {
        pos = queue.pop()!;
        cur = map[pos.x][pos.y];
        if (cur == '9') {
            if (!visited.has_key(pos)) visited[pos] = true;
            continue LOOP;
        }

        foreach(dir: directions) {
            Pos next = pos + dir;
            if (next.x < 0 || next.x >= map.len()) continue;
            if (next.y < 0 || next.y >= map[0].len) continue;
            if (map[next.x][next.y] - cur != 1) continue;
            queue.push(next);
        }
    }
    return visited.len();
}

fn long! part2()
{
	String input = (String)file::load_temp(FILE)!;
	input = input.trim();
	return 0;
}

