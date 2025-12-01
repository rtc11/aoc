import std::io;
import std::time::clock;

const N = 100;

int dial = 50;
int p1;
int p2;

macro mod(num, m) => (num % m + m) % m;

fn void main()
{
    Clock c = clock::now();
    defer log::info("part1 %d %s", p1, c.mark());
    defer log::info("part2 %d %s", p2, c.mark());

    String input = (String) file::load(tmem, "input.txt")!!;
    String[] lines = input.tsplit("\n");
    foreach(line: lines) {
        if (!line) continue;
        int turn = line[1..^1].to_int()!!;
        switch(line[0]) {
            case 'L': turn_left(turn);
            case 'R': turn_right(turn);
        }
        if (dial == 0) p1++;
        // io::printfn("%s points at %d", line, dial);
    }

}

fn void turn_right(int turn)
{
    for (int i = 0; i < turn; i++) {
        dial = mod(dial + 1, N);
        if (dial == 0)  p2++;
    }
}

fn void turn_left(int turn)
{
    for (int i = 0; i < turn; i++) {
        dial = mod(dial - 1, N);
        if (dial == 0) p2++; 
    }
}

