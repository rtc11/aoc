import std::io;
import std::time::clock;
import std::collections::list;
import std::collections::set;
import std::collections::map;
import std::sort;
import std::math;

usz p1;
usz p2;

macro mod(num, m) => (num % m + m) % m;
fn int char.to_int(&self) => *self - '0';

fn void main()
{
    Clock c = clock::now();
    defer io::printfn("part1 %d %s", p1, c.mark());
    defer io::printfn("part2 %d %s", p2, c.mark());

    part1()!!;
    part2()!!;
}

fn void? part1()
{
    File f = file::open("input.txt", "rb")!;
    defer (void)f.close();
    String last = io::treadline(&f)!;
    while (try line = io::treadline(&f)) {
        foreach (c, ch: last) {
            if (ch != 'S') continue;
            switch (line[c]) {
                case '.': 
                    line[c] = ch;
                case '^':
                    p1++;
                    line[c - 1] = 'S';
                    line[c + 1] = 'S';
            }
        }
        last = line;
    }
}

fn void? part2()
{
	File f = file::open("input.txt", "rb")!;
	defer (void)f.close();
	String last = io::treadline(&f)!;
	long[142] timelines;
	foreach (i, c : last) timelines[i] = c == 'S' ? 1 : 0;
	while (try line = io::treadline(&f)) {
		long[142] new;
		foreach (i, timeline : timelines) {
			if (!timeline) continue;
			switch (line[i]) {
				case '.':
					new[i] += timeline;
				case '^':
					new[i - 1] += timeline;
					new[i + 1] += timeline;
			}
		}
		timelines = new;
	}
	foreach (timeline : timelines) p2 += timeline;
}

