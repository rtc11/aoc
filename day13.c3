import std::io, std::time, std::collections, std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

def Pos = isz[<2>];

struct Machine {
    Pos a;
    Pos b;
    Pos price;
}

fn long! part1() => solve(0);
fn long! part2() => solve(10000000000000);

fn long! solve(isz offset)
{
    String input = (String) file::load_temp("input.txt")!;
    String[] machines = input.trim().tsplit("\n\n");
    usz sum;
    foreach(machine: machines) {
        Machine m = from(machine, offset);
        // Cramers rule
        usz a = (m.price.x*m.b.y - m.price.y*m.b.x) / (m.a.x*m.b.y - m.a.y*m.b.x);
        usz b = (m.a.x*m.price.y - m.a.y*m.price.x) / (m.a.x*m.b.y - m.a.y*m.b.x);
        if (m.price.x == m.a.x * a + m.b.x * b && m.price.y == m.a.y * a + m.b.y * b) {
            sum += 3*a + b;
        }
    }
    return sum;
}

fn Machine from(String input, isz offset)
{
    String[] parts = input.tsplit("\n");
    String[] a = ((String) parts[0][9..].trim()).tsplit(", ");
    String[] b = ((String) parts[1][9..].trim()).tsplit(", ");
    String[] price = ((String) parts[2][6..].trim()).tsplit(", ");

    return Machine {
        .a = { a[0][1..].to_long()!!, a[1][1..].to_long()!! },
        .b = { b[0][1..].to_long()!!, b[1][1..].to_long()!! },
        .price = { price[0][2..].to_long()!! + offset, price[1][2..].to_long()!! + offset }
    };
}

