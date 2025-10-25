import std::io, std::time, std::collections;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!, c.mark());
    };
}

const int SIZE = 71;    // 71 and 7
const int COUNT = 1024; // 1024 and 12
const String FILE = "input"; // 328 too high

int[SIZE][SIZE] map;
int[SIZE][SIZE] walls;

fn int! part1()
{
    String input = (String) file::load_temp(FILE)!;

    foreach IN: (i, line : input.trim().tsplit("\n")) {
        if(i == COUNT) break IN;
        String[] pos = line.trim().tsplit(",");
        int x = pos[0].to_int()!;
        int y = pos[1].to_int()!;
        walls[x][y] = -1;
    }

    travel(0,0);

    for(int y; y<SIZE; y++) {
        for(int x; x<SIZE; x++) {
            io::printf("%4d", map[x][y]);
        }
        io::printn();
    }
    return map[SIZE-1][SIZE-1];
}

fn void travel(int x, int y)
{
    if((x==y)&&(x==SIZE-1)) return;

    if(x && walls[x-1][y]==0 && ((!map[x-1][y])|| map[x-1][y]>map[x][y]+1))
    {
        map[x-1][y]=map[x][y]+1;
        travel(x-1,y);
    }
    if(y && walls[x][y-1]==0 && ((!map[x][y-1])|| map[x][y-1]>map[x][y]+1))
    {
        map[x][y-1]=map[x][y]+1;
        travel(x,y-1);
    }
    if(x<SIZE-1 && walls[x+1][y]==0 && ((!map[x+1][y])|| map[x+1][y]>map[x][y]+1))
    {
        map[x+1][y]=map[x][y]+1;
        travel(x+1,y);
    }
    if(y<SIZE-1 && walls[x][y+1]==0 && ((!map[x][y+1])|| map[x][y+1]>map[x][y]+1))
    {
        map[x][y+1]=map[x][y]+1;
        travel(x,y+1);
    }
}

