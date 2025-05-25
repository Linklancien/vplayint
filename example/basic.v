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

	boutons_liste []playint.Bouton
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
		move_fn:       on_move
		click_fn:      on_click
		resized_fn:    on_resized
		sample_count:  4
		font_path:     font_path
	)
	app.opt.init()
	app.ctx.run()
}

fn on_init(mut app App) {
	// app.opt.new_action(fonction, 'fonction_name', -1 or int(KeyCode. ))
}

fn on_frame(mut app App) {
	app.ctx.begin()
	app.opt.settings_render(app)
	playint.boutons_draw(mut app)
	app.main_menu_render()
	app.ctx.end()
}

fn on_event(e &gg.Event, mut app App) {
	playint.on_event(e, mut &app)
}

fn on_click(x f32, y f32, button gg.MouseButton, mut app App) {
	app.mouse_pos = Vec2[f32]{x, y}
	playint.check_boutons_options(mut app)
	playint.boutons_check(mut app)
}

fn on_move(x f32, y f32, mut app App) {
	app.mouse_pos = Vec2[f32]{x, y}
}

fn on_resized(e &gg.Event, mut app App) {
	size := gg.window_size()

	x := f32(size.width / app.ctx.width)
	y := f32(size.height / app.ctx.height)

	app.ctx.width = size.width
	app.ctx.height = size.height

	playint.boutons_pos_resize(mut app, x, y)
}

// main menu fn:

fn (mut app App) main_menu_render(){
	mut transparency := u8(255)
	if app.changing_options{
		transparency = 175
	}
	x := app.ctx.width/2
	y := app.ctx.height/2
	playint.text_rect_render(app.ctx, app.text_cfg, x, y, true, true, 'TITLE', transparency)
	app.ctx.draw_circle_filled(x, y, 10, gx.red)
}

// main fn:
