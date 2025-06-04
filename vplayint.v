module playint

import gx
import gg { KeyCode }
import math.vec { Vec2 }

const boutons_radius = 10

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

pub interface Appli {
mut:
	ctx &gg.Context

	// The function of the action
	actions_liste []fn (mut Appli)

	// The name of the action
	actions_names []string

	// The key to get an action from an event
	event_to_action map[int]int

	// The name of the event that lead to an action
	event_name_from_action [][]string

	// Changes,  -1 -> no change
	id_change int

	pause_scroll int

	// most likely between 0 & 1
	description_placement_proportion f32

	// most likely between 1 & 2
	bouton_placement_proportion f32

	text_cfg gx.TextCfg

	changing_options bool

	boutons_list []Bouton
}

pub struct Opt {
mut:
	ctx &gg.Context = unsafe { nil }

	// The function of the action
	actions_liste []fn (mut Appli)

	// The name of the action
	actions_names []string

	// The key to get an action from an event
	event_to_action map[int]int

	// The name of the event that lead to an action
	event_name_from_action [][]string

	// Changes,  -1 -> no change
	id_change int = -1

	pause_scroll int

	// most likely between 0 & 1
	description_placement_proportion f32 = 0.5

	// most likely between 1 & 2
	bouton_placement_proportion f32 = 1.5

	text_cfg gx.TextCfg

	changing_options bool

	boutons_list []Bouton
}

pub fn (mut opt Opt) init() {
	opt.new_action(none_fn, 'none_fn', -1)
	opt.new_action(force_close, 'force close', int(KeyCode.f4))
	opt.new_action(option_pause, 'option pause', int(KeyCode.escape))
}

// Base fonctions
fn none_fn(mut opt Appli) {}

pub fn force_close(mut app Appli) {
	app.ctx.quit()
}

pub fn option_pause(mut app Appli) {
	app.changing_options = !app.changing_options
}

pub fn (mut opt Opt) on_event(e &gg.Event) {
	if opt.id_change == -1 {
		match e.typ {
			.key_down {
				opt.input(int(e.key_code))
			}
			.mouse_down {
				match e.mouse_button {
					.left {
						// check_boutons(e.mouse_x, e.mouse_y)
					}
					else {}
				}
			}
			else {}
		}
	} else {
		opt.key_change(e)
	}
}

fn (mut opt Opt) input(key_code int) {
	ind := opt.event_to_action[key_code]
	opt.actions_liste[ind](mut opt)
}

fn (mut opt Opt) key_change(e &gg.Event) {
	match e.typ {
		.key_down {
			opt.change(int(e.key_code))
		}
		else {}
	}
}

fn (mut opt Opt) change(key_code int) {
	name := key_code_name[key_code]

	// clean the old action
	old_ind := opt.event_to_action[key_code]

	mut new := []string{}
	for elem in opt.event_name_from_action[old_ind] {
		if elem != name {
			new << [elem]
		}
	}

	opt.event_name_from_action[old_ind] = new

	new_ind := opt.id_change
	if new_ind == old_ind {
		// suppress the key
		opt.event_to_action[key_code] = 0
	} else {
		// new action
		opt.event_to_action[key_code] = new_ind
		opt.event_name_from_action[new_ind] << [name]
	}

	// reset
	opt.id_change = -1
}

pub fn (mut opt Opt) new_action(action fn (mut Appli), name string, base_key_code int) {
	opt.actions_liste << [action]
	opt.actions_names << [name]
	opt.event_name_from_action << []string{}

	new_ind := opt.event_name_from_action.len - 1

	// new action
	if base_key_code != -1 {
		opt.event_to_action[base_key_code] = new_ind
		opt.event_name_from_action[new_ind] << [key_code_name[base_key_code]]
	}
}

pub fn (mut opt Opt) settings_render() {
	if opt.changing_options {
		for ind in 1 .. 10 {
			true_ind := ind + opt.pause_scroll
			if true_ind < opt.actions_names.len {
				x := int(opt.ctx.width / 2)
				y := int(100 + ind * 40)

				mut keys_codes_names := ''
				if opt.event_name_from_action[true_ind].len > 0 {
					keys_codes_names = opt.event_name_from_action[true_ind][0]
					for name in opt.event_name_from_action[true_ind][1..] {
						keys_codes_names += ', '
						keys_codes_names += name
					}
				}

				mut transparency := u8(255)
				circle_pos := Vec2[f32]{f32(x * opt.bouton_placement_proportion), y + 15}
				mouse_pos := Vec2[f32]{opt.ctx.mouse_pos_x, opt.ctx.mouse_pos_y}
				if point_is_in_cirle(circle_pos, boutons_radius, mouse_pos) {
					transparency = 175
				}

				text_rect_render(opt.ctx, opt.text_cfg, x * opt.description_placement_proportion,
					y, false, false, (opt.actions_names[true_ind] + ': ' + keys_codes_names),
					transparency)
				mut color := gx.gray
				if opt.id_change == true_ind {
					color = gx.red
				}
				opt.ctx.draw_circle_filled(x * opt.bouton_placement_proportion, y + 15,
					boutons_radius, attenuation(color, transparency))
			}
		}
	}
}

