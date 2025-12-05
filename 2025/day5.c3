import std::io;
import std::time::clock;
import std::collections::list;
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

struct Range
{
    int128 from;
    int128 to;
}

fn void part1()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    String[] rows = input.tsplit("\n");
    List{Range} ranges;
    foreach(i, row : rows) {
        if (!row) continue;
        String[] range = row.tsplit("-");
        if (range.len == 2) {
            ranges.push({range[0].to_int128()!!, range[1].to_int128()!!});
        } else if (range.len == 1){
            if (catch row.to_int128()) {
                io::printfn("%s too large number", row);
            }
            int128 id = row.to_int128()!!;
            bool fresh;
            foreach(r: ranges) {
                if (r.from <= id && r.to >= id) {
                    fresh = true;
                    // io::printfn("fresh: %d in range %d-%d", id, r.from, r.to);
                }
            }
            if (fresh) p1++;
        }
    }
}

fn int128 List{Range}.union_count(&self)
{
    std::sort::quicksort(self, fn int (Range a, Range b) {
        if (a.from < b.from) return -1;
        if (a.from > b.from) return 1;
        return 0;
    });
    List{Range} merged;
    Range current = self.first()!!;
    foreach(i, range: self) {
        if (i==0) continue;
        if (range.from <= current.to + 1) {
            if (range.to > current.to) {
                current.to = range.to;
            }
        } else {
            merged.push(current);
            current = range;
        }
    }
    merged.push(current);
    int128 total;
    foreach(range : merged) {
        total += range.to - range.from + 1;
    }
    return total;
}

fn void part2()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    String[] rows = input.tsplit("\n");
    List{Range} ranges;
    foreach(row : rows) {
        if (!row) continue;
        String[] range = row.tsplit("-");
        if (range.len == 2) {
            int128 from = range[0].to_int128()!!; 
            int128 to = range[1].to_int128()!!;
            ranges.push({from, to});
        }
    }
    p2 = (usz) ranges.union_count();
}

