import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";
const int SIZE = 50; // 50

fn long! part1() 
{

	File f = file::open(FILE, "r")!;
	defer (void)f.close();
    int row = 0;
    char[SIZE][SIZE] map;
    bool[SIZE][SIZE] antinodes;
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
                    if (x1 == x && y1 == y) continue; // skip this
                    if (map[y1][x1] == this) {
                        // predict next downwards
                        int dx = -1 * (x - x1);
                        int dy = -1 * (y - y1);
                        int nx = x1+dx;
                        int ny = y1+dy;

                        // predict next upwards
                        int fdx = (x-x1);
                        int fdy = (y-y1);
                        int fnx = x+fdx;
                        int fny = y+fdy;

                        io::printfn("%c[%2d,%2d] - %c[%2d,%2d] = [%2d,%2d] => [%2d,%2d] or [%2d,%2d]", this,y+1,x+1,map[y1][x1],y1+1,x1+1,dy+1,dx+1,ny+1,nx+1,fny+1,fnx+1);
                        if (nx>=0 && nx<SIZE && ny>=0 && ny<SIZE) {
                            if (map[ny][nx] != this) {
                               antinodes[ny][nx] = true; 
                            } 
                        }
                        if (fnx>=0 && fnx<SIZE && fny>=0 && fny<SIZE) {
                            if (map[fny][fnx] != this) {
                               antinodes[fny][fnx] = true; 
                            } 
                        }

                    }
                }
            }
        }
    }
    int total = 0;
    for(int y = 0; y < SIZE; y++) {
        for(int x = 0; x < SIZE; x++) {
            //io::printf("%c", map[y][x]);
            if (antinodes[y][x]) total++;
        }
        //io::printn();
    }
    return total;
}

fn long! part2() 
{
	File f = file::open(FILE, "r")!;
	defer (void)f.close();
    int row = 0;
    char[SIZE][SIZE] map;
    bool[SIZE][SIZE] antinodes;
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
                    if (x1 <= x && y1 == y) continue; // skip until this
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

                        //io::printf("%c[%2d,%2d] - ", this,y+1,x+1);
                        //io::printf("%c[%2d,%2d] = ", map[y1][x1],y1+1,x1+1);
                        //io::printf("[%2d,%2d] => ", dy,dx);
                        while(nx>=0 && nx<SIZE && ny>=0 && ny<SIZE) {
                            //io::printf("v[%2d,%2d], ", ny+1,nx+1);
                            if (map[ny][nx] != this) {
                               antinodes[ny][nx] = true; 
                            } 
                            nx+=dx;
                            ny+=dy;
                        }

                        while(fnx>=0 && fnx<SIZE && fny>=0 && fny<SIZE) {
                            //io::printf("^[%2d,%2d], ", fny+1,fnx+1);
                            if (map[fny][fnx] != this) {
                               antinodes[fny][fnx] = true; 
                            } 
                            fnx+=fdx;
                            fny+=fdy;
                        }
                        //io::printn();

                    }
                }
            }
        }
    }
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

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