// Check
pub fn (mut opt Opt) check_boutons_options() {
	if opt.changing_options {
		for ind in 1 .. 10 {
			if ind + opt.pause_scroll < opt.actions_names.len {
				y := 115 + ind * 40
				circle_pos := Vec2[f32]{f32(opt.ctx.width * opt.bouton_placement_proportion / 2), y}
				mouse_pos := Vec2[f32]{opt.ctx.mouse_pos_x, opt.ctx.mouse_pos_y}
				if point_is_in_cirle(circle_pos, boutons_radius, mouse_pos) {
					if opt.id_change != ind + opt.pause_scroll {
						opt.id_change = ind + opt.pause_scroll
					} else {
						opt.id_change = 0
					}
					break
				}
			}
		}
	}
}

fn point_is_in_cirle(circle_pos Vec2[f32], radius f32, mouse_pos Vec2[f32]) bool {
	if (mouse_pos - circle_pos).magnitude() < radius {
		return true
	}
	return false
}

// Bouton
pub struct Bouton {
pub mut:
	text           string
	cfg            gx.TextCfg
	pos            Vec2[f32]
	function       fn (mut Appli)      @[required]
	is_visible     fn (mut Appli) bool @[required]
	is_actionnable fn (mut Appli) bool @[required]
}

// Bouton fn
pub fn (btn Bouton) check(mut app Appli) bool {
	mouse_pos := Vec2[f32]{app.ctx.mouse_pos_x, app.ctx.mouse_pos_y}
	return point_is_in_cirle(btn.pos, 20, mouse_pos)
}

pub fn (btn Bouton) draw(mut app Appli) {
	if btn.is_visible(mut app) {
		mut transparency := u8(255)
		if !btn.is_actionnable(mut app) || btn.check(mut app) {
			transparency = 175
		}
		text_rect_render(app.ctx, btn.cfg, btn.pos.x, btn.pos.y, true, true, btn.text,
			transparency)
	}
}

pub fn (mut btn Bouton) pos_resize(x_ratio f32, y_ratio f32, old_x f32, old_y f32, new_x f32, new_y f32) {
	btn.pos = Vec2[f32]{
		x: (btn.pos.x - old_x) * x_ratio + new_x
		y: (btn.pos.y - old_y) * y_ratio + new_y
	}
}

// Boutons fn
pub fn (mut opt Opt) boutons_check() {
	for btn in opt.boutons_list {
		if btn.check(mut opt) && btn.is_actionnable(mut opt) {
			btn.function(mut opt)
		}
	}
}

pub fn (mut opt Opt) boutons_draw() {
	for btn in opt.boutons_list {
		btn.draw(mut opt)
	}
}

pub fn (mut opt Opt) boutons_pos_resize(old_x f32, old_y f32, new_x f32, new_y f32) {
	x_ratio := f32(new_x / old_x)
	y_ratio := f32(new_y / old_y)

	for mut btn in opt.boutons_list {
		btn.pos_resize(x_ratio, y_ratio, old_x, old_y, new_x, new_y)
	}
}

// UI
pub fn text_rect_render(ctx gg.Context, cfg gx.TextCfg, x f32, y f32, middle_width bool, middle_height bool, text_brut string, transparency u8) {
	text_split := text_brut.split('\n')

	mut text_len := []int{cap: text_split.len}
	mut max_len := 0

	// Precalcul
	for text in text_split {
		lenght := text.len * 8 + cfg.size
		text_len << lenght

		if lenght > max_len {
			max_len = lenght
		}
	}

	// affichage
	mut new_x := x
	if middle_width {
		new_x -= max_len / 2
	}
	mut new_y := y
	if middle_height {
		new_y -= cfg.size * text_split.len
	}

	ctx.draw_rounded_rect_filled(new_x, new_y, max_len, cfg.size * text_split.len + cfg.size,
		5, attenuation(gx.gray, transparency))

	new_y += cfg.size / 2
	for text in text_split {
		ctx.draw_text(int(new_x + cfg.size / 2), int(new_y), text, cfg)
		new_y += cfg.size
	}
}

pub fn attenuation(color gx.Color, new_a u8) gx.Color {
	return gx.Color{color.r, color.g, color.b, new_a}
}
