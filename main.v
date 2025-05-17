module main

import gg

struct App {
mut:
        ctx &gg.Context = unsafe { nil }
//      test    int = 1
}

fn main() {
        mut app := &App{}
        app.ctx = gg.new_context(
                user_data:     app
                init_fn:      event_fn
        )
        app.ctx.run()
}

pub interface Appli {
mut:
        test int
}

pub fn event_fn(mut app Appli) {
        eprintln('Event')
        eprintln(app.test)
        eprintln('End Event')
}