module main

import malisipi.mui as m

struct AppData{
	args		[]string
mut:
	file		string
	home_ui		[]map[string]m.WindowData
	cell_size	u8
}

[direct_array_access]
fn open_csv_file(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
	app_data.file = m.openfiledialog("Open CSV File - Gezgin Satıcı")
	if app_data.file!="" {
		best_way:=best_way_from_csv(app_data.file)
		m.messagebox("Gezgin Satıcı", "File:         "+app_data.file+"\nShortest Way: "+best_way.way+"\nLength:       "+best_way.size.str(), "1", "info")
	}
	app_data.file=""
}

[direct_array_access]
fn create_csv_file(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
	unsafe {
		app_data.cell_size=u8(app.get_object_by_id("slider")[0]["val"].num)
		app.remove_all_objects()
		load_csv_editor(mut app, mut app_data)
	}
}

[direct_array_access]
fn main_gui(mut app_data &AppData){
	mut app:=m.create(m.WindowConfig{ title:"Gezgin Satıcı", width:600, height:250, app_data:app_data })

	app.label(m.Widget{ id:"title" x:"10%x", y:"10%y", width:"80%x", height:"15%y", text:"Gezgin Satıcı", text_size:30 })
	$if !android {
		app.button(m.Widget{ id:"open_csv_file", x:"10%x", y:"# 40%y", width:"80%x", height: "15%y" text:"Open CSV File", onclick:open_csv_file})
		app.label(m.Widget{ id:"or" x:"10%x", y:"# 25%y", width:"80%x", height:"15%y", text:"Or" })
	}
	app.slider(m.Widget{ id:"slider", x:"10%x", y:"# 10%y", width:"40%x -50", height: "15%y", value:2, value_min:2, value_max:50 })
	app.button(m.Widget{ id:"new_file", x:"# 10%x", y:"# 10%y", width:"40%x", height: "15%y" text:"Create New File", onclick:create_csv_file})
	
	app_data.home_ui=app.clone_app_objects()
	
	app.run()
}
