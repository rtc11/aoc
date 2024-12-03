import std::io;
import std::core;
import std::math;
import std::collections;
import input;

struct Day3 {
    List(<Mul>) muls;
}

fn Day3 into_day3(String line)
{
    List(<Mul>) muls = lexer(line);
    return Day3 { muls };
}

fn void! main()
{
    Input(<Day3>) input = input::from(<Day3>)("input.txt", &into_day3);

    io::printn("");
    input.print();
    input.part1();

    io::printn("");
    input.part2();
}

fn void Input(<Day3>).print(&self)
{
    foreach(line: self.lines)
    {
        foreach(mul : line.muls)
        {
            io::printfn("%s * %s", mul.a, mul.b);
        }
    }
}

fn void Input(<Day3>).part1(&self)
{
    usz sum = 0;
    foreach(line: self.lines)
    {
        foreach(mul : line.muls)
        {
            sum += mul.a * mul.b;
        }
    }
    io::printfn("part1:  %s", sum);

}

fn void Input(<Day3>).part2(&self)
{
}

struct Mul {
    long a;
    long b;
}

fn void reset(bool* build, DString* mul, bool* left, long* a, long* b, DString* num) {
    *build = false;
    mul.clear();
    *left = true;
    *a = 0;
    *b = 0;
    num.clear();
}

fn List(<Mul>) lexer(String input)
{
    List(<Mul>) muls;
    muls.new_init();
    bool build = false;
    DString mul;
    bool left = true;
    long a = 0;
    long b = 0;
    DString num;

    foreach(i, ch: input)
    {
        switch (ch)
        {
            case 'm':
                if (!build) {
                    mul.append_char(ch);
                    build = true;
                }
            case 'u':
                if (build && mul.str_view() == "m") {
                    mul.append_char(ch);
                } else {
                    reset(&build, &mul, &left, &a, &b, &num);
                }
            case 'l':
               if (build && mul.str_view() == "mu") {
                    mul.append_char(ch);
               } else {
                    reset(&build, &mul, &left, &a, &b, &num);
               }
            case '(':
                if (build && mul.str_view() == "mul") {
                    mul.append_char(ch);
                } else {
                    reset(&build, &mul, &left, &a, &b, &num);
                }
            case ')':
                if (build && mul.str_view() == "mul(" ) {
                    build = false;
                    left = true;
                    if (num.len() > 0) {
                        String str = num.str_view();
                        b = str.to_long()!!;
                        Mul m = Mul {a, b};
                        muls.push(m);
                        b = 0;
                        a = 0;
                        num.clear(); 
                        mul.clear(); 
                    }
                } else {
                    reset(&build, &mul, &left, &a, &b, &num);
                }
            case ',':
                if (build && mul.str_view() == "mul(" && left == true && num.len() > 0)
                {
                    String str = num.str_view();
                    a = str.to_long()!!; 
                    num.clear(); 
                    left = false;
                } else {
                    reset(&build, &mul, &left, &a, &b, &num);
                }
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                if (build && mul.str_view() == "mul(") {
                    num.append_char(ch); 
                } else {
                    reset(&build, &mul, &left, &a, &b, &num);
                }
            default:
                if (build) {
                    reset(&build, &mul, &left, &a, &b, &num);
                }
        }
    }

    return muls;
}
