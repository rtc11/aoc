import std::io;
import std::time;

fn bool int[].steady_inc(self, int prev, int skip) 
{
    bool is_inc = self[0] > prev;
    if (self[0] - prev == 0) return false;
    for(int i = 0; i < self.len; i++) {
        if (skip == i) continue;
        int diff = self[i] - prev; 
        if (is_inc != (diff >= 1 && diff <= 3)) return false;
        if (!is_inc != (diff <= -1 && diff >= -3)) return false;
        prev = self[i];
    }
    return true;
}

fn bool int[].is_safe(self, int skip)
{
	if (skip == 0) {
		skip = -1;
		self = self[1..];
	}
	int prev = self[0];
	if (skip == 1) {
		self = self[1..];
		skip = -1;
	}
	self = self[1..];
	skip--;
    return self.steady_inc(prev, skip);
}

fn int! part1()
{
	File f = file::open("input.txt", "rb")!;
	defer (void)f.close();
	int total = 0;
	while (try line = io::treadline(&f))
	{
		String[] split = line.tsplit(" ");
		int[10] buf;
        for (int i = 0; i < split.len; i++) {
			buf[i] = split[i].to_int()!!;
        }
		int[] val = buf[:split.len];
		if (val.is_safe(-1)) {
			total++;
		}
	}
	return total;
}

fn int! part2()
{
	File f = file::open("input.txt", "rb")!;
	defer (void)f.close();
	int total = 0;
	while (try line = io::treadline(&f))
	{
		String[] split = line.tsplit(" ");
		int[10] buf;
        for (int i = 0; i < split.len; i++) {
			buf[i] = split[i].to_int()!!;
        }
		int[] val = buf[:split.len];
		if (val.is_safe(-1)) {
			total++;
			continue;
		}
		for (int i = val.len; i >= 0; i--) {
			if (val.is_safe(i)) {
				total++;
				break;
			}
		}
	}
	return total;
}

fn void main()
{
    Clock c = clock::now();
    io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}
