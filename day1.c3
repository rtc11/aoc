import std::io;
import std::math;
import std::collections;
import input;

struct Day1 {
    usz left;
    usz right;
}

fn Day1 into_day1(String line) {
    String[] split = line.tsplit("   ");
    return Day1 {
        split[0].to_long()!!, 
        split[1].to_long()!!
    };
}

fn void! main()
{
    Input(<Day1>) input = input::from(<Day1>)("test.txt", &into_day1);
    input.part1();
    input.part2();
}

fn void Input(<Day1>).part1(&self)
{
    PriorityQueue(<long>) left, right;
    long sum = 0;
    left.temp_init();
    right.temp_init();
    foreach(line : self.lines) {
        left.push(line.left);
        right.push(line.right);
    }

    while (left.len()) {
        long diff = math::abs(left.pop() - right.pop())!!;
        sum += diff;
    }
    left.free();
    right.free();

    io::printfn("part1: %d" , sum);
}

fn void Input(<Day1>).part2(&self)
{
    List(<usz>) right;
    foreach(line : self.lines) {
        right.push(line.right);
    }
    usz sum = 0;
    foreach (line : self.lines) {
        sum += line.left * input::count(<Day1>)(line.left, right);
    }
    right.free();
    io::printfn("part2: %d", sum);
}

