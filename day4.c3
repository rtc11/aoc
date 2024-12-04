import std::io;
import std::time;

const int X_LEN = 140; // 140
const int Y_LEN = 140; // 140

fn long! part1()
{
    String input = (String) file::load_temp("input.txt")!;
    char[X_LEN][Y_LEN] matrix;
    usz dy = 0;

    foreach (i, ch: input) {
        if (ch == '\n') { dy++; } 
        else { matrix[i % (X_LEN+1)][dy] = ch; }
    }

    DString ds;
    usz count = 0;
    for (int y = 0; y < Y_LEN; y++) {
        for (int x = 0; x < X_LEN; x++) {
            if (x+3 < X_LEN) {
                ds.append_char(matrix[x][y]);
                ds.append_char(matrix[x+1][y]);
                ds.append_char(matrix[x+2][y]);
                ds.append_char(matrix[x+3][y]);
                if(ds.str_view() == "XMAS" || ds.str_view() == "SAMX") {
                    count++;
                }
                ds.clear();
            }
            if (y+3 < Y_LEN) {
                ds.append_char(matrix[x][y]);
                ds.append_char(matrix[x][y+1]);
                ds.append_char(matrix[x][y+2]);
                ds.append_char(matrix[x][y+3]);
                if(ds.str_view() == "XMAS" || ds.str_view() == "SAMX") {
                    count++;
                }
                ds.clear();
            }
            if (y+3 <Y_LEN && x+3 < X_LEN) {
                ds.append_char(matrix[x][y]);
                ds.append_char(matrix[x+1][y+1]);
                ds.append_char(matrix[x+2][y+2]);
                ds.append_char(matrix[x+3][y+3]);
                if(ds.str_view() == "XMAS" || ds.str_view() == "SAMX") {
                    count++;
                }
                ds.clear();
            }
            if (x+3 < X_LEN && y-3 >= 0) {
                ds.append_char(matrix[x][y]);
                ds.append_char(matrix[x+1][y-1]);
                ds.append_char(matrix[x+2][y-2]);
                ds.append_char(matrix[x+3][y-3]);
                if(ds.str_view() == "XMAS" || ds.str_view() == "SAMX") {
                    count++;
                }
                ds.clear();
            }
        }
    }
    return count;
}

fn long! part2()
{
    String input = (String) file::load_temp("input.txt")!;
    char[X_LEN][Y_LEN] matrix;
    usz dy = 0;

    foreach (i, ch: input) {
        if (ch == '\n') { dy++; } 
        else { matrix[i % (X_LEN+1)][dy] = ch; }
    }

    DString da;
    DString db;
    usz count = 0;
    for (int y = 1; y < Y_LEN - 1; y++) {
        for (int x = 1; x < X_LEN - 1; x++) {
            if (matrix[x][y] == 'A') {
                da.append_char(matrix[x-1][y-1]);
                da.append_char(matrix[x+1][y+1]);
                db.append_char(matrix[x-1][y+1]);
                db.append_char(matrix[x+1][y-1]);
                if (da.str_view() == "MS" || da.str_view() == "SM") {
                    if (db.str_view() == "MS" || db.str_view() == "SM") {
                        count++;
                    }
                }
            }
            da.clear();
            db.clear();
        }
    }
    return count;
}

fn void main()
{
    Clock c = clock::now();
    io::printfn("- Part1: %d - %s", part1()!!, c.mark());
    io::printfn("- Part2: %d - %s", part2()!!, c.mark());
}

