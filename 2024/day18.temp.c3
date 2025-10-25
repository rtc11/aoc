import std::io, std::time, std::collections, std::sort;

fn void! main()
{
    @pool() {
        Clock c = clock::now();
        io::printfn("- Part1: %d - %s", part1()!, c.mark());
    };
}

const int SIZE = 7;
const Pos EMPTY = { int.max, int.max };

def Pos = int[<2>];
Pos[4] dirs = {{1,0},{0,1},{-1,0},{0,-1}};

macro uint Pos.hash(Pos s) => string::tformat("%s", s).hash();
macro uint Pos[2].hash(Pos[2] s) => string::tformat("%s%s", s[0],s[1]).hash();

macro uint List(<Pos>).hash(List(<Pos>) list)
{
    sort::quicksort(list, &cmp);
    DString s;
    foreach(l: list) s.append(string::tformat("%s%s", l[0],l[1]));
    return s.str_view().hash();
}

fn int cmp(void* a, void* b)
{
    Pos l = *(Pos*)a;
    Pos r = *(Pos*)b;
    return (l.x - l.y) - (r.x - r.y);
}

fn long! part1()
{
    String input = (String) file::load_temp("example1")!;
    List(<Pos>) walls = *walls.temp_init();
    HashMap(<Pos[2], int>) weights;

    foreach (line : input.trim().tsplit("\n")) {
        String[] pos = line.trim().tsplit(",");
        int x = pos[0].to_int()!;
        int y = pos[1].to_int()!;
        walls.push({x, y});
    }

    for(int y; y<SIZE; y++) {
        for(int x; x<SIZE; x++) {
            Pos pos = {x,y};

            foreach(dir: dirs) {
                Pos next = pos + dir;
                if (next.x >= 0 && next.x < SIZE && next.y >= 0 && next.y < SIZE) {
                    if (!walls.contains(next)) {
                        weights[Pos[2]{pos, next}] = 1;
                    }
                }
            }
        }
    }

    Pos start = {0, 0};
    Pos end = {SIZE-1, SIZE-1};

    Vertices verts = *verts.temp_init();
    weights.@each(; Pos[2] p, int w){
        // todo: necessary to dedup?
        verts.push(p[0]);
        verts.push(p[1]);
    };

    Edges edges;
    weights.@each(; Pos[2] p, int w){
        Pos from = p[0];
        Pos to = p[1];
        edges.@get_or_set(from, *List(<Pos>){}.temp_init());
        if (!edges[from]!.contains(to)) edges[from]!.push(to);
    };

    Graph graph = Graph { 
        .verts = verts, 
        .edges = edges,
        .weights = weights, 
    };
    Tree paths = tree(graph, start)!;
    List(<Pos>) shortest = search(paths, start, end)!;
    return shortest.len();
    //return 0;
}

def Tree = HashMap(<Pos, Pos>);
def Vertices = List(<Pos>);
def Edges = HashMap(<Pos, List(<Pos>)>);
def Weights = HashMap(<Pos[2], int>);
struct Graph {
    Vertices verts;
    Edges edges;
    Weights weights;
}

fn Tree! tree(Graph g, Pos start)
{
    Vertices traversed = *traversed.temp_init();
    HashMap(<Pos, int>) delta;
    Tree prev;

    foreach(vert: g.verts) {
        delta[vert] = int.max;
        prev[vert] = EMPTY;
    }
    delta[start] = 0;

    while (traversed.hash() != g.verts.hash()) {
        io::printfn("%d != %d", traversed.hash(), g.verts.hash());
        Pos vert;
        int min = int.max;
        delta.@each(; Pos t, int i) {
            if (!traversed.contains(t)) {
                if (i < min) {
                    vert = t;
                }
            }
        };

        if(g.edges.has_key(vert)) {
            List(<Pos>) edges = g.edges[vert]!;
            foreach(edge: edges) {
                if (!traversed.contains(edge)) {
                   int newPath = delta[vert]! + g.weights[Pos[2]{vert, edge}]!;
                   io::printfn("newPath: delta[vert]:%s + weights[vert,edge]:%s = %s", delta[vert]!, g.weights[Pos[2]{vert, edge}]!, newPath);
                   if (newPath < delta[edge]!) {
                       delta[edge] = newPath;
                       prev[edge] = vert;
                   }
                }
            }
        }
        traversed.push(vert);
    }
    return prev;
}

fn Vertices! search(Tree tree, Pos start, Pos end)
{
    if (tree.has_key(end) && tree[end]! == EMPTY) {
        Vertices list = *list.temp_init(); 
        list.push(end);
        return list;
    } 

    Vertices next = search(tree, start, tree[end]!)!;
    next.push(end);
    return next; 
}

