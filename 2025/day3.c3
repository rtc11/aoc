import std::io;
import std::time::clock;
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

fn void part2()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    foreach(bank : input.tsplit("\n")) {
        if (!bank) continue;
        int drops_allowed = (int) bank.len - 12;
        DString res;
        foreach(ch: bank) {
            while (res.len() > 0 && drops_allowed > 0 && ch.to_int() > res[res.len() - 1].to_int()) {
                res.delete(res.len() - 1);
                drops_allowed--;
            }
            res.append(ch);
        }
        if (res.len() > 12) {
            usz trim_count = res.len() - 12;
            for (usz i; i < trim_count; i++) {
                res.delete(res.len() - 1);
            }
        }
        if (res.len() == 12) {
            usz max = (usz) res.str_view().to_long()!!;
            // io::printfn("bank: %s => %d", bank, max);
            p2 +=  max;
        }
    }
}

fn void part1()
{
    String input = (String) file::load(tmem, "test.txt")!!;
    foreach(bank : input.tsplit("\n")) {
        if (!bank) continue;
        usz max;
        for(int i; i< bank.len; i++) {
            for(int j = 1; j< bank.len; j++) {
                if (i >= j) continue;
                usz num = (usz) string::tformat("%d%d", bank[i].to_int(), bank[j].to_int()).to_int128()!!;
                if (num > max) max = num;
            }
        }
        p1 += max;
    }
}

