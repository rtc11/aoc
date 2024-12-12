import std::io, std::time, std::collections, std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1(map)!!, c.mark());
        io::printfn("- Part2: %d - %s", part2(map)!!, c.mark());
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
    String input = (String) file::load_temp("input.txt")!;
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
    String input = (String) file::load_temp("input.txt")!;
    String[] map = input.trim().tsplit("\n");
    Garden garden = solve(map)!;
    usz sum;
    foreach(region: garden) {
        usz price = horizontals(&region) + verticals(&region);
        sum += region.locations.len() * price;
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

fn usz horizontals(Region *region, String[] map)
{
    usz fences;
    foreach(Pos pos: region.locations) {
        
    }
    return fences;
}

fn usz verticals(Region *region, String[] map)
{
    usz fences;
    foreach(Pos pos: region.locations) {

    }
    return fences;
}
