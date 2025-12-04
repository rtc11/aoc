import std::io;
import std::time::clock;
import std::collections::list;
import std::math;

usz p1;
usz p2;

macro mod(num, m) => (num % m + m) % m;
fn int char.to_int(&self) => *self - '0';

alias Pos = isz[<2>];
alias Grid = List{Pos};

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

fn void main()
{
    Clock c = clock::now();
    defer io::printfn("part1 %d %s", p1, c.mark());
    defer io::printfn("part2 %d %s", p2, c.mark());

    part1();
    part2();
}

fn void part1()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    Grid grid;
    String[] rows = input.tsplit("\n");
    foreach(i, row : rows) {
        foreach(j, col: row) {
            if (col == '@') {
                grid.push({i, j});
            }
        }
    }
    for(int i; i<rows[0].len; i++) {
        for (int j; j<rows[0].len; j++) {
            if (adjacent_papers(grid, {i, j} ) < 4) {
                if (grid.contains({i, j})) {
                    p1++;
                }
            }
        }
    }
}

fn int adjacent_papers(Grid grid, Pos peek)
{
    // io::printf("check %s :: ", peek);
    int count;
    if (!grid.contains(peek)) {
        // io::printfn("%d", count);
        return 0;
    }
    if (grid.contains(peek + Dir.S.pos)) count++;
    if (grid.contains(peek + Dir.SE.pos)) count++;
    if (grid.contains(peek + Dir.SW.pos)) count++;
    if (grid.contains(peek + Dir.E.pos)) count++;
    if (grid.contains(peek + Dir.W.pos)) count++;
    if (grid.contains(peek + Dir.N.pos)) count++;
    if (grid.contains(peek + Dir.NE.pos)) count++;
    if (grid.contains(peek + Dir.NW.pos)) count++;
    // io::printfn("%d", count);
    return count;
}

fn void part2()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    Grid grid;
    String[] rows = input.tsplit("\n");
    foreach(i, row : rows) {
        foreach(j, col: row) {
            if (col == '@') {
                grid.push({i, j});
            }
        }
    }
    int changes = 1;
    int iter;
    while (changes > 0) {
        changes = 0;
        io::printfn("iter %d", iter++);
        for(int i; i<rows[0].len; i++) {
            for (int j; j<rows[0].len; j++) {
                if (adjacent_papers(grid, {i, j} ) < 4) {
                    if (grid.contains({i, j})) {
                        p2++;
                        grid.remove_first_item({i, j});
                        changes++;
                    }
                }
            }
        }
    }
}

