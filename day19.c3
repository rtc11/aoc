import std::io, std::time, std::collections, std::math;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", solve(&inc)!, c.mark());
        io::printfn("- Part2: %d - %s", solve(&add)!, c.mark());
    };
}

const String FILE = "input";
// const String FILE = "test";

long[100] combos;

def Calc = fn long(long, long);
fn long inc(long acc, long it) => ++acc;
fn long add(long acc, long it) => acc + it;

fn long! solve(Calc calc)
{
    String input = (String) file::load_temp(FILE)!;
    String[] part = input.trim().tsplit("\n\n");
    String[] towels = part[0].trim().tsplit(", ");
    String[] pattern = part[1].trim().tsplit("\n");
    long sum;

    foreach(p: pattern) {
        combos = { [0..99] = -1 };
        long combo = p.combo(towels, 0);
        if (combo != 0) {
            sum = calc(sum, combo);
        }
    }

    return sum;
}

fn long String.combo(self, String[] towels, int idx)
{
    if (combos[idx] != -1) return combos[idx];
    long res;
    String sub_pattern = (String) self[idx..];
    foreach(towel: towels)
    {
        if (towel.len == sub_pattern.len && sub_pattern == towel)
        {
            res++;
        }
        if (towel.len < sub_pattern.len && (String) sub_pattern[..towel.len-1] == towel)
        {
            res += self.combo(towels, idx+towel.len);
        }
    }

    combos[idx] = res;
    return res;
}

