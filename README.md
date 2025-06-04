A V module that manages the link between a key and it's action, also provide boutons.

It allows the change of the keybinds dynamically.

use ```v install Linklancien.playint``` to download this module and then ```import linklancien.playint``` in your .v file to use it.
It uses the module gg.

Good to know for an easy use:
- use a struct that possesses all the fields of the Appli interface:
   ```
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
   ```
  This interface will be used to link your code and the informations the module needs.  
  You can easily implement it as shown in this example of an App struct:
   ```
   struct App {
      playint.Opt
    }
   ```
- you need to define your gg.Context, in your main function, with the following functions:
  ```
  init_fn:       on_init
  frame_fn:      on_frame
  event_fn:      on_event
  click_fn:      on_click
  resized_fn:    on_resized
  ```
  Here is an exemple of a main function:
  ```
  fn main() {
	mut app := &App{}
	app.ctx = gg.new_context(
		fullscreen:    false
		width:         100 * 8
		height:        100 * 8
		create_window: true
		window_title:  '--'
		user_data:     app
		init_fn:       on_init
		frame_fn:      on_frame
		event_fn:      on_event
		click_fn:      on_click
		resized_fn:    on_resized
		sample_count:  4
		font_path:     playint.font_path
	)
	app.init()
	app.ctx.run()
	}
  ```
  - the on_init function is where you usually declare all your boutons, and the fonction that you want to be key-binded.  
    Respectively by adding them in the ``boutons_list`` an array of your struct.  
    If you want to add a button, all you need is at least 3 function that all take only (mut Appli) in there arguments:  
   - ``function`` that is the fonction you want to call when the button is pressed.  
   - ``is_visible`` that returns a bool, true if your button is visible and false if it's not.  
   - ``is_actionnable`` that also returns a true if the button is actionnable and false if it's not.  
    Most of the time it is the same as ``is_visible`` but with the ``if !changing_options{} && ...``.  

    TYou key-binded a function by using the ``app.new_action`` function.  
    You have to give in order: ``(function, 'function_name', -1 or int(gg.KeyCode.THE_KEY_YOU_WANT_TO_BE_ASSIGNED)``.
    - ``new_action`` needs to be called on your a ``playint.Opt`` struct
    - the function needs to be such as ``fn (mut Appli)``. 
    If you want to access fields that are not in Appli, you can use ``if mut app is App{}`` or ``match app{App{}}``, the type of app will change accordingly.  
    - function_name is a string  
    - the last argument is -1 if you don't key-bind your action or int(gg.KeyCode.THE_KEY_YOU_WANT_TO_BE_ASSIGNED) if you key_bind it.    
> [!CAUTION]
> Be aware, qwerty and azerty aren't support yet, but in game it works well.
  - the on_frame function is as followed:
  ```
  fn on_frame(mut app App) {
	app.ctx.begin()
	app.settings_render()
	app.boutons_draw()
	app.ctx.end()
  }
  ```
  ``app.settings_render()`` is use to draw the settings panel when ``app.changing_options`` is true.  
  ``app.boutons_draw()`` is use to draw all the buttons on ``app.boutons_list``.  
  You juste have to call those two fonction in between ``app.ctx.begin()`` and ``app.ctx.end()``.  
  You can put your code all around as you want.  
  - the on_event function is simple you can base your's on the following:
  ```
  fn on_event(e &gg.Event, mut app App) {
	app.on_event(e, mut app)
  }
  ```
  You only need to call ``app.on_event(e, mut app)`` in it and the module will handle the interactions.  
  You can use on_event to handle somme special event, for that, juste add your code after calling  ``app.on_event(e, mut app)``
  - the on_click function is here to trigger the buttons:
  ```
  fn on_click(x f32, y f32, button gg.MouseButton, mut app App) {
	app.check_boutons_options()
	app.boutons_check()
  }
  ```
  - the on_resized function is here to change the position of the button as your window extend or retract
  ```
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
  ```
