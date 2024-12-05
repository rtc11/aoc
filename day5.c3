import std::io;
import std::time;
import std::collections;
import std::sort;

//const int ORDER_LEN = 21;
//const String FILE = "test.txt";
const int ORDER_LEN = 1176;
const String FILE = "input.txt";

int[2][ORDER_LEN] rules;

fn List(<String>)! page_updates()
{
	File f = file::open(FILE, "r")!;
	defer (void)f.close();
    usz row = 0;
    List(<String>) page_updates;
	while (try line = io::treadline(&f)) {
        String[] rule = line.tsplit("|");
        if (rule.len == 2) {
            rules[row][0] = rule[0].to_int()!;
            rules[row][1] = rule[1].to_int()!;
            row++;
        } else if (line.len > 1) {
            page_updates.push(line);
        }
    }
    return page_updates;
}

fn int! List(<String>).count_mid(self, List(<String>)* unordered)
{
    int total = 0;
    foreach(page: self) {
        String[] split = page.tsplit(",");
        bool ordered = true;
        for (int i = 0; i< split.len; i++) {
            int key = split[i].to_int()!;
            for (int j = i + 1; j< split.len; j++) {
                int value = split[j].to_int()!;
                if (!rules.has(key, value)) {
                    ordered = false;
                }
            }
        }
        if (ordered) {
            int middle = split[(split.len-1) /2].to_int()!;
            total += middle;
        } else {
            unordered.push(page);
        }
    }

    return total;
}

fn bool int[2][ORDER_LEN].has(self, int key, int value)
{
    for(int dy = 0; dy < ORDER_LEN; dy++) {
        if (key == self[dy][0] && value == self[dy][1]) {
            return true;
        }
    }
    return false;
}

fn int cmp(void* a, void* b)
{
    int l = *(int*)a;
    int r = *(int*)b;
    if (rules.has(l, r)) return 1;
    if (rules.has(r, l)) return -1;
    return 0;
}

fn long! part1()
{
    int total = 0;
    List(<String>) pages = page_updates()!;
    List(<String>) unordered;
    total += pages.count_mid(&unordered)!;
    return total;
}

fn long! part2()
{
	int total = 0;
    List(<String>) pages = page_updates()!;
    List(<String>) unordered;
    pages.count_mid(&unordered)!;
        
    foreach(page: unordered) {
        String[] split = page.tsplit(",");
        List(<int>) sorted;
        foreach(i, s: split) {
            sorted.push(s.to_int()!);
        }
        sort::quicksort(sorted, &cmp);
        int middle = sorted[(sorted.len()) / 2];
        total += middle;
    }

    return total;
}

fn void main()
{
    Clock c = clock::now();
    io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}

