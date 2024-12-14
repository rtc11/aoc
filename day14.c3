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
const int WIDTH = 101; //11;
const int HEIGHT = 103; //7;

struct Robot {
    Pos pos;
    Pos vel;
}

fn long! part1()
{
    String input = (String) file::load_temp("input.txt")!; // 224735616 too low
    List(<Robot>) robots = from(input.trim().tsplit("\n"));
    usz[<4>] quads;

    foreach(r: robots) {
        for(int i; i<100; i++) {
            Robot.walk(&r);
        }

        if (r.pos.x < WIDTH/2 && r.pos.y < HEIGHT/2) quads[0]++;
        if (r.pos.x > WIDTH/2 && r.pos.y < HEIGHT/2) quads[1]++;
        if (r.pos.x < WIDTH/2 && r.pos.y > HEIGHT/2) quads[2]++;
        if (r.pos.x > WIDTH/2 && r.pos.y > HEIGHT/2) quads[3]++;
    }

    return quads.product();
}

fn long! part2()
{
    String input = (String) file::load_temp("input.txt")!; // 224735616 too low
    List(<Robot>) robots = from(input.trim().tsplit("\n"));

    for (int i; i<HEIGHT * WIDTH; i++) {
        if (has_formation(&robots, i)) return i;
    }

    return 0;
}

fn bool has_formation(List(<Robot>)* robots, int steps)
{
    int[WIDTH][HEIGHT] map;
    foreach(r: robots) {
        Robot.walk(&r);
        map[r.pos.y][r.pos.x]++;
    } 
    foreach(&row : map) {
        int cons;
        foreach (c: row) {
            if (c == 0) {
                cons = 0;
                continue;
            }
            cons++;
            if (cons > 10) return true;
        }
    }
    return false;
}

fn void print(char[WIDTH][HEIGHT] map)
{
    for(int y; y<map.len; y++){
        for(int x; x<map[0].len; x++){
            io::printf("%c", map[y][x]);
        }
        io::printn();
    }
}
// C/C3 does not wrap negative numbers with modulo.
macro mod(a, b) => (a % b + b) % b;

fn void Robot.walk(&self)
{ 
    self.pos = {
        mod(self.pos.x + self.vel.x, WIDTH), 
        mod(self.pos.y + self.vel.y, HEIGHT),
    };
}

fn List(<Robot>) from(String[] input)
{
    List(<Robot>) robots;
    robots.temp_init();
    foreach (robot: input) {
        String[] split = robot.tsplit(" ");
        String[] pos = split[0][2..].tsplit(",");
        String[] vel = split[1][2..].tsplit(",");

        robots.push(Robot { 
            .pos = { pos[0].to_long()!!, pos[1].to_long()!! },
            .vel = { vel[0].to_long()!!, vel[1].to_long()!! },
        });
    }
    return robots;
}

