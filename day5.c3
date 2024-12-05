import std::io;
import std::time;
import std::collections;

//const int ORDER_LEN = 21;
const int ORDER_LEN = 1176;

fn long! part1()
{
	File f = file::open("input.txt", "rb")!;
	defer (void)f.close();
	int total = 0;
    int[2][ORDER_LEN] order;
    usz row = 0;

    List(<String>) page_nums;

	while (try line = io::treadline(&f))
	{
        String[] rule = line.tsplit("|");
        if (rule.len == 2)
        {
            order[row][0] = rule[0].to_int()!;
            order[row][1] = rule[1].to_int()!;
            row++;
        }
        else if (line.len > 1)
        {
            page_nums.push(line);
        }
    }

    // for(int y = 0; y<ORDER_LEN; y++) { io::printfn("%s", order[y]); }

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
                //io::printf("%s|%s, ", key, value);
                if (!order.has(key, value))
                {
                    ordered = false;
                }
            }
            //io::printn();
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

fn long! part2()
{
    String input = (String) file::load_temp("test.txt")!;
    usz count = 0;
    return count;
}

fn void main()
{
    Clock c = clock::now();
    io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}

