module playint
import gx
import gg

const key_code_name = {
	0:   ''
	32:  'space'
	39:  'apostrophe'
	44:  'comma'
	45:  'minus'
	46:  'period'
	47:  'slash'
	48:  '0'
	49:  '1'
	50:  '2'
	51:  '3'
	52:  '4'
	53:  '5'
	54:  '6'
	55:  '7'
	56:  '8'
	57:  '9'
	59:  'semicolon'
	61:  'equal'
	65:  'a'
	66:  'b'
	67:  'c'
	68:  'd'
	69:  'e'
	70:  'f'
	71:  'g'
	72:  'h'
	73:  'i'
	74:  'j'
	75:  'k'
	76:  'l'
	77:  'm'
	78:  'n'
	79:  'o'
	80:  'p'
	81:  'q'
	82:  'r'
	83:  's'
	84:  't'
	85:  'u'
	86:  'v'
	87:  'w'
	88:  'x'
	89:  'y'
	90:  'z'
	91:  'left_bracket'
	//[
	92:  'backslash'
	//\
	93:  'right_bracket'
	//]
	96:  'grave_accent'
	//`
	161: 'world_1'
	// non-us #1
	162: 'world_2'
	// non-us #2
	256: 'escape'
	257: 'enter'
	258: 'tab'
	259: 'backspace'
	260: 'insert'
	261: 'delete'
	262: 'right'
	263: 'left'
	264: 'down'
	265: 'up'
	266: 'page_up'
	267: 'page_down'
	268: 'home'
	269: 'end'
	280: 'caps_lock'
	281: 'scroll_lock'
	282: 'num_lock'
	283: 'print_screen'
	284: 'pause'
	290: 'f1'
	291: 'f2'
	292: 'f3'
	293: 'f4'
	294: 'f5'
	295: 'f6'
	296: 'f7'
	297: 'f8'
	298: 'f9'
	299: 'f10'
	300: 'f11'
	301: 'f12'
	302: 'f13'
	303: 'f14'
	304: 'f15'
	305: 'f16'
	306: 'f17'
	307: 'f18'
	308: 'f19'
	309: 'f20'
	310: 'f21'
	311: 'f22'
	312: 'f23'
	313: 'f24'
	314: 'f24'
	320: 'kp_0'
	321: 'kp_1'
	322: 'kp_2'
	323: 'kp_3'
	324: 'kp_4'
	325: 'kp_5'
	326: 'kp_6'
	327: 'kp_7'
	328: 'kp_8'
	329: 'kp_9'
	330: 'kp_decimal'
	331: 'kp_divide'
	332: 'kp_multiply'
	333: 'kp_subtract'
	334: 'kp_add'
	335: 'kp_enter'
	336: 'kp_equal'
	340: 'left_shift'
	341: 'left_control'
	342: 'left_alt'
	343: 'left_super'
	344: 'right_shift'
	345: 'right_control'
	346: 'right_alt'
	347: 'right_super'
	348: 'menu'
}

interface Appli {
mut:
	ctx         &gg.Context
}

pub struct Opt {
mut:
	// The fonction of the action
	actions_liste   []fn (mut app Appli)
	// The name of the action
	actions_names   []string

	// The key to get an action from an event
	event_to_action map[int]int
	// The name of the event that lead to an action
	event_name_from_action [][]string

	// Changes,  -1 -> no change
	id_change	int 

	pause_scroll int
}

pub fn on_event(mut opt Opt, e &gg.Event, mut app Appli){
	if opt.id_change == -1{
		match e.typ {
		.key_down {
			opt.imput(int(e.key_code), mut app)
		}
		else{}
		}
	}
	else{
		opt.change(e, mut app)
	}
}

fn (mut opt Opt) input(key_code int, mut app Appli){
	ind := opt.event_to_action[key_code]
	opt.actions_liste[ind](mut app)
}

fn (mut opt Opt) change(e &gg.Event, mut app Appli){
	match e.typ {
		.key_down {
			key_code := int(e.key_code)
			name := key_code_name[key_code]
			// clean the old action
			old_ind := opt.event_to_action[key_code]
			
			mut new := []string
			for elem in opt.event_name_from_action[old_ind]{
				if elem != name{
					new << [elem]
				}
			}

			opt.event_name_from_action[old_ind] = new


			new_ind := opt.id_change
			// new action
			opt.event_to_action[key_code] = new_ind
			opt.event_name_from_action[new_ind] << [name]

			// reset
			opt.id_change = -1
		}
	else{}
	}
}

pub fn (mut opt Opt) new_action(action fn(mut app Appli), name string){
	opt.actions_liste << [action]
	opt.actions_names << [name]
	opt.event_name_from_action << []string{}
}

pub fn (mut opt Opt) settings_render(){
	for ind in 1..10{
		if ind + app.pause_scroll < opt.actions_names.len {
			x := int(app.win_width/2)
			y := int(100 + ind * 40)

			mut keys_codes_names := ''
			for name in opt.event_name_from_action[ind + opt.pause_scroll]{
				keys_codes_names += name
				keys_codes_names += '; '
			}

			text_rect_render(app, x, y, (opt.actions_names[ind + opt.pause_scroll] + ": " + keys_codes_names), 255)

			x2 := int(3*app.win_width/4)
			app.ctx.draw_circle_filled(x2, y + 15, boutons_radius, gx.gray)
		}
	}
}

fn text_rect_render(app Appli ,x int, y int, text string, transparence u8){
	lenght := text.len * app.text_cfg.size/2
	new_x := x - lenght/2
	new_y := y
	app.ctx.draw_rounded_rect_filled(new_x - 5, new_y, lenght, 25, 5, attenuation(gx.gray, transparence))
	app.ctx.draw_text(new_x, new_y + 5, text, app.text_cfg)
}

fn attenuation (color gx.Color, new_a u8) gx.Color{
	return gx.Color{color.r, color.g, color.b, new_a}
}
