import std::io, std::time, std::collections, std::math;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!, c.mark());
    };
}

const String FILE = "input";

def Mem = HashMap(<String, bool>); 
Mem mem;

fn int! part1()
{
    String input = (String) file::load_temp(FILE)!;
    String[] part = input.trim().tsplit("\n\n");
    String[] towels = part[0].trim().tsplit(", ");
    String[] pattern = part[1].trim().tsplit("\n");
    int sum;

    foreach(i, p: pattern) {
        if(p.match(towels)) {
            sum++;
        }
    }

    return sum;
}

fn bool String.match(self, String[] towels)
{
    if (mem.has_key(self)) return false;
    foreach(towel: towels)
    {
        if (towel.len == self.len && self == towel)
        {
            return true;
        }
        if (towel.len < self.len && (String) self[..towel.len-1] == towel)
        {
            String substr = (String) self[towel.len..];
            if (substr.match(towels))
            {
                return true;
            }
        }
    }

    mem[self] = true;
    return false;
}

