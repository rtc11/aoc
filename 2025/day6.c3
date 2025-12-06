import std::io;
import std::time::clock;
import std::collections::list;
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

    part1();
    part2();
}


const COLUMNS = 1000;
const ROWS = 4; // 3 test 4 input

fn void part1()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    String[] rows = input.tsplit("\n");
    ulong[<ROWS>][COLUMNS] problems;
    String[COLUMNS] operators;
    foreach(r, row : rows) {
        if (!row) continue;
        String[] cols = row.tsplit(" ", skip_empty: true);
        foreach(c, col: cols) {
            if (!col) continue;
            switch {
                case col == "*": 
                case col == "+": operators[c] = col;
                default: problems[c][r] = col.to_ulong()!!; 
            }
        }
    }
    for (int c; c < COLUMNS; c++) {
        switch (operators[c]) {
            case "*": p1 += problems[c].product();
            case "+": p1 += problems[c].sum();
        }
    }
}

fn void part2()
{
    String input = (String)file::load_temp("input.txt")!!;
	Table table;
	table.row_len = ROWS;
	table.rows = input.tsplit("\n", skip_empty: true);
	for (usz i = 0; i < table.row_len; i++) {
		table.nums[i].tinit();
        String[] nums = table.rows[i].trim().tsplit(" ", skip_empty: true);
		foreach (num: nums) {
			table.nums[i].push(num.to_long()!!);
		}
	}
	table.ops.tinit();
	foreach (ops: table.rows[table.row_len].trim().tsplit(" ", skip_empty: true)) {
		table.ops.push(ops[0]);
	}
	table.len = table.ops.len();
	List{usz} startpos;
	startpos.tinit();
	startpos.push(0);
	foreach (i, c: table.rows[0]) {
		if (c != ' ') continue;
		bool col = true;
		for (usz j = 0; j < table.row_len; j++) col = col && table.rows[j][i] == ' ';
		if (col) startpos.push(i+1);
	}

	long total, sum;
	usz cols;
	foreach (i, op: table.ops) { cols = 0;
		for (usz j = 0; j < table.row_len; j++) {
			usz ndigits = num_digits(table.nums[j][i]);
			if (ndigits > cols) cols = ndigits;
		}
		OpFn op_fn;
        switch (op) {
            case '+': sum = 0; op_fn = &add;
            case '*': sum = 1; op_fn = &mul;
            default: unreachable();
        }
		usz start = startpos[i];
		for (usz y = start; y < start + cols; y++) {
			long num = 0;
			for (usz x = 0; x < table.row_len; x++) {
				char c = table.rows[x][y];
				if (num > 0 && c == ' ') break;
				num *= 10;
				if (ascii::is_digit(c)) num += (long) c.to_int();
			}
			sum = op_fn(sum, num);
		}
		p2 += sum;
	}
}

alias OpFn = fn long(long acc, long elem);

fn long add(long acc, long elem) => acc + elem;
fn long mul(long acc, long elem) => acc * elem;

struct Table
{
	List{long}[4] nums;
	List{char} ops;
	usz row_len;
	usz len;
	String[] rows;
}

fn usz num_digits(long num) => (long)math::log((double)num, 10) + 1;

