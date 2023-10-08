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

(local keys [
 {:action (act.SplitVertical {:domain :CurrentPaneDomain})   :key "-" :mods :LEADER}
 {:action (act.SplitHorizontal {:domain :CurrentPaneDomain}) :key "\\" :mods :LEADER}
 {:action (act.SplitHorizontal {:domain :CurrentPaneDomain}) :key "\'" :mods :LEADER}

 {:action act.TogglePaneZoomState :key :z :mods :LEADER}
 {:action (act.SpawnTab :CurrentPaneDomain)  :key :c :mods :LEADER}
 {:action (act.CloseCurrentPane {:confirm false}) :key :q :mods :LEADER}
 {:action (act.SendKey {:key :S :mods :CTRL}) :key :s :mods :CMD}

 {:action (act.ShowLauncherArgs {:flags "FUZZY|WORKSPACES"}) :key :s :mods :LEADER}

 {:action (act.EmitEvent :ActivatePaneDirection-left)  :key :h :mods :CTRL}
 {:action (act.EmitEvent :ActivatePaneDirection-down)  :key :j :mods :CTRL}
 {:action (act.EmitEvent :ActivatePaneDirection-up)    :key :k :mods :CTRL}
 {:action (act.EmitEvent :ActivatePaneDirection-right) :key :l :mods :CTRL}

 {:action (act.AdjustPaneSize [:Left 3])   :key :h :mods :ALT}
 {:action (act.AdjustPaneSize [:Down 3])   :key :j :mods :ALT}
 {:action (act.AdjustPaneSize [:Up 3])     :key :k :mods :ALT}
 {:action (act.AdjustPaneSize [:Right 3])  :key :l :mods :ALT}

 {:action (act.CopyTo    :Clipboard)   :key :c :mods :CMD}
 {:action (act.PasteFrom :Clipboard) :key :v :mods :CMD}

 {:action act.QuitApplication :key :q :mods :CMD}
 {:action act.ShowLauncher    :key :l :mods :CMD}

 {:action (act.SendString "\x1b[13;5u") :key :Enter :mods :CTRL}
 {:action (act.SendString "\x1b[13;2u") :key :Enter :mods :SHIFT}
])

(for [i 1 9 1]
  (table.insert keys {:action (act.ActivateTab (- i 1)) 
          :key (tostring i)
          :mods :LEADER}))

; (fcollect [i 1 9 1] 
;          {:action (act.ActivateTab (- i 1)) 
;           :key (tostring i)
;           :mods :LEADER})
(wez.log_info keys)
keys
