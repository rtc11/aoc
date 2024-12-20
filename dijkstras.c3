module dijkstras(<Type>);

import std::collections;

def Tree = HashMap(<Type, Type>);

struct Graph {
    List(<Type>) verts;
    HashMap(<Type, List(<Type>)>) edges;
    HashMap(<Type[2], int>) weights;
}

fn Tree tree(Graph g, Type start)
{
    List(<Type>) traversed = *traversed.temp_init();
    HashMap(<Type, int>) delta;
    Tree prev = *prev.temp_init();

    foreach(vert: g.verts) {
        delta[vert] = int.max;
        prev[vert] = MapResult.NOT_FOUND?;
    }
    delta[start]! = 0;

    while (!traversed.cmp(&graph.verts)) {
        Type vert;
        int min = int.max;
        delta.@each(; Type t, int i) {
            if (!traversed.contains(t)) {
                if (i < min) {
                    vert = t;
                }
            }
        };

        if(g.edges.has_key(vert)) {
            List(<Type>) edges = g.edges[vert]!;
            foreach(edge: edges) {
                if (!traversed.contains(edge)) {
                   int newPath = delta[vert] + g.weights[Type[2]{vert, edge}];
                   if (newPath < delta[edge]) {
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

fn bool List(<Type>).cmp(&self, List(<Type>)* other)
{
    foreach (t: self) {
        if (!other.contains(&t)) return false;
    }
    return true;
}

fn List(<Type>) search(HashMap(<Type, Type>) tree, Type start, Type end)
{
    // change to try
    if (!tree[end]!) {
        List(<Type>) list = *list.temp_init(); 
        list.push(end);
        return list;
    } 

    List(<Type>) next = search(tree, start, tree[end]!)!;
    next.push(end);
    return next; 
}

