import std::io;
import std::time;
import std::collections;
import libc;
import std::sort;

//const int ORDER_LEN = 21;
const int ORDER_LEN = 1176;
//const String FILE = "test.txt";
const String FILE = "input.txt";

fn long! part1()
{
	File f = file::open(FILE, "rb")!;
	defer (void)f.close();
	int total = 0;
    usz row = 0;

    List(<String>) page_nums;

	while (try line = io::treadline(&f))
	{
        String[] rule = line.tsplit("|");
        if (rule.len == 2)
        {
            rules[row][0] = rule[0].to_int()!;
            rules[row][1] = rule[1].to_int()!;
            row++;
        }
        else if (line.len > 1)
        {
            page_nums.push(line);
        }
    }

    foreach(page: page_nums)
    {
        String[] split = page.tsplit(",");
        bool ordered = true;
        for (int i = 0; i< split.len; i++)
        {
            int key = split[i].to_int()!;
            for (int j = i + 1; j< split.len; j++)
            {
                int value = split[j].to_int()!;
                if (!rules.has(key, value))
                {
                    ordered = false;
                }
            }
        }
        if (ordered)
        {
            int middle = split[(split.len-1) /2].to_int()!;
            total += middle;
        }
    }
        
    return total;
}

fn bool int[2][ORDER_LEN].has(self, int key, int value)
{
    for(int dy = 0; dy < ORDER_LEN; dy++)
    {
        if (key == self[dy][0] && value == self[dy][1])
        {
            return true;
        }
    }
    return false;
}

int[2][ORDER_LEN] rules;

fn long! part2()
{
	File f = file::open(FILE, "rb")!;
	defer (void)f.close();
	int total = 0;
    usz row = 0;

    List(<String>) page_nums;

	while (try line = io::treadline(&f))
	{
        String[] rule = line.tsplit("|");
        if (rule.len == 2)
        {
            rules[row][0] = rule[0].to_int()!;
            rules[row][1] = rule[1].to_int()!;
            row++;
        }
        else if (line.len > 1)
        {
            page_nums.push(line);
        }
    }

    List(<String>) unordered;
    foreach(page: page_nums)
    {
        String[] split = page.tsplit(",");
        bool ordered = true;
        for (int i = 0; i< split.len; i++)
        {
            int key = split[i].to_int()!;
            for (int j = i + 1; j< split.len; j++)
            {
                int value = split[j].to_int()!;
                if (!rules.has(key, value))
                {
                    ordered = false;
                } 
            }
        }
        if (!ordered)
        {
            unordered.push(page);
        }
    }
        
    foreach(page: unordered)
    {
        String[] split = page.tsplit(",");
        List(<int>) sorted;
        foreach(i, s: split)
        {
            sorted.push(s.to_int()!);
        }
        io::printfn("unsorted: %s", sorted);
        sort::quicksort(sorted, &cmp);
        io::printfn("sorted:   %s", sorted);
        io::printn();
        int middle = sorted[(sorted.len()) / 2];
        total += middle;
    }

    return total;
}

fn int cmp(void* a, void* b)
{
    int l = *(int*)a;
    int r = *(int*)b;
    if (rules.has(l, r)) return 1;
    if (rules.has(r, l)) return -1;
    return 0;
}

fn bool int[2][ORDER_LEN].has_ref(&self, int* key, int* value)
{
    for(int dy = 0; dy < ORDER_LEN; dy++)
    {
        if (key == &self[dy][0] && value == &self[dy][1])
        {
            return true;
        }
    }
    return false;
}

fn void main()
{
    Clock c = clock::now();
    //io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}

