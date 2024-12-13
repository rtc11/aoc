import std::io, std::time, std::collections, std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

def Pos = isz[<2>];
def Garden = List(<Region>);
Pos[4] dirs = { {1,0}, {-1,0}, {0,1}, {0,-1} };

struct Region 
{
    char plant;
    usz fences;
    List(<Pos>) locations;
}

fn long! part1()
{
    String input = (String) file::load_temp("test.txt")!;
    String[] map = input.trim().tsplit("\n");
    Garden garden = solve(map)!;
    usz sum;
    foreach(region: garden) {
        usz price = region.locations.len() * region.fences;
        sum += price;
    }
    return sum;
}

fn long! part2()
{
    String input = (String) file::load_temp("test.txt")!;
    String[] map = input.trim().tsplit("\n");
    Garden garden = solve(map)!;
    usz sum;
    foreach(region: garden) {
        sum += region.locations.len() * edges(&region);
    }
    return sum;
}

fn Garden! solve(String[] map)
{
    List(<Pos>) visited;
    visited.temp_init(); 

    Garden garden;
    garden.temp_init(); 

    for (int y; y<map.len; y++) {
        for(int x; x<map[0].len; x++) {
            char plant = map[y][x];
            Pos pos = {(isz)x, (isz)y};
            if (visited.contains(pos)) continue;
            List(<Pos>) locations;
            Region region = { plant, 0, *locations.temp_init() };
            traverse(&region, &visited, pos, map)!;
            garden.push(region);
        }
    }

    return garden;
}

fn void! traverse(Region *region, List(<Pos>) *visited, Pos init, String[] map)
{
    List(<Pos>) queue;
    queue.temp_init();
    queue.push(init);

    while (queue.len()) {
        Pos pos = queue.pop()!;
        if (visited.contains(pos)) continue;

        visited.push(pos);
        region.locations.push(pos);
        region.fences += 4;
        
        foreach(dir: dirs) {
            Pos next = pos + dir;
            if (next.x < 0 || next.x >= map.len) continue;
            if (next.y < 0 || next.y >= map.len) continue;
            if (map[next.y][next.x] == region.plant) {
                queue.push(next);
                region.fences--;
            }
        }
    }
}

Pos[8] all_dirs = { 
    { 1, 0 }, //0 S 
    {-1, 0 }, //1 N
    { 0, 1 }, //2 E
    { 0,-1 }, //3 W
    { 1, 1 }, //4 SE
    {-1,-1 }, //5 NW
    { 1,-1 }, //6 SW
    {-1, 1 }  //7 NE
};

fn usz edges(Region *region)
{
    usz edges;
    foreach(Pos pos: region.locations) {
        // ?? 
        // ?X
        if (!region.locations.contains(pos + all_dirs[1]) && !region.locations.contains(pos + all_dirs[3]) && !region.locations.contains(pos + all_dirs[5])) {
            edges++;
        } 
        // ?? 
        // X?
        if (!region.locations.contains(pos + all_dirs[1]) && !region.locations.contains(pos + all_dirs[2]) && !region.locations.contains(pos + all_dirs[7])) {
            edges++;
        } 
        // X? 
        // ??
        if (!region.locations.contains(pos + all_dirs[2]) && !region.locations.contains(pos + all_dirs[0]) && !region.locations.contains(pos + all_dirs[4])) {
            edges++;
        }
        // ?X 
        // ??
        if (!region.locations.contains(pos + all_dirs[3]) && !region.locations.contains(pos + all_dirs[0]) && !region.locations.contains(pos + all_dirs[6])) {
            edges++;
        }
        // ?X
        // XX
        if (region.locations.contains(pos + all_dirs[1]) && region.locations.contains(pos + all_dirs[3]) && !region.locations.contains(pos + all_dirs[5])) {
            edges++;
        }
        // X?
        // XX
        if (region.locations.contains(pos + all_dirs[1]) && region.locations.contains(pos + all_dirs[2]) && !region.locations.contains(pos + all_dirs[7])) {
            edges++;
        }
        // XX
        // X?
        if (region.locations.contains(pos + all_dirs[2]) && region.locations.contains(pos + all_dirs[0]) && !region.locations.contains(pos + all_dirs[4])) {
            edges++;
        }
        // XX
        // ?X
        if (region.locations.contains(pos + all_dirs[3]) && region.locations.contains(pos + all_dirs[0]) && !region.locations.contains(pos + all_dirs[6])) {
            edges++;
        }
        
    }
    return edges;
}

