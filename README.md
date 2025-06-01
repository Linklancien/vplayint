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
- you need to define your gg.Context whith the following functions:
  ```
    init_fn:       on_init
		frame_fn:      on_frame
		event_fn:      on_event
		move_fn:       on_move
		click_fn:      on_click
		resized_fn:    on_resized
  ```
  - the on_init function is where you declare all your boutons, and the fonction that you want to be key-binded. Respectively by adding them in the ``boutons_liste`` array of your struct and by using the ``opt.new_action`` function.
    Let's detail more the ``opt.new_action`` function, in order, you have to give: ``(fonction, 'fonction_name', -1 or int(KeyCode.THE_KEY_YOU_WANT_TO_BE_ASSIGNED)``.
