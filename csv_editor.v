module main

import malisipi.mui as m

const (
	all_labels	= "ABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZαβγδεζηθικλμνξοπρφ".runes()
)

[direct_array_access]
fn best_way_from_data(labels []rune, the_table [][]f32) Way {
	mut str:=[]string{}
	mut df := map[string]int{}
	for i,t in labels {
		df[t.str()]=i
		str << t.str()
	}
	
	return permute_best_way(the_table, df, mut str)
}

[direct_array_access]
fn create_data_from_table(mut app &m.Window, mut app_data &AppData) [][]f32{
	labels := all_labels[0..app_data.cell_size]
	mut temp_table:=[][]f32{}
	for ri,r in labels {
		mut temp_row:=[]f32{}
		for ci,c in labels {
			if ri<ci {
				unsafe {
					temp_row << app.get_object_by_id(r.str()+";"+c.str())[0]["text"].str.f32()
				}
			} else {
				temp_row << 0
			}
		}
		temp_table << temp_row
	}
	return temp_table
}

[direct_array_access]
fn load_home_ui(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
	app.remove_all_objects()
	app.load_app_objects(app_data.home_ui)
	app.enable_scrollbar(false)
}

[direct_array_access]
fn calc_best_way(event_details m.EventDetails, mut app &m.Window, mut app_data &AppData){
	best_way:=best_way_from_data(all_labels[0..app_data.cell_size], create_data_from_table(mut app, mut app_data))
	m.messagebox("Gezgin Satıcı", "File:         "+app_data.file+"\nShortest Way: "+best_way.way+"\nLength:       "+best_way.size.str(), "1", "info")
}

[direct_array_access]
fn load_csv_editor(mut app &m.Window, mut app_data &AppData){
	labels := all_labels[0..app_data.cell_size]
	app.enable_scrollbar(true)
	app.set_viewarea((labels.len+1)*60,(labels.len+2)*30)
	app.button(m.Widget{x:0, y:0, width:180, height:30, text:"Back", onclick:load_home_ui})
	app.button(m.Widget{x:200, y:0, width:180, height:30, text:"Calculate", onclick:calc_best_way})
	
	for ri,r in labels {
		app.label(m.Widget{ x:(ri+1)*60, y:30 width:60, height:30, id:"r"+r.str(), text:r.str()})
	}
	
	for ci,c in labels {
		app.label(m.Widget{ x:0, y:(ci+2)*30 width:60, height:30, id:"c"+c.str(), text:c.str()})
	}
	
	for ri,r in labels {
		for ci,c in labels {
			if ri<ci {
				app.textarea(m.Widget{ x:(ci+1)*60, y:(ri+2)*30 width:60, height:30, id:r.str()+";"+c.str() })
			}
		}
	}
	
	app.sort_widgets_with_zindex()
}
