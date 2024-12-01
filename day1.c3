import std::io;
import std::collections::list;
import std::sort;
import libc;

extern fn int atoi(char*);

struct Lists {
    List(<usz>) left;
    List(<usz>) right;
}

fn void! main()
{
    /*
    char[] buffer = mem::new_array(char, 36);
    defer free(buffer); 
    char[]! test_input = read_file("test.txt", buffer);
    if (catch excuse = test_input  ) {
        io::printfn("Excuse found: %s", excuse);
        return excuse?;
    }

    Lists test_lists = into_lists(test_input, 1, 6);
    test_lists.part2();
    */

    char[] buffer = mem::new_array(char, 15000);
    defer free(buffer); 
    char[]! input = read_file("input.txt", buffer);
    if (catch excuse = input  ) {
        io::printfn("Excuse found: %s", excuse);
        return excuse?;
    }
    Lists lists = into_lists(input, 5, 1000);
    lists.part1();
    lists.part2();
}

fn void Lists.part1(self)
{
    sort::quicksort(self.left);
    sort::quicksort(self.right);
    usz sum = 0;
    for (int i = 0; i<self.left.len(); i++) {
        sum += $$abs(self.right[i] - self.left[i]);;
    }

    io::printfn("part1: %d" , sum);

    self.left.free();
    self.right.free();
}

fn void Lists.part2(self)
{
    usz sum = 0;
    foreach (l : self.left) {
        sum += l * count(self.right, l);
    }
    io::printfn("part2: %d", sum);
}

fn usz count(List(<usz>) list, usz num)
{
    usz sum = 0;
    foreach (l : list) {
        if (l == num) {
            sum++;
        }
    }
    return sum;
}

fn Lists into_lists(
    char[] input,
    ulong num_size = 1,
    ulong row_len = 6
) 
{
    List(<usz>) left;
    List(<usz>) right;
    int idx = 0;
    char* num_buf = malloc(50);
    num_buf[num_size] = '\0';
    bool do_parse_left = true;

    foreach(ch : input) {
        switch ((int) ch) {
            case 0:  // no byte
                break;
            case 32: // space
                if (do_parse_left) {
                    left.push(atoi(num_buf));
                    do_parse_left = false;
                    idx = 0;
                }
            case 10: // new line
                right.push(atoi(num_buf));
                do_parse_left = true;
                idx = 0;
            default:
                num_buf[idx++] = ch;
        }
    }

    return Lists { left, right };
}

fn char[]! read_file(String filename, char[] buffer)
{
    File file = file::open(filename, "r")!;
    defer (void)file.close();
    file.read(buffer)!;
    return buffer;
}

