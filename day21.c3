import std::io, std::time, std::collections, std::math;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        long test = solve("test")!;
        io::printfn("- Test1: %d - %s", test, c.mark());
        assert(test == 126384, "test example failed ");
        long part1 = solve("input")!;
        io::printfn("- Part1: %d - %s", part1, c.mark());
        assert(part1 < 239088, "part1 too high");
    };
}

def Pos = int[<2>];
def Map = HashMap(<char, Pos>);
def Arm = fn char[]!(Map, Pos, char);
Map numpad;
Map controller;

fn List(<String>)! List(<String>).move(&self, Map pad)
{
    Pos pos = pad['A']!;
    List(<String>) pad_moves;
    foreach(moves: self) {
        DString res;
        foreach(m : moves) {
            res.append((String) to_moves(pad, pos, m)!);
            pos = pad[m]!;
        }
        // io::printfn("%s: %s", moves, res);
        pad_moves.push(res.str_view());
    }
    return pad_moves;
}

fn long! solve(String file)
{
    String input = (String) file::load_temp(file)!;
    List(<String>) codes;
    foreach(m: input.trim().tsplit("\n")) codes.push(m);

    init_num_pad();
    init_dir_pad();

    List(<String>) numpad_moves = codes.move(numpad)!;
    List(<String>) r1_moves = numpad_moves.move(controller)!;
    List(<String>) r2_moves = r1_moves.move(controller)!;
    int sum;
    foreach(i, m: r2_moves) {
        int num = codes[i][0..^2].to_int()!; // len-2 
        sum += m.len * num;
        io::printfn("%d * %d", m.len, num);
    }
    return sum;
}

fn char[]! to_moves(Map pad, Pos pos, char button)
{
    Pos moves = pad[button]! - pos;
    List(<char>) chs = *chs.temp_init();
    int size;
    // TODO: shortest path
    if ((pad.len() == 11 && pos.y == 3) || (pad.len() == 5 && pos.y == 0)) {
        switch {
            case moves.y < 0: for(int i = 0; i < math::abs(moves.y); i++) chs.push('^');
            case moves.y > 0: for(int i = 0; i < math::abs(moves.y); i++) chs.push('v');
        }
        switch  {
            case moves.x > 0: for(int i = 0; i < math::abs(moves.x); i++) chs.push('>');
            case moves.x < 0: for(int i = 0; i < math::abs(moves.x); i++) chs.push('<');
        }
    } else {
        switch  {
            case moves.x > 0: for(int i = 0; i < math::abs(moves.x); i++) chs.push('>');
            case moves.x < 0: for(int i = 0; i < math::abs(moves.x); i++) chs.push('<');
        }
        switch {
            case moves.y < 0: for(int i = 0; i < math::abs(moves.y); i++) chs.push('^');
            case moves.y > 0: for(int i = 0; i < math::abs(moves.y); i++) chs.push('v');
        }
    }
    chs.push('A');
    return chs.to_tarray();
}

// +---+---+---+
// | 7 | 8 | 9 |
// +---+---+---+
// | 4 | 5 | 6 |
// +---+---+---+
// | 1 | 2 | 3 |
// +---+---+---+
//     | 0 | A |
//     +---+---+
fn void init_num_pad() 
{
    numpad['7'] = Pos{0, 0};
    numpad['8'] = Pos{1, 0};
    numpad['9'] = Pos{2, 0};
    numpad['4'] = Pos{0, 1};
    numpad['5'] = Pos{1, 1};
    numpad['6'] = Pos{2, 1};
    numpad['1'] = Pos{0, 2};
    numpad['2'] = Pos{1, 2};
    numpad['3'] = Pos{2, 2};
    numpad['0'] = Pos{1, 3};
    numpad['A'] = Pos{2, 3};
}

//     +---+---+
//     | ^ | A |
// +---+---+---+
// | < | v | > |
// +---+---+---+
fn void init_dir_pad() 
{
    controller['^'] = Pos{1, 0};
    controller['A'] = Pos{2, 0};
    controller['<'] = Pos{0, 1};
    controller['v'] = Pos{1, 1};
    controller['>'] = Pos{2, 1};
}
