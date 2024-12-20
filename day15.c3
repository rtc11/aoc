import std::io, std::time, std::collections, std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        // io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

def Pos = isz[<2>];
const int SIZE = 50;
char[SIZE][SIZE] map = { [0..SIZE-1][0..SIZE-1] = '.' };
Pos robot = { 0, 0 };

fn long! part1()
{
    String input = (String) file::load_temp("input")!; 
    String[] parts = input.trim().tsplit("\n\n");
    foreach(y, line: parts[0].trim().tsplit("\n")) {
        foreach(x, ch : line) {
            if (ch == '@') {
                robot = {x, y};
                map[x][y] = '.';
            } else {
                map[x][y] = ch;
            }
        }
    }

    // print();
    int idx;

    foreach(i, line : parts[1].trim().tsplit("\n")) {
        foreach (j, m: line) {
            // io::printfn("%c", m);
            switch (m) {
                case '<': move({-1, 0});
                case 'v': move({0, 1});
                case '>': move({1, 0});
                case '^': move({0, -1});
            }
            // print();
        }
    }

    return calc_gps();
}

fn void move(Pos dir)
{
    Pos p = robot + dir;
    // io::printfn("%s => %s", robot, p);

    switch (map[p.x][p.y]) {
        case '#': 
            return;
        case '.':
            robot = p;
            return;
        case 'O':
            int idx;
            bool can_push;
            while SNIPE: (true) {
                Pos next = p + (idx * dir);

                if (map[next.x][next.y] == '#') {
                    break SNIPE;
                }
                if (map[next.x][next.y] == 'O') {
                    idx++;
                }
                if (map[next.x][next.y] == '.') {
                    can_push = true;
                    break SNIPE;
                }
            }

            if (idx != 0 && can_push) {
                robot = p;
                Pos next = p + (idx*dir);
                map[next.x][next.y] = 'O';
                map[p.x][p.y] = '.';
            }
    }
}

fn void print()
{
    for (int y; y< SIZE; y++){
        for (int x; x< SIZE; x++){
            if(robot == {x, y}) {
                io::printf("%c", '@');
            } else {
                io::printf("%c", map[x][y]);
            }
        }
        io::printn();
    }
    io::printn();
}

fn long calc_gps()
{
    long gps;
    for (long y; y< SIZE; y++){
        for (long x; x< SIZE; x++){
            if(map[x][y] == 'O') {
                gps += 100*y+x;
            }
        }
    }
    return gps;
}
