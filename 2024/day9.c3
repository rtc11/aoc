import std::io;
import std::time;
import std::collections;
import std::math;

const String FILE = "input.txt";

fn void main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!!, c.mark());
        io::printfn("- Part2: %d - %s", part2()!!, c.mark());
    };
}

fn long! part1()
{
	String input = (String)file::load_temp(FILE)!;
	input = input.trim();
	long[] map = calculate(input);
	block_swap(map);
	return checksum(map);
}

fn long! part2()
{
	String input = (String)file::load_temp(FILE)!;
	input = input.trim();
	long[] map = calculate(input);
	file_swap(map);
	return checksum(map);
}
fn long[] calculate(String input)
{
	List(<long>) line;
	line.temp_init(256);
	long w;
	foreach (i, c : input) {
		switch (i % 2) {
			case 0: w = (long)i/2;
			case 1: w = -1;
		}
		usz n = (usz)(c - '0');
		for (usz j = 0; j < n; j++) line.push(w);
	}
	return line.array_view();
}

fn void block_swap(long[] map)
{
	int l, r, n;
	n = map.len;
	r = n-1;
	while (l < r) {
		while (map[l] != -1 && l < n) l++;
		while (map[r] == -1 && r >= 0) r--;
		if (l >= r) break;
		@swap(map[l], map[r]);
	}
}
fn void file_swap(long[] map)
{
	int l, r, n;
	int k, j;
	n = map.len;
	r = n-1;
	while (r >= 0) {
		while (map[r] == -1 && r >= 0) r--;
		k = 0;
		while (r-k >= 0 && map[r-k] == map[r]) k++;
		l = 0;
		while FREE: (l < r-k) {
			j = 0;
			while (j < k && map[l+j] == -1) j++;
			if (j == k) {
				for (j = 0; j < k; j++) @swap(map[l+j], map[r-j]);
				break FREE;
			}
			l++;
		}
		r = r - k;
	}
}

fn long checksum(long[] map)
{
	long total = 0;
	foreach (i, m : map) {
		if (m >= 0) total += (long)i * m;
	}
	return total;
}

