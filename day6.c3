import std::io;
import std::time;
import std::collections;
import std::sort;

const int SIZE = 130; // 130
const String FILE = "input.txt";

Entity[SIZE][SIZE] map;
bool[SIZE][SIZE] visited;

enum Entity
{
    LEFT,
    RIGHT,
    UP,
    DOWN,
    WALL,
    VOID,
    VISITED,
}

fn char Entity.view(self)
{
    switch (self) {
        case Entity.WALL: return '#';
        case Entity.UP: return '^';
        case Entity.RIGHT: return '>';
        case Entity.DOWN: return 'v';
        case Entity.LEFT: return '<' ;
        case Entity.VISITED: return 'X' ;
        case Entity.VOID: return '.' ;
        default: return '?';
    }
}

fault IllegalMove
{
    NOT_A_PLAYER,
}

fn Entity! Entity.turn_90(self)
{
    switch (self) {
        case Entity.UP: return Entity.RIGHT;
        case Entity.RIGHT: return Entity.DOWN;
        case Entity.DOWN: return Entity.LEFT;
        case Entity.LEFT: return Entity.UP;
        default: return IllegalMove.NOT_A_PLAYER?;
    }
}

fn int[<2>]! load_map()
{
	File f = file::open(FILE, "r")!;
	defer (void)f.close();
    int y = 0;
    int[<2>] guard = { 0, 0 };
	while (try line = io::treadline(&f)) {
        foreach(x, ch : line) {
            switch (ch) {
                case '^': 
                    map[y][x] = Entity.UP;
                    guard = { (int)x, y };
                case '>': 
                    map[y][x] = Entity.RIGHT;
                    guard = { (int)x, y };
                case '<': 
                    map[y][x] = Entity.LEFT;
                    guard = { (int)x, y };
                case 'v': 
                    map[y][x] = Entity.DOWN;
                    guard = { (int)x, y };
                case '#': map[y][x] = Entity.WALL;
                default: map[y][x] = Entity.VOID;
            }
        }
        y++;
    }
    return guard;
}

fn void print_map()
{
    for(int y=0; y<SIZE; y++) {
        for(int x=0; x<SIZE; x++) {
            io::printf("%c", map[y][x].view());
        }
        io::printn();
    }
    io::printn();
}

fn int count(Entity entity)
{
    int count = 0;
    for (int y = 0; y< SIZE; y++) {
        for (int x = 0; x< SIZE; x++) {
            if (map[y][x] == entity) count++;
        }
    }

    return count;
}

fn bool out_of_bounds(int x, int y)
{
    return x < 0 || x == SIZE || y < 0 || y == SIZE;
}

fn long! part1()
{
    int[<2>] guard = load_map()!;
    int x = guard[0];
    int y = guard[1];
    bool active = true;

    //for(int i = 0; i< 60; i++) {
    while(active) {
        //print_map();
        if (out_of_bounds(x, y)) break;
        switch (map[y][x]) {
            case Entity.UP:  
                if (out_of_bounds(x, y-1)) {
                    map[y][x] = Entity.VISITED;
                } else if (map[y-1][x] == Entity.VOID || map[y-1][x] == Entity.VISITED) {
                    map[y][x] = Entity.VISITED;
                    map[--y][x] = Entity.UP;
                } else {
                    map[y][x] = map[y][x].turn_90()!;
                }
            case Entity.RIGHT: 
                if (out_of_bounds(x+1, y)) {
                    map[y][x] = Entity.VISITED;
                } else if (map[y][x+1] == Entity.VOID || map[y][x+1] == Entity.VISITED) {
                    map[y][x] = Entity.VISITED;
                    map[y][++x] = Entity.RIGHT;
                } else {
                    map[y][x] = map[y][x].turn_90()!;
                }
            case Entity.DOWN: 
                if (out_of_bounds(x, y+1)) {
                    map[y][x] = Entity.VISITED;
                } else if (map[y+1][x] == Entity.VOID || map[y+1][x] == Entity.VISITED) {
                    map[y][x] = Entity.VISITED;
                    map[++y][x] = Entity.DOWN;
                } else {
                    map[y][x] = map[y][x].turn_90()!;
                }
            case Entity.LEFT:
                if (out_of_bounds(x-1, y)) {
                    map[y][x] = Entity.VISITED;
                } else if (map[y][x-1] == Entity.VOID || map[y][x-1] == Entity.VISITED) {
                    map[y][x] = Entity.VISITED;
                    map[y][--x] = Entity.LEFT;
                } else {
                    map[y][x] = map[y][x].turn_90()!;
                }
            default: 
                active = false;
        }
    }

    print_map();
    return count(Entity.VISITED);
}

fn long! part2()
{
	int total = 0;
    return total;
}

fn void main()
{
    Clock c = clock::now();
    io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}

