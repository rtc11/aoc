import std::io;
import std::time::clock;
import std::collections::list;

usz p1;
usz p2;

macro mod(num, m) => (num % m + m) % m;

fn void main()
{
    Clock c = clock::now();
    defer log::info("part1 %d %s", p1, c.mark());
    defer log::info("part2 %d %s", p2, c.mark());

    String input = (String) file::load(tmem, "input.txt")!!;
    String[] lines = input.tsplit("\n");

    foreach(lidx, line: lines) {
        if (!line) continue;
        String[] sets = line.tsplit(",");
        foreach(sidx, set: sets) {
            if (!set) continue;
            io::printfn("set: %s", set);

            String[] range = set.tsplit("-");
            usz from = (usz) range[0].to_int128()!!;
            usz to = (usz) range[1].to_int128()!!;

            for(usz i = from; i <= to; i++) {
                p1 += repeated_or_zero(i);
                p2 += multi_repeated_or_zero(i);
            }
        }
    }
}

fn usz repeated_or_zero(usz num)
{
    if (num < 10) return 0;
    String n = string::tformat("%s", num);
    if (mod(n.len, 2) != 0) return 0;
    int128 left = n[0..n.len/2-1].to_int128()!!;
    int128 right = n[n.len/2..].to_int128()!!;
    if (left == right) {
        int128 invalid = string::tformat("%s%s", left, right).to_int128()!!;
        return (usz) invalid;
    }
    return 0;
}

fn usz multi_repeated_or_zero(usz num)
{
    if (num < 11) return 0;
    String n = string::tformat("%s", num);
    int len = n.len;

    for (int s = 1; s < len; s++) {
        if (mod(len, s) != 0) continue; 
        int repeats = len / s;
        String candidate = n[0..s-1];
        String test;
        for (int i = 0; i < repeats; i++) {
            test = test.concat(tmem, candidate);
        }
        if (test == n) {
            return num;
        }
    }
    return 0;
}
