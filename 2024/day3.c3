import std::io;
import std::time;
import std::ascii;

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", solve(true)!!, c.mark());
        io::printfn("- Part2: %d - %s", solve(false)!!, c.mark());
    };
}

enum State { FUN, LEFT, RIGHT }

fn long! solve(bool part1)
{
    File input = file::open("input.txt", "r")!;
    long result = 0;
    State state = State.FUN;
    bool mul = true;
    DString tokens;
    tokens.temp_init();
    long[2] nums;

    while (try ch = input.read_byte()) {
        switch (state) {
            case State.LEFT:
            case State.RIGHT:
                char ending = state == State.LEFT ? ',' : ')';
                if (ch == ending) {
                    if (tokens.len() > 3 || tokens.len() < 1) {
                        tokens.clear();
                        state = State.FUN;
                        nextcase state;
                    }

                    short idx = state == State.LEFT ? 0 : 1;
                    nums[idx] = tokens.str_view().to_long()!;
                    state = state == State.LEFT ? State.RIGHT : State.FUN;
                    tokens.clear();

                    if (state == State.FUN) {
                        long mult = nums[0] * nums[1];
                        if (part1) result += mult;
                        if (mul && !part1) result += mult;
                        nextcase state;
                    }
                } else if (!ascii::is_digit(ch)) {
                    tokens.clear();
                    state = State.FUN;
                    nextcase state;
                } else {
                    tokens.append(ch);
                }
            case State.FUN:
                tokens.append(ch);
                if (ch == '(') {
                    if (tokens.str_view().ends_with("mul(")) {
                        state = State.LEFT;
                        tokens.clear();
                    } else if (try char peek = input.read_byte()) {
                        if (peek == ')') {
                            if (tokens.str_view().ends_with("don't(")) {
                                mul = false;
                            } else if (tokens.str_view().ends_with("do(")) {
                                mul = true;
                            }
                            tokens.clear();
                        } else {
                            tokens.clear();
                            tokens.append(peek);
                        }
                    }
                }
        }
    }
    return result;
}

