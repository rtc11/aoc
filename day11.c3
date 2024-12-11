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

fn void! parse(String input) {
    foreach(stone: input.tsplit(" ")) {
        usz num = stone.to_long()!!;
        if (stones.has_key(num)) {
            stones[num] = stones[num]! + 1;
        } else {
            stones[num] = 1;
        }
    }
}

fn List(<usz>)! rule(usz stone)
{
    List(<usz>) s;
    if (mem.has_key(stone)) {
        s = mem[stone]!;
    } else {
        switch {
            case is_zero(stone): 
                s.push(1); 
            case is_even(stone):
                String num_str = string::tformat("%s", stone); 
                String left = (String) num_str[..num_str.len/2 -1];
                String right = (String) num_str[(num_str.len/2)..];
                s.push(left.to_long()!!);
                s.push(right.to_long()!!);
            default: s.push(stone * 2024);
        }

    }

    mem[stone] = s;
    return s;
}

fn void! blink()
{
    Stones new;
    new.temp_init();
    stones.@each(; usz stone, usz count) {
        List(<usz>) split = rule(stone)!;
        foreach(s: split){
            if (new.has_key(s)) {
            new[s] = new[s]! + count;
            } else {
                new[s] = count;
            }
        }
    };
    @swap(stones, new);

}

fn long! solve(int blinks)
{
	String input = (String) file::load_temp(FILE)!;
    stones.clear();
    mem.clear();
    parse(input.trim())!;
    usz sum = 0;

    for (int b = 0; b <blinks; b++) {
        blink()!;
    }
    stones.@each(; usz stone, usz count) {
        sum += count;
    };

    return sum;
}

