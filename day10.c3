import std::io;
import std::time;
import std::collections;
import std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", solve(&part1)!!, c.mark());
        io::printfn("- Part2: %d - %s", solve(&part2)!!, c.mark());
    };
}

const String FILE = "input.txt";
def Map = List(<String>);
def Pos = isz[<2>];
def Queue = List(<Pos>);
def Trail = HashMap(<Pos, int>);
def Part = fn long!(Map, Queue);
Pos[4] directions = { {1,0}, {-1,0}, {0,1}, {0,-1} };
macro uint Pos.hash(Pos s) => string::tformat("%s", s).hash();

fn long! part1(Map map, Queue trail)
{
    Trail walked = walk(map, trail)!;
    return walked.len();
}

fn long! part2(Map map, Queue trail)
{
    Trail walked = walk(map, trail)!;
    usz sum;
    walked.@each(; Pos pos, int visit_count) {
        sum += visit_count;
    };
    return sum;
}

fn long! solve(Part part)
{
	String input = (String) file::load_temp(FILE)!;
    usz sum;
    Queue queue;
    Queue trail;
    Map map;
    map.temp_init();

    foreach(x, line: input.tsplit("\n")) {
        if (!line.len) continue;
        map.push(line);
        foreach(y, ch: line) {
            if (ch == '0') queue.push({x, y});
        }
    }

    foreach(t: queue) {
        trail.clear();
        trail.temp_init();
        trail.push(t);
        sum += part(map, trail)!;
    }

	return sum;
}

fn Trail! walk(Map map, Queue trail)
{
    Pos pos;
    char cur;
    Trail visited;
    visited.temp_init();
    
    while WALKING: (trail.len()) {
        pos = trail.pop()!;
        cur = map[pos.x][pos.y];
        if (cur == '9') {
            if (!visited.has_key(pos)) visited[pos] = 0;
            (*visited.get_ref(pos)!!)++;
            continue WALKING;
        }

        foreach(dir: directions) {
            Pos next = pos + dir;
            if (next.x < 0 || next.x >= map.len()) continue;
            if (next.y < 0 || next.y >= map[0].len) continue;
            if (map[next.x][next.y] - cur != 1) continue;
            trail.push(next);
        }
    }
    return visited;
}

