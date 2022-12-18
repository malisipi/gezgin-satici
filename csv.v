module main

import os

[direct_array_access]
fn load_csv_data(file string)! ([]string, [][]f32) {
    text := os.read_file(file)!
    rows := text.split('\n')
    mut data := [][]f32{}
    for the_row in 1..rows.len-1 {
        mut row_points := []f32{}
        for point in rows[the_row].split(",") {
            row_points << point.f32()
        }
        data << row_points
    }
    return rows[0].split(","), data
}

[direct_array_access]
fn best_way_from_csv(file string) Way {
	mut str,csv_data := load_csv_data(file) or {
		println("[ERR ] Unable to open the file")
		exit(1)
	}
	
	mut df := map[string]int{}
	for i,t in str {
		df[t]=i
	}
	
	return permute_best_way(csv_data, df, mut str)
}
