module main

import linklancien.playint
import os
import gg
import gx
import math.vec { Vec2 }

const font_path = os.resource_abs_path('FontMono.ttf')
const bg_color = gg.Color{0, 0, 0, 255}

struct App {
mut:
	ctx &gg.Context = unsafe { nil }
	opt playint.Opt

	// Police
	text_cfg   gx.TextCfg
	bouton_cfg gx.TextCfg

	changing_options bool = true
	mouse_pos        Vec2[f32]
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
		sample_count:  4
		font_path:    font_path
	)
	app.opt.init()
	app.ctx.run()
}

fn on_init(mut app App) {
	// app.opt.new_action(fonction, 'fonction_name', -1 or int(KeyCode. ))
}

fn on_frame(mut app App) {
	app.ctx.begin()
	app.opt.settings_render(app, true)
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App) {
	size := gg.window_size()
	app.ctx.width = size.width
	app.ctx.height = size.height

	playint.on_event(e, mut &app)
}

fn on_click(x f32, y f32, button gg.MouseButton, mut app App) {
	app.mouse_pos = Vec2[f32]{x, y}
	playint.check_boutons_options(mut app)
}

// main fn:
