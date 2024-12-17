import std::io, std::time;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!, c.mark());
    };
}

const int SIZE = 141;
def Pos = int[<2>];
def Map = int[5][SIZE][SIZE];
Map map;

fn int! part1()
{
    //String input = (String) file::load_temp("example1")!; // 7036
    //String input = (String) file::load_temp("example2")!; // 11048
    String input = (String) file::load_temp("input")!;
    Pos start, end;

    foreach (int y, line : input.trim().tsplit("\n")) {
        foreach(int x, ch: line) {
            map[x][y][0] = ch;
            if (ch == 'S') start = {x, y}; 
            if (ch == 'E') end = {x, y};
        }
    }

    map[start.x][start.y][2] = 1;

    walk(start.x, start.y);
    io::printn();

    return min(
        int[4] {
            map[end.x][end.y][1],
            map[end.x][end.y][2],
            map[end.x][end.y][3],
            map[end.x][end.y][4],
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

fn void walk(int x, int y)
{
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
            walk(x-1, y);
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
            walk(x, y+1);
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
            walk(x+1, y);
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
            walk(x, y-1);
        }
    }
}

