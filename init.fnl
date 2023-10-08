(local wez (require :wezterm))
(local theme (include :theme))

(local keys (include :keys))

(local my_fonts 
       (wez.font_with_fallback
         [
          "Liga SFMono Nerd Font"
          "BlexMono Nerd Font Mono"
          "Apple Color Emoji"
          "Iosevka Term"
        ]))

(local paddings {
       :top "0.5cell"
       :left "1cell"
       :right "1cell"
       :bottom "0.5cell"
       })

{
  :font_size 13.0
  :freetype_load_target "Light"
  :freetype_render_target "HorizontalLcd"
  :font my_fonts

  :front_end "WebGpu"
  :max_fps 120

  :window_decorations "RESIZE"
  :window_padding paddings
  :underline_position -2

  :audible_bell "Disabled"

  ;; tab bar
  :tab_bar_at_bottom true
  :use_fancy_tab_bar false
  :show_new_tab_button_in_tab_bar false 
  :hide_tab_bar_if_only_one_tab false 

  :colors theme.colors

  ;; key stuff
  :leader {
    :key :a
    :mods :CTRL
    }
  :disable_default_key_bindings true
  :keys keys
}
