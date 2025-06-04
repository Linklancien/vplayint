module main

import linklancien.playint
import os
import gg
import math.vec { Vec2 }

const font_path = os.resource_abs_path('FontMono.ttf')
const bg_color = gg.Color{0, 0, 0, 255}

struct App {
	playint.Opt
}

fn main() {
	mut app := &App{}
	app.ctx = gg.new_context(
		fullscreen:    false
		width:         100 * 8
		height:        100 * 8
		create_window: true
		window_title:  '--'
		user_data:     app
		bg_color:      bg_color
		init_fn:       on_init
		frame_fn:      on_frame
		event_fn:      on_event
		click_fn:      on_click
		resized_fn:    on_resized
		sample_count:  4
		font_path:     font_path
	)
	app.init()
	app.ctx.run()
}

fn on_init(mut app App) {
	// app.new_action(function, 'fonction_name', -1 or int(KeyCode. ))
	app.boutons_list << [
		playint.Bouton{
			text:           'Options'
			pos:            Vec2[f32]{4 * 'Options'.len + 5, 16}
			function:       playint.option_pause
			is_visible:     params_is_visible
			is_actionnable: params_is_actionnable
		},
	]
}

fn on_frame(mut app App) {
	app.ctx.begin()
	app.settings_render()
	app.boutons_draw()
	app.main_menu_render()
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App) {
	app.on_event(e)
}

fn on_click(x f32, y f32, button gg.MouseButton, mut app App) {
	app.check_boutons_options()
	app.boutons_check()
}

fn on_resized(e &gg.Event, mut app App) {
	size := gg.window_size()
	old_x := app.ctx.width
	old_y := app.ctx.height
	new_x := size.width
	new_y := size.height

	app.boutons_pos_resize(old_x, old_y, new_x, new_y)

	app.ctx.width = size.width
	app.ctx.height = size.height
}

// main menu fn:

fn (mut app App) main_menu_render() {
	mut transparency := u8(255)
	if app.changing_options {
		transparency = 175
	}
	x := app.ctx.width / 2
	y := app.ctx.height / 2
	playint.text_rect_render(app.ctx, app.text_cfg, x, y, true, true, 'TITLE', transparency)
}

// main fn:

fn params_is_visible(mut app playint.Appli) bool {
	return true
}

fn params_is_actionnable(mut app playint.Appli) bool {
	return true
}
