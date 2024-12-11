import std::io;
import std::time;
import std::collections;
import std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        stones.temp_init();
        mem.temp_init();
        io::printfn("- Part1: %d - %s", solve(25)!!, c.mark());
        io::printfn("- Part2: %d - %s", solve(75)!!, c.mark());
    };
}

const String FILE = "input.txt";

def Stones = HashMap(<usz, usz>);
def Memoization = HashMap(<usz, List(<usz>)>);
Stones stones;
Memoization mem;

fn bool is_even(usz num) => num > 0 && (string::tformat("%s", num).len % 2) == 0; 
fn bool is_zero(usz num) => num == 0;

fn void! parse(String input)
{
    foreach(stone: input.tsplit(" ")) {
        usz num = stone.to_long()!!;
        stones[num] = stones.@get_or_set(num, 1);
    }
}

fn List(<usz>)! rule(usz stone)
{
    if (mem.has_key(stone)) {
        return mem[stone]!;
    } 

    List(<usz>) change;
    switch {
        case is_zero(stone): 
            change.push(1); 
        case is_even(stone):
            String num_str = string::tformat("%s", stone); 
            change.push(num_str[..num_str.len/2 -1].to_long()!);
            change.push(num_str[(num_str.len/2)..].to_long()!);
        default: 
            change.push(stone * 2024);
    }
    mem[stone] = change;
    return change;
}

fn void! blink()
{
    Stones changed;
    changed.temp_init();
    stones.@each(; usz stone, usz count) {
        List(<usz>) changes = rule(stone)!;
        foreach(change: changes) {
            changed[change] = changed.@get_or_set(change, 0) + count;
        }
    };
    @swap(stones, changed);

}

fn long! solve(int blinks)
{
	String input = (String) file::load_temp(FILE)!;
    stones.clear();
    mem.clear();
    usz sum = 0;
    parse(input.trim())!;

    for (int b = 0; b <blinks; b++) blink()!;

    stones.@each(; usz stone, usz count) {
        sum += count;
    };

    return sum;
}

