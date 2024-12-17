import std::io, std::time;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!, c.mark());
    };
}

const int SIZE = 141;
def Map = int[5][SIZE][SIZE];
Map map;

/*
int[<2>][4] dirs = {
    { 1, 0 }, // E
    { 0,-1 }, // N
    {-1, 0 }, // W
    { 0, 1 }, // S
};
*/

fn int! part1()
{
    //String input = (String) file::load_temp("example1")!; // 7036
    //String input = (String) file::load_temp("example2")!; // 11048
    String input = (String) file::load_temp("input")!;
    int start_x, start_y, end_x, end_y;

    foreach (int y, line : input.trim().tsplit("\n")) {
        foreach(int x, ch: line) {
            map[x][y][0] = ch;
            if (ch == 'S') {
                start_x = x;
                start_y = y;
            }
            if (ch == 'E') {
                end_x = x;
                end_y = y;
            };
        }
    }

    map[start_x][start_y][2] = 1;

    calc(start_x, start_y);
    io::printn();

    return min(
        int[4] {
            map[end_x][end_y][1],
            map[end_x][end_y][2],
            map[end_x][end_y][3],
            map[end_x][end_y][4],
        },
    ) -1;
}

fn int min(int[4] num)
{
    int smallest = int.max;
    for(int i; i<4; i++) {
        if (num[i] && num[i] != 1000 && num[i] < smallest) {
            smallest = num[i];
        }
    }
    return smallest;
}

fn void calc(int x, int y)
{
    //io::printf("(%d,%d),", y+1, x+1);
    int pass;
    int[4] cost = { 
        map[x][y][1] + 1000,
        map[x][y][2] + 1000,
        map[x][y][3] + 1000,
        map[x][y][4] + 1000 
    };

    if (map[x][y][0] == 'E') return;

    if (map[x-1][y][0] != '#')
    {
        cost[0] -= 1000;
        pass = min(cost)+1;
        cost[0] += 1000;
        if((!map[x-1][y][1]) || map[x-1][y][1] > pass) 
        {
            map[x-1][y][1] = pass;
            calc(x-1, y);
        }
    }

    if (map[x][y+1][0] != '#')
    {
        cost[1] -= 1000;
        pass = min(cost)+1;
        cost[1] += 1000;
        if((!map[x][y+1][2]) || map[x][y+1][2] > pass) 
        {
            map[x][y+1][2] = pass;
            calc(x, y+1);
        }
    }
    if (map[x+1][y][0] != '#')
    {
        cost[2] -= 1000;
        pass = min(cost)+1;
        cost[2] += 1000;
        if((!map[x+1][y][3]) || map[x+1][y][3] > pass) 
        {
            map[x+1][y][3] = pass;
            calc(x+1, y);
        }
    }
    if (map[x][y-1][0] != '#')
    {
        cost[3] -= 1000;
        pass = min(cost)+1;
        cost[3] += 1000;
        if((!map[x][y-1][4]) || map[x][y-1][4] > pass) 
        {
            map[x][y-1][4] = pass;
            calc(x, y-1);
        }
    }
}

