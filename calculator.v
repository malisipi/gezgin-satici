module main

import math

const (
	perm_len	= 9
)

struct Way {
	way		string
	size	f32
}

[direct_array_access]
fn calc_way_size(dat [][]f32, df map[string]int, way_stops []string, sp int) f32 {
	mut total_way:=f32(0)
	for the_stop in sp..sp+way_stops.len-1 {
		stop_1:=df[way_stops[the_stop]]
		stop_2:=df[way_stops[the_stop+1]]
		total_way+=dat[math.min(stop_1,stop_2)][math.max(stop_1,stop_2)]
	}
	return total_way
}

[direct_array_access]
fn permute_subways(mut col []Way, dat [][]f32, df map[string]int, mut a []string, l int, r int, sp int) {
	mut i := 0
	if l == r {
		col << Way{ way: a.join("-"), size:calc_way_size(dat, df, a, sp) }
	} else {
		for i = l; i <= r; i++ {
			a[l],a[i] = a[i],a[l]
			permute_subways(mut &col, dat, df, mut a, l + 1, r, sp)
			a[l],a[i] = a[i],a[l]
		}
	}
}

[direct_array_access]
fn permute_best_way(dat [][]f32, df map[string]int, mut a []string) Way {
	perm_times := a.len/perm_len + if a.len%perm_len == 0 {0} else {1}
	mut col:=[][]Way{}
	for the_perm in 0..perm_times {
		mut temp_col:=[]Way{}
		permute_subways(mut &temp_col, dat, df, mut a#[the_perm*perm_len..the_perm*perm_len+perm_len], 0, a#[the_perm*perm_len..the_perm*perm_len+perm_len].len-1, 0)
		temp_col.sort(a.size < b.size)
		col << temp_col
	}
	mut the_way := ""
	mut the_size := f32(0)
	for the_perm in 0..perm_times {
		the_way += "-"+ col[the_perm][0].way
		the_size += col[the_perm][0].size
	}
	for the_perm in 0..perm_times-1 {
		the_size += dat[df[col[the_perm][0].way.split("-")#[-1..][0]]][df[col[the_perm+1][0].way.split("-")[0]]]
	}
	return Way { way:the_way[1..], size:the_size }
}
