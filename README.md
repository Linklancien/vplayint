A V module that manage the link between a key and it's action, also provide boutons.

It allows the change of the keybinds dynamically.

use ```v install Linklancien.playint``` to download this module and then ```import linklancien.playint``` in your .v file to use it.
It use the module gg.

Good to know for an easy use:
- use a struct that possesses all the fiel of the Appli interface example:
   ```
   struct App {
    mut:
      ctx &gg.Context = unsafe { nil }
      opt playint.Opt
      text_cfg   gx.TextCfg

      changing_options bool
      mouse_pos        Vec2[f32]

      boutons_liste []playint.Bouton
    }
   ```
- you need to define your gg.Context with the following functions:
  ```
  init_fn:       on_init
  frame_fn:      on_frame
  event_fn:      on_event
  move_fn:       on_move
  click_fn:      on_click
  resized_fn:    on_resized
  ```
  - the on_init function is where you declare all your boutons, and the fonction that you want to be key-binded. Respectively by adding them in the ``boutons_liste`` array of your struct and by using the ``opt.new_action`` function.
    Let's detail more the ``opt.new_action`` function, in order, you have to give: ``(function, 'function_name', -1 or int(gg.KeyCode.THE_KEY_YOU_WANT_TO_BE_ASSIGNED)``.
    - the function need to only have (mut Appli) in it's arguments, but you can use ``if mut app is App{}`` or ``match app{App{}}``.
    
    - function_name is a string
    
    - the last argument is -1 if you don't key-bind your action or int(int(gg.KeyCode.THE_KEY_YOU_WANT_TO_BE_ASSIGNED))) ! Be aware, qwerty and azerty aren't support yet, but in game it works well
    - lastly, ``new_action`` need to be called on your a ``playint.Opt`` struct
  - the on_frame function is as followed:
  ```
  fn on_frame(mut app App) {
	app.ctx.begin()
	app.opt.settings_render(app)
	playint.boutons_draw(mut app)
	app.ctx.end()
  }
  ```
  - the on_event function is simple you can base your's on the following:
  
  ```
  fn on_event(e &gg.Event, mut app App) {
	playint.on_event(e, mut &app)
  }
  ```
  - the on_move function is mean to get the position of your cursor ervery time it moves so the module know wich button is clickable
  ```
  fn on_move(x f32, y f32, mut app App) {
	app.mouse_pos = Vec2[f32]{x, y}
  }
  ```
   - the on_click function is here to trigger the buttons:
  ```
  fn on_click(x f32, y f32, button gg.MouseButton, mut app App) {
	app.mouse_pos = Vec2[f32]{x, y}
	playint.check_boutons_options(mut app)
	playint.boutons_check(mut app)
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

	playint.boutons_pos_resize(mut app, old_x, old_y, new_x, new_y)

	app.ctx.width = size.width
	app.ctx.height = size.height
  }
  ```

- if you want to add a button, all you need is at least 3 function that all take only (mut Appli) in there arguments:
   - ``function`` that is the fonction you want to call when the button is pressed
   - ``is_visible`` that return a bool, true if your button is visible and false if it's not 
   - ``is_actionnable`` that also return a true if the button is actionnable and false if it's not, most of the time it is the same as ``is_visible`` but with the ``if !changing_options{}``
