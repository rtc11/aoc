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
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        //io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

const int A = 0;
const int B = 1;
const int C = 2;
int[3] reg;

fn long! part1()
{
    reg[A] = 24847151;
    reg[B] = 0;
    reg[C] = 0;
    int[] program = { 2,4,1,5,7,5,1,6,0,3,4,0,5,5,3,0 };
    int inst_p;
    DString out;
    
    while RUNNING: (inst_p < program.len -1)
    //for RUNNING: (int i; i < 30; i++) 
    {
        //io::printf("%d,", i);
        int inst = program[inst_p];
        int operand = program[inst_p + 1];
        switch(inst)
        {
            case 0: 
                reg[A] = divide(reg[A], combo_op(operand));
                inst_p+=2;
            case 1:
                reg[B] = xor(reg[B], operand);
                inst_p+=2;
            case 2:
                reg[B] = mod(combo_op(operand), 8);
                inst_p+=2;
            case 3:
                if (reg[A] != 0) {
                    inst_p = operand;
                } else {
                    io::printfn("halt because reg == 0");
                    break RUNNING;
                }
            case 4:
                reg[B] = xor(reg[B], reg[C]);
                inst_p+=2;
            case 5:
                int modulo = mod(combo_op(operand), 8);
                out.append(string::tformat("%s,", modulo));
                inst_p+=2;
            case 6:
                reg[B] = divide(reg[A], combo_op(operand));
                inst_p+=2;
            case 7:
                reg[C] = divide(reg[A], combo_op(operand));
                inst_p+=2;
            default: 
                io::printfn("halt inst:%d, op:%d", inst, operand);
                break RUNNING;
        }
    }
    io::printn();
    io::printfn("A:%d, B:%d, C:%d, out:%s", reg[A], reg[B], reg[C], out.str_view());
    return 0;
}

fn int divide(int numerator, int power) => numerator/(int)math::pow(2, (double)power);
fn int xor(int a, int b) => a ^ b;
macro mod(a, b) => (a % b + b) % b;

fn int combo_op(int op)
{
    switch (op)
    {
        case 4: 
            return reg[A];
        case 5:
            return reg[B];
        case 6:
            return reg[C];
        default:
            return op;
    }
}
