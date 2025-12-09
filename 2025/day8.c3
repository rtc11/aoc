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

alias Vec3 = long[<3>];
typedef Circuit = inline List{int};

struct Junction { int circuit; Vec3 pos; }
struct Dist { int box1; int box2; long dist; }

// quicksort trait
fn bool Dist.less(&self, Dist d) => self.dist < d.dist;
// quicksort trait
fn bool Circuit.less(&self, Circuit c) => self.len() > c.len();

fn void? part1()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    List{Junction} juncs;
    List{Dist} dists;
    List{Circuit} circuits;

    foreach(row : rows) {
        String[] c = row.tsplit(",", skip_empty:true);
        Vec3 pos = {c[0].to_long()!, c[1].to_long()!, c[2].to_long()!}; 
        foreach (int i, junc : juncs) {
            Vec3 diff = pos - junc.pos;
            dists.push({i, (int) juncs.len(), diff.dot(diff)});
        }
        juncs.push({0, pos});
    }
    quicksort(&dists);
    const MAX = 1000; // 10 or 1000
    foreach (dist: dists.array_view()[:MAX]) {
        int box1 = dist.box1;
        int box2 = dist.box2;
        Junction* j1 = &juncs[box1];
        Junction* j2 = &juncs[box2];
        if (j2.circuit < j1.circuit) {
            @swap(j1, j2);
            @swap(box1, box2);
        }
        switch {
            case !j1.circuit && j2.circuit:
                j1.circuit = j2.circuit; 
                circuits[(usz) j2.circuit - 1].push(box1);
            case !j1.circuit && !j2.circuit:
                Circuit c;
                c.push(box1);
                c.push(box2);
                j1.circuit = j2.circuit = (int)circuits.len() + 1;
                circuits.push(c);
            case j1.circuit == j2.circuit: break;
            default:
                Circuit* c1 = &circuits[(usz)j1.circuit - 1];
                Circuit* c2 = &circuits[(usz)j2.circuit - 1];
                foreach (j : c2.array_view()) {
                    juncs[j].circuit = j1.circuit;
                    c1.push(j);
                }
                c2.clear();
        }
    }
    quicksort(&circuits);
    p1 = circuits[0].len() * circuits[1].len() * circuits[2].len();
}

fn void? part2()
{
    String input = (String) file::load(tmem, "input.txt")!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    List{Junction} juncs;
    List{Dist} dists;
    List{Circuit} circuits;

    foreach(row : rows) {
        String[] c = row.tsplit(",", skip_empty:true);
        Vec3 pos = {c[0].to_long()!, c[1].to_long()!, c[2].to_long()!}; 
        foreach (int i, junction : juncs) {
            Vec3 diff = pos - junction.pos;
            dists.push({i, (int) juncs.len(), diff.dot(diff)});
        }
        juncs.push({0, pos});
    }
    quicksort(&dists);
    foreach (dist: dists) {
        int box1 = dist.box1;
        int box2 = dist.box2;
        Junction* j1 = &juncs[box1];
        Junction* j2 = &juncs[box2];
        if (j2.circuit < j1.circuit) {
            @swap(j1, j2);
            @swap(box1, box2);
        }
        switch {
            case !j1.circuit && j2.circuit:
                Circuit* c2 = &circuits[(usz) j2.circuit - 1];
                j1.circuit = j2.circuit; 
                c2.push(box1);
                if (c2.len() == juncs.len()) p2 = j1.pos.x * j2.pos.x; 
            case !j1.circuit && !j2.circuit:
                Circuit c;
                c.push(box1);
                c.push(box2);
                j1.circuit = j2.circuit = (int)circuits.len() + 1;
                circuits.push(c);
            case j1.circuit == j2.circuit: break;
            default:
                Circuit* c1 = &circuits[(usz)j1.circuit - 1];
                Circuit* c2 = &circuits[(usz)j2.circuit - 1];
                foreach (j : c2.array_view()) {
                    juncs[j].circuit = j1.circuit;
                    c1.push(j);
                }
                if (c1.len() == juncs.len()) p2 = j1.pos.x * j2.pos.x;
                c2.clear();
        }
    }
}

