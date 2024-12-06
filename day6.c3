import std::io;
import std::time;
import std::collections;
import std::sort;

const int SIZE = 130; // 130 // 10
const String FILE = "input.txt";

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

fn int[<2>] Entity[SIZE][SIZE].guard(self)
{
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            switch (self[y][x]) {
                case Entity.RIGHT:
                case Entity.LEFT:
                case Entity.UP:
                case Entity.DOWN:
                    return { x, y };
                default:
                    break;
            }
        }
    }
    return { 0, 0 };
}

fn Entity[SIZE][SIZE]! load_map()
{
	File f = file::open(FILE, "r")!;
	defer (void)f.close();
    int y = 0;
    Entity[SIZE][SIZE] map;
	while (try line = io::treadline(&f)) {
        foreach(x, ch : line) {
            switch (ch) {
                case '^': 
                    map[y][x] = Entity.UP;
                case '>': 
                    map[y][x] = Entity.RIGHT;
                case '<': 
                    map[y][x] = Entity.LEFT;
                case 'v': 
                    map[y][x] = Entity.DOWN;
                case '#': 
                    map[y][x] = Entity.WALL;
                default: 
                    map[y][x] = Entity.VOID;
            }
        }
        y++;
    }
    return map;
}

fn void Entity[SIZE][SIZE].view(self)
{
    for(int y=0; y<SIZE; y++) {
        for(int x=0; x<SIZE; x++) {
            io::printf("%c", self[y][x].view());
        }
        io::printn();
    }
    io::printn();
}

fn long count(Entity[SIZE][SIZE] map, Entity entity)
{
    long count = 0;
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
    Entity[SIZE][SIZE] map = load_map()!;
    int[<2>] guard = map.guard();
    int x = guard[0];
    int y = guard[1];
    bool active = true;
    while(active) {
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

    //map.view();
    return count(map, Entity.VISITED);
}

// solution is not correct
fn long! part2()
{
    Entity[SIZE][SIZE] map = load_map()!;
    int[<2>] guard = map.guard();
    int x = guard[0];
    int y = guard[1];
    bool active = true;

    int loops = 0;
    for(int i = 0; i< SIZE*SIZE; i++) {
        if (out_of_bounds(x, y)) active = false;
        switch (map[y][x]) {
            case Entity.UP:  
                if (out_of_bounds(x, y-1)) break;
                if (map[y-1][x] == Entity.RIGHT) {
                    loops++;
                }
                if (map[y-1][x] == Entity.WALL) {
                    map[y][x] = map[y][x].turn_90()!;
                } else {
                    map[--y][x] = Entity.UP;
                }
            case Entity.RIGHT: 
                if (out_of_bounds(x+1, y)) break;
                if (map[y][x+1] == Entity.DOWN) {
                    loops++;
                }
                if (map[y][x+1] == Entity.WALL) {
                    map[y][x] = map[y][x].turn_90()!;
                } else {
                    map[y][++x] = Entity.RIGHT;
                }
            case Entity.DOWN: 
                if (out_of_bounds(x, y+1)) break;
                if (map[y+1][x] == Entity.LEFT) {
                    loops++;
                }
                if (map[y+1][x] == Entity.WALL) {
                    map[y][x] = map[y][x].turn_90()!;
                } else {
                    map[++y][x] = Entity.DOWN;
                }
            case Entity.LEFT:
                if (out_of_bounds(x-1, y)) break;
                if (map[y][x-1] == Entity.UP) {
                    loops++;
                }
                if (map[y][x-1] == Entity.WALL) {
                    map[y][x] = map[y][x].turn_90()!;
                } else {
                    map[y][--x] = Entity.LEFT;
                }
            default: 
                active = false;
        }
    }

    //map.view();
    return loops;
}

fn void main()
{
    Clock c = clock::now();
    io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}

