import std::io;
import std::time;
import std::collections;
import std::sort;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        visited.temp_init();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

const String FILE = "test.txt";

struct Player {
    Pos pos;
    Dir dir;
}
def Pos = isz[<2>];
macro uint Pos.hash(Pos s) => string::tformat("%s", s).hash();

enum Dir : (Pos pos) {
    N = { 0,-1 },
    E = { 1, 0 },
    S = { 0, 1 },
    W = {-1, 0 },
}

HashMap(<Pos, Dir>) visited;
Player player;

fn long! part1()
{
    String input = (String) file::load_temp("input.txt")!;
    String[] map = input.trim().tsplit("\n");
    solve(map)!;
    return visited.len();
}

fn long! part2()
{
    String input = (String) file::load_temp("input.txt")!;
    String[] map = input.trim().tsplit("\n");
    usz loops;
    char tmp;
    for (int y; y< map.len; y++) {
        for (int x; x < map[0].len; x++) {
           tmp = map[y][x];
           map[y][x] = '#';
           loops += solve(map)!;
           map[y][x] = tmp;
        }
    }
    return loops;
}

fn long! solve(String[] map)
{
    player = { {0,0}, Dir.N };
    int loops;

    foreach (y, line: map) {
        for (int x; x<line.len; x++) {
            if (line[x] == '^') player.pos = { x, y };
        }
    }

    for(int i; i< map.len * map[0].len; i++) {
        if (i == map.len * map[0].len -1) loops++;
        Pos next = player.pos + player.dir.pos;
        visited[player.pos] = player.dir;
        if (next.x < 0 || next.x >= map.len || next.y < 0 || next.y >= map.len) break;

        if (map[next.y][next.x] == '#') {
            switch (player.dir) {
                case Dir.N: player.dir = Dir.E;
                case Dir.E: player.dir = Dir.S;
                case Dir.S: player.dir = Dir.W;
                case Dir.W: player.dir = Dir.N;
            }
        } else {
            player.pos = next;
        }
    }

    return loops;
}

fn void print(String[] map)
{
    foreach (y, line: map) {
        for (int x; x<line.len; x++) {
            if (visited.has_key({x,y})) {
                io::printf("%c", 'X');
            } else {
                io::printf("%c", map[y][x]);
            }
        }
        io::printn();
    }
    io::printn();
}

