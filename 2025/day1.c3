import std::io;
import std::time::clock;

const N = 100;

int dial = 50;
int resets;

macro mod(num, m) => (num % m + m) % m;

fn void main()
{
    Clock c = clock::now();
    defer log::info("part1 %d %s", resets, c.mark());

    String input = (String) file::load(tmem, "input.txt")!!;
    String[] lines = input.tsplit("\n");
    foreach(line: lines) {
        if (!line) continue;
        int turn = line[1..^1].to_int()!!;
        switch(line[0]) {
            case 'L': turn_left(turn);
            case 'R': turn_right(turn);
        }
        if (dial == 0) resets++;
        io::printfn("%s points at %d", line, dial);
    }
}

fn void turn_right(int turn)
{
    dial = mod(dial + turn, N);
}

fn void turn_left(int turn)
{
    dial = mod(dial - turn, N);
}

