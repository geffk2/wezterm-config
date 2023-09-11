(local wez (require :wezterm))
(local act wez.action)

;; support for passing pane switches to vim
(fn is_vi_process [pane]
  (let [pname (pane:get_foreground_process_name)]
   (not= nil (pname:find "n?vim"))))

(fn conditional_activate_pane [window pane pane_dir vim_dir]
  (if (is_vi_process pane) 
      (window:perform_action (act.SendKey :key vim_dir :mods :CTRL) pane)
      (window:perform_action (act.ActivatePaneDirection pane_dir) pane)
      ))

(local directions {
       :left  :H 
       :down  :J 
       :up    :K 
       :right :L
       })

(each [dir key (pairs directions)] 
  (wez.on (.. "ActivatePaneDirection-" dir) 
          #(conditional_activate_pane $1 $2 dir key)
  ))

[
 {:action (act.SplitVertical {:domain :CurrentPaneDomain})   :key "-" :mods :LEADER}
 {:action (act.SplitHorizontal {:domain :CurrentPaneDomain}) :key "\\" :mods :LEADER}
 {:action (act.SplitHorizontal {:domain :CurrentPaneDomain}) :key "\'" :mods :LEADER}

 {:action act.TogglePaneZoomState :key :Z :mods :LEADER}
 {:action (act.SpawnTab {:domain :CurrentPaneDomain}) :key :C :mods :LEADER}
 {:action (act.CloseCurrentPane {:confirm false}) :key :Q :mods :LEADER}
 {:action (act.SendKey {:key :S :mods :CTRL}) :key :S :mods :CMD}

 {:action (act.ShowLauncherArgs {:flags "FUZZY|WORKSPACES"}) :key :S :mods :LEADER}

 {:action (act.EmitEvent :ActivatePaneDirection-left)  :key :H :mods :CTRL}
 {:action (act.EmitEvent :ActivatePaneDirection-down)  :key :J :mods :CTRL}
 {:action (act.EmitEvent :ActivatePaneDirection-up)    :key :K :mods :CTRL}
 {:action (act.EmitEvent :ActivatePaneDirection-right) :key :L :mods :CTRL}

 {:action (act.AdjustPaneSize [:Left 3])   :key :H :mods :ALT}
 {:action (act.AdjustPaneSize [:Down 3])   :key :J :mods :ALT}
 {:action (act.AdjustPaneSize [:Up 3])     :key :K :mods :ALT}
 {:action (act.AdjustPaneSize [:Right 3])  :key :L :mods :ALT}

 (fcollect [i 1 9 1] 
           {:action (act.ActivateTab (- i 1)) 
            :key (tostring i)
            :mods :LEADER})

 {:action (act.CopyTo :Clipboard)   :key :C :mods :CMD}
 {:action (act.CopyFrom :Clipboard) :key :V :mods :CMD}

 {:action act.QuitApplication :key :Q :mods :CMD}
 {:action act.ShowLauncher    :key :L :mods :CMD}

 {:action (act.SendString "\x1b[13;5u") :key :ENTER :mods :CTRL}
 {:action (act.SendString "\x1b[13;2u") :key :ENTER :mods :SHIFT}
]
