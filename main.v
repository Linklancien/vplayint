module main

import playint
import gg
import gx
import math.vec {Vec2}

const bg_color = gg.Color{0, 0, 0, 255}

struct App {
mut:
	ctx &gg.Context = unsafe { nil }
	opt playint.Opt


	// Police
	text_cfg	gx.TextCfg
	bouton_cfg	gx.TextCfg
	
	changing_options	bool = true
	mouse_pos	Vec2[f32]
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
		event_fn:      playint.on_event
		sample_count:  4
	)
	app.opt.init()
	app.ctx.run()
}

fn on_init(mut app App) {}

fn on_frame(mut app App) {
	app.opt.settings_render(app)
}
