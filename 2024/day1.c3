import std::io;
import std::math;
import std::collections;

struct Pair {
    usz left;
    usz right;
}

fn Pair into_day1(String line) {
    String[] split = line.tsplit("   ");
    return Pair {
        split[0].to_long()!!, 
        split[1].to_long()!!
    };
}

fn void! main()
{
    File f = file::open("test.txt", "rb")!!; 
    defer (void) f.close();
    List(<Pair>) pairs;
    while (try line = io::treadline(&f)) 
    {
        pairs.push(into_day1(line));
    }
    part1(pairs);
    part2(pairs);
}

fn void part1(List(<Pair>) pairs)
{
    PriorityQueue(<long>) left, right;
    long sum = 0;
    left.temp_init();
    right.temp_init();
    foreach(pair : pairs) {
        left.push(pair.left);
        right.push(pair.right);
    }

    while (left.len()) {
        long diff = math::abs(left.pop() - right.pop())!!;
        sum += diff;
    }
    left.free();
    right.free();

    io::printfn("part1: %d" , sum);
}

fn void part2(List(<Pair>) pairs)
{
    List(<usz>) right;
    foreach(pair : pairs) {
        right.push(pair.right);
    }
    usz sum = 0;
    foreach (pair : pairs) {
        sum += pair.left * count(pair.left, right);
    }
    right.free();
    io::printfn("part2: %d", sum);
}

fn usz count(usz num, List(<usz>) list)
{
    usz sum = 0;
    foreach (l : list) {
        if (l == num) {
            sum++;
        }
    }
    return sum;
}
