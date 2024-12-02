import std::io;
import std::math;
import std::collections;
import input;

struct Day2 {
    List(<usz>) levels;
}

fn Day2 into_day2(String line) {
    String[] split = line.tsplit(" ");
    List(<usz>) levels;
    foreach(lvl : split) {
        levels.push(lvl.to_long()!!);
    }
    return Day2 { levels };
}

fn void! main()
{
    Input(<Day2>) input = input::from(<Day2>)("input.txt", &into_day2);

//    foreach(line : input.lines) {
//        foreach(lvl: line.levels) {
//            io::printf("%s ", lvl);
//        }
//        io::printn("");
//    }

    input.part1();
    //input.part2();
}

fn bool Day2.left_is_good(&self, usz curr) 
{
    long diff = math::abs(self.levels[curr - 1] - self.levels[curr]);
    return diff >= 1 && diff <= 3;
}

fn bool Day2.right_is_good(&self, usz curr) 
{
    if (curr + 1 < self.levels.len()) {
        long diff = math::abs(self.levels[curr] - self.levels[curr + 1]);
        return diff >= 1 && diff <= 3;
    } else {
        return true;
    }
}

fn void Input(<Day2>).part1(&self)
{
    int safe_count = 0;

    foreach(line : self.lines) {
        usz curr = 1;
        bool safe = true;
        bool inc= true;
        bool dec = true;

        while (curr < line.levels.len()) {
            if (line.levels[curr - 1] < line.levels[curr] && line.left_is_good(curr) && line.right_is_good(curr)) {
                dec = false;
            } else if (line.levels[curr - 1] > line.levels[curr] && line.left_is_good(curr) && line.right_is_good(curr)) {
                inc = false;
            } else {
                safe = false;
            }
            curr++;
        }
        if (safe && inc != dec) {
            safe_count++;
        }
    }

    io::printfn("safe levels: %s", safe_count);
}

