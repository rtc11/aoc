import std::io;
import std::time::clock;
import std::collections::list;
import std::collections::map;
import std::sort;
import std::math;

long p1;
long p2;

macro mod(num, m) => (num % m + m) % m;
fn int char.to_int(&self) => *self - '0';

fn void main() => @pool() {
    Clock c = clock::now();
    defer io::printfn("part1 %d %s", p1, c.mark());
    defer io::printfn("part2 %d %s", p2, c.mark());

    part1()!!;
    part2()!!;
}

alias Pos = int[<2>];

fn void? part1()
{
    String input = (String) file::load(tmem, "test.txt")!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    List{Pos} corners;

    foreach(row : rows) {
        String[] cols = row.tsplit(",", skip_empty:true);
        corners.push({cols[0].to_int()!, cols[1].to_int()!});
    }

    foreach(a : corners) {
        foreach(b: corners) {
            if (a == b) continue;
            int dx = math::abs(a.x - b.x) + 1;
            int dy = math::abs(a.y - b.y) + 1;
            if ((long) dx * dy > p1) p1 = (long) dx*dy;
        }
    }
}

fn void? part2()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    List{Pos} corners;

    foreach(row : rows) {
        String[] cols = row.tsplit(",", skip_empty:true);
        corners.push({cols[0].to_int()!, cols[1].to_int()!});
    }

    foreach(a : corners) {
        foreach(b: corners) {
            if (a == b) continue;
            int x_min = math::min(a.x, b.x);
            int x_max = math::max(a.x, b.x);
            int y_min = math::min(a.y, b.y);
            int y_max = math::max(a.y, b.y);

            if (is_contained(x_min, x_max, y_min, y_max, corners)) {
                int w = x_max - x_min + 1;
                int h = y_max - y_min + 1;
                long area = (long) w * h;
                if (area > p2) p2 = area;
            }
        }
    }
}

fn bool is_contained(int x_min, int x_max, int y_min, int y_max, List{Pos} corners)
{
    for (usz i; i < corners.len(); i++) {
        Pos pi = corners[i];
        Pos pj = corners[mod(i + 1, corners.len())];
        if (pi.y == pj.y) {
            int seg_y = pi.y;
            if (seg_y > y_min && seg_y < y_max) {
                int seg_x_min = math::min(pi.x, pj.x);
                int seg_x_max = math::max(pi.x, pj.x);
                if (seg_x_min < x_max && seg_x_max > x_min) {
                    return false;
                }
            }
        } else {
            int seg_x = pi.x;
            if (seg_x > x_min && seg_x < x_max) {
                int seg_y_min = math::min(pi.y, pj.y);
                int seg_y_max = math::max(pi.y, pj.y);
                if (seg_y_min < y_max && seg_y_max > y_min) {
                    return false;
                }
            }
        }
    }
    Pos test_p = {x_min + 1, y_min + 1};
    if (x_max - x_min == 0) test_p.x = x_min;
    if (y_max - y_min == 0) test_p.y = y_min;
    return in_polygon(test_p, corners);
}

fn bool in_polygon(Pos p, List{Pos} corners)
{
    int intersections = 0;
    for (usz i; i < corners.len(); i++) {
        Pos pi = corners[i];
        Pos pj = corners[mod(i + 1, corners.len())];
        if (pi.y == pj.y) continue;
        int y_start = math::min(pi.y, pj.y);
        int y_end = math::max(pi.y, pj.y);
        if (p.y >= y_start && p.y < y_end) {
            int segment_x = pi.x;
            if (segment_x > p.x) intersections++;
        }
    }
    return mod(intersections, 2) == 1; 
} 
