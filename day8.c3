import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";
const int SIZE = 50;
char[SIZE][SIZE] map;
bool[SIZE][SIZE] antinodes;

def TotalFn = fn int();
def AntinodeFn = fn void(int, int, int, int, char);

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", solve(&adjacent, &unique)!!, c.mark());
        io::printfn("- Part2: %d - %s", solve(&rays, &unique_with_same_locaiton)!!, c.mark());
    };
}

fn long! solve(AntinodeFn find_antinodes, TotalFn total) 
{
	File f = file::open(FILE, "r")!;
	defer (void)f.close();
    int row = 0;
	while (try line = io::treadline(&f)) {
        foreach(col, ch : line) {
            map[row][col] = ch; 
        }
        row++;
    }
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            char this = map[y][x];
            if (this == '.') continue;

            for (int y1 = y; y1 < SIZE; y1++) {
                for (int x1 = 0; x1 < SIZE; x1++) {
                    if (x1 <= x && y1 == y) continue;
                    if (map[y1][x1] == this) {
                        find_antinodes(x1+x1-x, y1+y1-y, x1-x, y1-y, this);
                        find_antinodes(x+x-x1,  y+y-y1,  x-x1, y-y1, this);
                    }
                }
            }
        }
    }
    return total();
}

fn int unique()
{
    int total = 0;
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            if (antinodes[y][x]) total++;
        }
    }
    return total;
}

fn int unique_with_same_locaiton()
{
    int total = 0;
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            if (antinodes[y][x] || map[y][x] != '.') total++;
        }
    }
    return total;
}

fn void adjacent(int x, int y, int dx, int dy, char c)
{
    if (x>=0 && x<SIZE && y>=0 && y<SIZE) {
        if (map[y][x] != c) {
           antinodes[y][x] = true; 
        } 
    }
}

fn void rays(int x, int y, int dx, int dy, char c)
{
    while(x>=0 && x<SIZE && y>=0 && y<SIZE) {
        if (map[y][x] != c) {
           antinodes[y][x] = true; 
        } 
        x+=dx;
        y+=dy;
    }
}

