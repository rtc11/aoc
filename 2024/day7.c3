import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";

def Operator = fn long(long, long);

fn long add(long a, long b) => a + b;
fn long mul(long a, long b) => a * b;
fn long combine(long a, long b)
{
    String str_a = string::tformat("%d", a);
    String str_b = string::tformat("%d", b);
    return str_a.tconcat(str_b).to_long()!!;
}

fn bool valid_calibration(long sum, long[] operands, Operator[] operators) => 
    dfs(sum, operands, 1, operands[0], operators);

fn bool dfs(long sum, long[] operands, usz pos, long cur, Operator[] operators)
{
    if (pos >= operands.len) return sum == cur;
    foreach (operator: operators) {
        if(dfs(sum, operands, pos + 1, operator(cur, operands[pos]), operators)) {
            return true;
        }
    }
    return false;
}

fn long solve(Operator[] operators)
{
	String input = (String)file::load_temp(FILE)!!;
    long total = 0;
    long[64] operands;

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

fn long part1() => solve({ &add, &mul }); 
fn long part2() => solve({ &add, &mul, &combine });

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1(), c.mark());
        io::printfn("- Part2: %d - %s", part2(), c.mark());
    };
}

