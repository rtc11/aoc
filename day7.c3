import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";

def Operator = fn long(long, long);

fn long add(long a, long b) => a + b;
fn long mul(long a, long b) => a * b;

fn bool valid_calibration(long sum, long[] operands, Operator[] operators) => 
    dfs(sum, operands, 1, operands[0], operators);

fn bool dfs(long sum, long[] operands, usz pos, long cur, Operator[] operators)
{
    if (pos >= operands.len) return sum == cur;
    bool r;
    foreach (operator: operators) {
        r = dfs(sum, operands, pos + 1, operator(cur, operands[pos]), operators);
        if (r) return true;
    }
    return false;
}

fn long part1()
{
	String input = (String)file::load_temp(FILE)!!;
    long total = 0;
    long[64] operands;
    Operator[] operators = { &add, &mul };

    foreach (line: input.tsplit("\n")) {
        if (!line.len) continue;
        String[] split = line.tsplit(":");
        long sum = split[0].to_long()!!;
        usz i;
        foreach (operand : split[1].tsplit(" ")) {
            if (!operand.len) continue;
            operands[i++] = operand.trim().to_long()!!;
        }
        if (valid_calibration(sum, operands[:i], operators)) {
            total += sum; 
        }
    }

    return total;
}

fn long! part2()
{
    return 0;
}

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1(), c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

