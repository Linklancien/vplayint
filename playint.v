module playint
import gg
pub interface Appli {
mut:
	test int
}

pub fn event_fn(e &gg.Event, app &Appli) {
	println('Event')
	println(app.test)
	println('End Event')
}
