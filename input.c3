module input(<Type1>);

import std::collections::list;
import std::io;

def Into = fn Type1(String); 

struct Input {
    List(<Type1>) lines;
}

fn Input(<Type1>) from(String filename, Into into)
{
    File f = file::open(filename, "rb")!!; 
    defer (void) f.close();
    List(<Type1>) lines;
    while (try line = io::treadline(&f)) 
    {
        lines.push(into(line));
    }
    return Input { lines };
}

fn usz count(usz num, List(<usz>) list)
{
    usz sum = 0;
    foreach (l : list) {
        if (l == num) {
            sum++;
        }
    }
    return sum;
}

