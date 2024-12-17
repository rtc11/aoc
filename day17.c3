import std::io, std::time, std::collections, std::math;

// adv (opcode 0) == division         A / 2^(combo operand)     => reg A
// bxl (opcode 1) == bitwise XOR      B xor (literal operand)   => reg B 
// bst (opcode 2) == modulo           (combo operand) % 8       => reg B    (keeping the lowest 3 bits)
// jnz (opcode 3) == jump             if (A == 0) {nothing} else {jump (literal operand); (not inc inst_p);}
// bxc (opcode 4) == bitwise XOR      B xor C                   => B (ignore operand)
// out (opcode 5) == modulo           (combo operand) % 8       => io::printf("%s,", res);
// bdv (opcode 6) == division         A / 2^(combo operand)     => reg B
// cdv (opcode 7) == division         A / 2^(combo operand)     => reg C

// after inst = 3-bit operand
// ╭─────── literal operand
// │    ╭── combo operand
// 0 == 0
// 1 == 1
// 2 == 2
// 3 == 3
// 4 == reg A
// 5 == reg B
// 6 == reg C
// 7 ==  7 and will not appear in valid programs.
fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %s - %s", part1(), c.mark());
        //io::printfn("- Part2: %d - %s", part2(), c.mark());
    };
}

const int A = 0;
const int B = 1;
const int C = 2;
isz[3] reg;

fn String part1()
{
    reg[A] = 24847151;
    reg[B] = 0;
    reg[C] = 0;
    int[] program = { 2,4,1,5,7,5,1,6,0,3,4,0,5,5,3,0 };
    return solve(program);
}

fn isz part2()
{
    reg[A] = 24847151;
    reg[B] = 0;
    reg[C] = 0;
    int[] program = { 2,4,1,5,7,5,1,6,0,3,4,0,5,5,3,0 };
    String res = solve(program);
    isz i = 35500000000000; // < 300000000000000 
    while (res != "2,4,1,5,7,5,1,6,0,3,4,0,5,5,3,0,") {
        reg[A] = i++;
        reg[B] = 0;
        reg[C] = 0;
        res = solve(program);
        io::printfn("%s i:%d", res, i);
    }
    return i - 1;
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
                } else {
                    break RUNNING;
                }
                inst_p-=2;
            case 4: reg[B] = xor(reg[B], reg[C]);
            case 5: out.append(string::tformat("%s,", mod(combo_op(operand), 8)));
            case 6: reg[B] = divide(reg[A], combo_op(operand));
            case 7: reg[C] = divide(reg[A], combo_op(operand));
            default: break RUNNING;
        }
        inst_p+=2;
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
