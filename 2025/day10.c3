import std::io;
import std::time::clock;
import std::collections::list;
import std::collections::map;
import std::sort;
import std::math;

macro mod(num, m) => (num % m + m) % m;
fn int char.to_int(&self) => *self - '0';

alias Wire = List{int};
alias Matrix = List{List{int}};

struct Machine { 
    List{bool} goal;
    List{bool} lights;
    List{Wire} wires; 
    List{int} joltages; 
}

struct MatrixAnalysis
{
    List{bool} is_pivot;
    List{int} basic_var_row;
    int free_vars_count;
    usz nbuttons;
}

long p1;
long p2;

fn void main() => @pool() {
    Clock c = clock::now();
    defer io::printfn("part1 %d %s", p1, c.mark());
    defer io::printfn("part2 %d %s", p2, c.mark());

    part1()!!;
    part2()!!;
}

fn void? part1()
{
    String input = (String) file::load(tmem, "test.txt")!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    List{Machine} machines;

    foreach(row : rows) {
        Machine m;
        String[] parts = row.tsplit(" ");
        foreach(part : parts) {
            switch {
                case part[0] == '[':
                    foreach(light : part[1..^2]) {
                        m.goal.push(light == '#');
                        m.lights.push(false);
                    }
                case part[0] == '(':
                    List{int} wires;
                    foreach(wire : part[1..^2].tsplit(",")) {
                        wires.push(wire.to_int()!);
                    }
                    m.wires.push(wires);
                case part[0] == '{':
                    String[] joltages = part[1..^2].tsplit(",");
                    foreach(jolt : joltages) {
                        m.joltages.push(jolt.to_int()!);
                    }
            }
        }
        machines.push(m);
    }

    foreach(m: machines) {
        p1 += solve_machine(m);
    }
}

fn MatrixAnalysis analyze(Matrix matrix)
{
    usz n = matrix.len();
    usz m = matrix[0].len() - 1;
    MatrixAnalysis analysis;
    analysis.nbuttons = m;
    for(int i; i<m; i++) analysis.is_pivot.push(false);
    for(int i; i<m; i++) analysis.basic_var_row.push(-1);
    for (int i; i<n; i++) {
        bool all_zeros = true;
        for (int j; j<m; j++) {
            if (matrix[i][j] == 1) {
                all_zeros = false;
                if (!analysis.is_pivot[j]) {
                    analysis.is_pivot[j] = true;
                    analysis.basic_var_row[j] = i;
                }
                break;
            }
        }
    }
    for (int j; j<m; j++) {
        if (!analysis.is_pivot[j]) analysis.free_vars_count++;
    }
    return analysis;
}

fn usz find_min_weight(Matrix matrix, MatrixAnalysis analysis)
{
    usz min_presses = analysis.nbuttons + 1;
    ulong max_assignments = (ulong) 1 << analysis.free_vars_count;
    for (ulong free_assignment; free_assignment < max_assignments; free_assignment++) {
        List{int} x;
        for(int i; i<analysis.nbuttons; i++) x.push(0);
        int free_var_index;
        int current_presses;
        for (int j; j<analysis.nbuttons; j++) {
            if (!analysis.is_pivot[j]) {
                int value = (int) ((free_assignment >> free_var_index) & 1);
                x[j] = value;
                current_presses += value;
                free_var_index++;
            }
        }
        for (int j; j<analysis.nbuttons; j++) {
            if (analysis.is_pivot[j]) {
                int i = analysis.basic_var_row[j];
                if (i == -1) continue;
                int required_state = matrix[i][analysis.nbuttons];
                int sum_of_others;
                for (int k; k<analysis.nbuttons; k++) {
                    if (k != j) sum_of_others = sum_of_others ^  (matrix[i][k] * x[k]);
                }
                int value = required_state ^ sum_of_others;
                x[j] = value;
                current_presses += value;
            }
        }
        if (current_presses < min_presses) min_presses = current_presses;
    }
    return min_presses;
}

fn Matrix create_matrix(Machine machine) {
    usz n = machine.goal.len();
    usz m = machine.wires.len();
    Matrix matrix;
    for (int i; i < n; i++) {
        List{int} row;
        for (int j; j < m; j++) {
            bool toggles;
            foreach(light : machine.wires[j]) {
                if (light == i) {
                    toggles = true;
                    break;
                }
            }
            row.push((int) toggles);
        }
        row.push((int) machine.goal[i]);
        matrix.push(row);
    }
    return matrix;
}

fn usz solve_machine(Machine machine)
{
    usz n = machine.goal.len();
    usz m = machine.wires.len();
    Matrix matrix = create_matrix(machine);
    gaussian_elimination(matrix);
    MatrixAnalysis analysis = analyze(matrix);
    return find_min_weight(matrix, analysis);
    
}

fn void gaussian_elimination(Matrix matrix)
{
    usz nrows = matrix.len();
    usz ncols = matrix[0].len();
    int pivot = 0;
    for (int col; col < ncols - 1; col++) {
        if (pivot >= nrows) break;
        int i = pivot;
        while (i < nrows && matrix[i][col] == 0) i++;
        if (i >= nrows) continue;
        if (i != pivot) {
            List{int} temp = matrix[pivot];
            matrix[pivot] = matrix[i];
            matrix[i] = temp;
        }
        for (int j = 0; j < nrows; j++) {
            if (j != pivot && matrix[j][col] == 1) {
                for (int k = col; k < ncols; k++) {
                    matrix[j][k] = matrix[j][k] ^ matrix[pivot][k];
                }
            }
        }
        pivot++;
    }
}

fn void? part2()
{
    String input = (String) file::load(tmem, "test.txt")!!;
    String[] rows = input.tsplit("\n", skip_empty:true);
    List{Machine} machines;

    foreach(row : rows) {
        Machine m;
        String[] parts = row.tsplit(" ");
        foreach(part : parts) {
            switch {
                case part[0] == '[':
                    foreach(light : part[1..^2]) {
                        m.goal.push(light == '#');
                        m.lights.push(false);
                    }
                case part[0] == '(':
                    List{int} wires;
                    foreach(wire : part[1..^2].tsplit(",")) {
                        wires.push(wire.to_int()!);
                    }
                    m.wires.push(wires);
                case part[0] == '{':
                    String[] joltages = part[1..^2].tsplit(",");
                    foreach(jolt : joltages) {
                        m.joltages.push(jolt.to_int()!);
                    }
            }
        }
        machines.push(m);
    }

    foreach(m: machines) {
        p2 += 0;
    }
}

