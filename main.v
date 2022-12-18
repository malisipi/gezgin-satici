module main

import os

[direct_array_access]
fn main() {
	mut app_data:=AppData{
		args:os.args_after(""),
		file:""
	}
	if app_data.args.len>1 {
		app_data.file = app_data.args[1]
		println("File:         "+app_data.file)
		best_way:=best_way_from_csv(app_data.file)
		println("Shortest Way: "+best_way.way)
		println("Length:       "+best_way.size.str())
	} else {
		main_gui(mut &app_data)
	}
}
