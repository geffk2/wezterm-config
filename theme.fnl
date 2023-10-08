(local colors {
    :rosewater "#F4DBD6"
    :flamingo "#F0C6C6"
    :pink "#F5BDE6"
    :mauve "#C6A0F6"
    :red "#ED8796"
    :maroon "#EE99A0"
    :peach "#F5A97F"
    :yellow "#EED49F"
    :green "#A6DA95"
    :teal "#8BD5CA"
    :sky "#91D7E3"
    :sapphire "#7DC4E4"
    :blue "#8AADF4"
    :lavender "#B7BDF8"

    :text "#CAD3F5"
    :subtext1 "#B8C0E0"
    :subtext0 "#A5ADCB"
    :overlay2 "#939AB7"
    :overlay1 "#8087A2"
    :overlay0 "#6E738D"
    :surface2 "#5B6078"
    :surface1 "#494D64"
    :surface0 "#363A4F"
    :base "#24273A"
    :mantle "#1E2030"
    :crust "#181926"
  })

(local theme {
       :split colors.surface0 
       :foreground colors.text 
       :background colors.base 
       :cursor_bg colors.rosewater
       :cursor_fg colors.base 
       :selection_bg colors.surface2
       :selection_fg colors.text 
       :visual_bell colors.surface0
       :indexed {
        16 colors.peach 
        17 colors.rosewater
       }
       :scrollbar_thumb colors.surface2
       :compose_cursor colors.flamingo

       :ansi [
              colors.surface1
              colors.red 
              colors.green
              colors.yellow
              colors.blue
              colors.pink
              colors.teal
              colors.subtext0
              ]
       :brights [
                 colors.subtext0
                 colors.red
                 colors.green
                 colors.yellow
                 colors.blue
                 colors.pink
                 colors.teal
                 colors.surface1
                 ]

       :tab_bar {
        :background colors.crust 
        :active_tab {
          :bg_color :None
          :fg_color colors.subtext1
          :intensity :Bold
          :underline :None
          :italic false
          :strikethrough false
        }
        :inactive_tab {
          :bg_color colors.crust
          :fg_color colors.surface2
        }
        :inactive_tab_hover {
          :bg_color colors.mantle
          :fg_color colors.subtext0
        }
        :new_tab {
          :bg_color colors.crust
          :fg_color colors.subtext0
        }
        :new_tab_hover {
          :bg_color colors.crust
          :fg_color colors.subtext0
        }
       }
       })


(local wez (require :wezterm))
(local nerd wez.nerdfonts)

(local process_icons {
      :docker         [ {:Foreground {:Color colors.blue}} {:Text nerd.linux_docker} ]
      :docker-compose [ {:Foreground {:Color colors.blue}} {:Text nerd.linux_docker} ]
      :lazydocker     [ {:Foreground {:Color colors.blue}} {:Text nerd.linux_docker} ]

      :nvim [ {:Foreground {:Color colors.green}} {:Text nerd.custom_vim} ]
      :vim  [ {:Foreground {:Color colors.green}} {:Text nerd.dev_vim} ]
      :node [ {:Foreground {:Color colors.green}} {:Text nerd.mdi_hexagon} ]

      :zsh  [ {:Foreground {:Color colors.peach}} {:Text nerd.dev_terminal} ]
      :fish [ {:Foreground {:Color colors.peach}} {:Text nerd.dev_terminal} ]
      :bash [ {:Foreground {:Color colors.peach}} {:Text nerd.dev_bash} ]

      :htop [ {:Foreground {:Color colors.yellow}} {:Text nerd.mdi_chart_donut_variant} ]

      :cargo [ {:Foreground {:Color colors.peach}} {:Text nerd.dev_rust} ]
      :go [ {:Foreground {:Color colors.sapphire}} {:Text nerd.mdi_language_go} ]

      :git     [ {:Foreground {:Color colors.peach}} {:Text nerd.dev_git} ]
      :lazygit [ {:Foreground {:Color colors.peach}} {:Text nerd.dev_git} ]
      })

(fn default_format [pname] [
                       {:Foreground {:Color colors.sky}}
                       {:Text (string.format "[%s]" pname)}
                       ])

(fn get_process [tab]
  (local pname (string.gsub tab.active_pane.foreground_process_name "(.*[/\\])(.*)" "%2"))
  (wez.format (or (. process_icons pname) (default_format pname))))

(fn get_cwd [tab] 
  (local cwd tab.active_pane.current_working_dir)
  (string.format "  %s" (string.gsub cwd "(.*[/\\])(.*)" "%2")))

(wez.on "format-tab-title" 
        (fn [tab]
          (wez.format [
                       {:Attribute {:Intensity :Half}}
                       {:Text (string.format " %s  " (+ tab.tab_index 1))}
                       :ResetAttributes
                       {:Text (get_process tab)}
                       {:Text " "}
                       {:Text (get_cwd tab)}
                       {:Foreground {:Color colors.base}}
                       {:Text "  ▕"}
                       ])))

{
  :colors theme
  :color_names colors
}
