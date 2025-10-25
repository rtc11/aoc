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
        
        foreach(Dir dir: { Dir.S, Dir.N, Dir.E, Dir.W}) {
            Pos next = pos + dir.pos;
            if (next.x < 0 || next.x >= map.len) continue;
            if (next.y < 0 || next.y >= map.len) continue;
            if (map[next.y][next.x] == region.plant) {
                queue.push(next);
                region.fences--;
            }
        }
    }
}

enum Dir : (Pos pos) {
    S  = { 1, 0 },
    SE = { 1, 1 },
    SW = { 1,-1 },
    E  = { 0, 1 },
    W  = { 0,-1 },
    N  = {-1, 0 },
    NE = {-1, 1 },
    NW = {-1,-1 },
}

fn bool Region.has(&self, Pos pos, Dir dir) => self.locations.contains(pos + dir.pos); 

fn usz edges(Region *region)
{
    usz edges;
    foreach(Pos pos: region.locations) {
        if (!region.has(pos, Dir.W) && !region.has(pos, Dir.NW) && !region.has(pos, Dir.N)) edges++;
        if (!region.has(pos, Dir.N) && !region.has(pos, Dir.NE) && !region.has(pos, Dir.E)) edges++;
        if (!region.has(pos, Dir.E) && !region.has(pos, Dir.SE) && !region.has(pos, Dir.S)) edges++;
        if (!region.has(pos, Dir.S) && !region.has(pos, Dir.SW) && !region.has(pos, Dir.W)) edges++;
        if (region.has(pos, Dir.W) && region.has(pos, Dir.N) && !region.has(pos, Dir.NW)) edges++;
        if (region.has(pos, Dir.N) && region.has(pos, Dir.E) && !region.has(pos, Dir.NE)) edges++;
        if (region.has(pos, Dir.E) && region.has(pos, Dir.S) && !region.has(pos, Dir.SE)) edges++;
        if (region.has(pos, Dir.S) && region.has(pos, Dir.W) && !region.has(pos, Dir.SW)) edges++;
        if (region.has(pos, Dir.SE) && !region.has(pos, Dir.E) && !region.has(pos, Dir.S)) {
            edges++;
            edges++;
        }
        if (region.has(pos, Dir.NE) && !region.has(pos, Dir.N) && !region.has(pos, Dir.E)) {
            edges++;
            edges++;
        }

    }
    return edges;
}

