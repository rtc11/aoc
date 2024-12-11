import std::io;
import std::time;
import std::collections;
import std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", solve(25)!!, c.mark());
        //io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

const String FILE = "test.txt";
def Splits = HashMap(<String, String[2]>);

List(<String>) nums;

fn void replace_with(usz idx, usz num) {
    String num_str = string::tformat("%s", num);
    nums.push(num_str);
    nums.swap(idx, nums.len()-1);
    nums.pop()!!;
}

fn void split(usz idx, usz num) {
    String num_str = string::tformat("%s", num);
    char[] left = num_str[..num_str.len/2 -1];
    char[] right = num_str[(num_str.len/2)..];
    replace_with(idx, ((String)left).to_long()!!);
    nums.push((String)right);
}

fn bool is_even(usz num) => num > 0 && (string::tformat("%s", num).len % 2) == 0; 
fn bool is_zero(usz num) => num == 0;

fn long! solve(int blinks)
{
	String input = (String) file::load_temp(FILE)!;
    input = input.trim();
    nums.temp_init();

    foreach(s: input.tsplit(" ")) nums.push(s);

    for (int blink = 0; blink <blinks; blink++) {
        usz len = nums.len(); // skip completed blinks this iter
        for (int i = 0; i< len; i++) {
            usz num = nums[i].to_long()!;
            switch {
                case is_zero(num): replace_with(i, 1);
                case is_even(num): split(i, num);
                default: replace_with(i, num * 2024);
            }
        }
    }

    return nums.len();
}

