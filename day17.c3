import std::io, std::time, std::collections, std::math;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        //io::printfn("- Part1: %s - %s", part1(), c.mark());
        io::printfn("- Part2: %d - %s", part2(), c.mark());
    };
}

const int A = 0;
const int B = 1;
const int C = 2;
isz[3] reg;

struct State {
    usz rem;
    long est;
}

fn String part1()
{
    reg[A] = 24847151;
    int[] program = { 2,4,1,5,7,5,1,6,0,3,4,0,5,5,3,0 };
    return solve(program);
}

fn long part2()
{
    reg[A] = 117440;
    int[] program = { 0, 3, 5, 4, 3, 0 };
    return bfs(program);
}

fn long bfs(int[] program)
{
    long a;
    List(<State>) stack = *stack.temp_init();
    stack.push({ .rem = program.len - 1, .est = 0 });
    while LOOP: (stack.len())
    {
        State s = stack.pop_first()!!;
        for (int i = 0; i< 8; i++) {
            a = (s.est << 3) + i;
            reg[A] = a;
            reg[B] = 0;
            reg[C] = 0;
            
            int[] expand_program = program[s.rem..];
            io::printf("i:%d, A:%d, a:%d solve(%s)", i, reg[A], a, expand_program);
            String expect = join(expand_program);
            String actual = solve(expand_program);
            io::printfn(" => %s==%s", expect, actual);

            if (actual.trim() == expect.trim()) {
                io::printfn("equals!");
                if (s.rem == 0) break LOOP;
                stack.push({ .rem = s.rem - 1, .est = a });
            }
        }
    }
    
    return a;
}

fn String solve(int[] program) {
    int inst_p;
    DString out;

    while RUNNING: (inst_p < program.len -1)
    {
        int inst = program[inst_p];
        int operand = program[inst_p + 1];
        switch(inst)
        {
            case 0: reg[A] = divide(reg[A], combo_op(operand));
            case 1: reg[B] = xor(reg[B], operand);
            case 2: reg[B] = mod(combo_op(operand), 8);
            case 3: 
                if (reg[A] != 0) { 
                    inst_p = operand; 
                    inst_p-=2; 
                } else { 
                    break RUNNING;
                }
            case 4: reg[B] = xor(reg[B], reg[C]);
            case 5: out.append(string::tformat("%s,", mod(combo_op(operand), 8)));
            case 6: reg[B] = divide(reg[A], combo_op(operand));
            case 7: reg[C] = divide(reg[A], combo_op(operand));
            default: break RUNNING;
        }
        inst_p+=2;

        //io::printfn("i:%d o:%d ip:%d, A:%d B:%d C:%d >>%s", inst, operand, inst_p, reg[A], reg[B], reg[C], out.str_view());
    }
    return out.str_view();
}

fn isz divide(isz numerator, isz power) => numerator/(isz)math::pow(2, (double)power);
fn isz xor(isz a, isz b) => a ^ b;
macro mod(a, b) => (a % b + b) % b;

fn isz combo_op(int op)
{
    switch (op)
    {
        case 0:
        case 1:
        case 2:
        case 3: return op;
        case 4: return reg[A];
        case 5: return reg[B];
        case 6: return reg[C];
        default: unreachable();
    }
}

fn String join(int[] list)
{
    DString sb;
    foreach(i, t : list) {
        sb.append_chars(string::tformat("%d", t));
        sb.append_chars(",");
    }
    return sb.str_view();
}
