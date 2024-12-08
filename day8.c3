import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";
const int SIZE = 50; // 50
char[SIZE][SIZE] map;
bool[SIZE][SIZE] antinodes;

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
                    if (x1 <= x && y1 == y) continue; // skip this
                    if (map[y1][x1] == this) {
                        // predict next downwards
                        int dx = x1 - x;
                        int dy = y1 - y;
                        int nx = x1+dx;
                        int ny = y1+dy;

                        // predict next upwards
                        int fdx = (x-x1);
                        int fdy = (y-y1);
                        int fnx = x+fdx;
                        int fny = y+fdy;

                        //io::printfn("%c[%2d,%2d] - %c[%2d,%2d] = [%2d,%2d] => [%2d,%2d] or [%2d,%2d]", this,y+1,x+1,map[y1][x1],y1+1,x1+1,dy+1,dx+1,ny+1,nx+1,fny+1,fnx+1);
                        find_antinodes(nx, ny, dx, dy, this);
                        find_antinodes(fnx, fny, fdx, fdy, this);
                    }
                }
            }
        }
    }
    return total();
}

def TotalFn = fn int();

fn int unique()
{
    int total = 0;
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            //io::printf("%c", map[y][x]);
            if (antinodes[y][x]) {
                total++;
            } 
        }
        //io::printn();
    }
    return total;
}

fn int unique_with_same_locaiton()
{
    int total = 0;
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            if (antinodes[y][x] || map[y][x] != '.') {
                total++;
                if (antinodes[y][x]) {
                    //io::printf("%c", '#');
                } else {
                    //io::printf("%c", map[y][x]);
                }
            } else {
                //io::printf("%c", '.');
            }
        }
        //io::printn();
    }
    return total;
}

def AntinodeFn = fn void(int, int, int, int, char);

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
        //io::printf("v[%2d,%2d], ", y+1,x+1);
        if (map[y][x] != c) {
           antinodes[y][x] = true; 
        } 
        x+=dx;
        y+=dy;
    }
}

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", solve(&adjacent, &unique)!!, c.mark());
        io::printfn("- Part2: %d - %s", solve(&rays, &unique_with_same_locaiton)!!, c.mark());
    };
}

