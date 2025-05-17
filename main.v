module main

import playint
import gg

const bg_color = gg.Color{0, 0, 0, 255}

struct App {
mut:
	ctx &gg.Context = unsafe { nil }
	test	int = 1
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
		event_fn:      playint.event_fn
		sample_count:  4
	)
	app.ctx.run()
}