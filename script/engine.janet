#     _______   _____________   ________
#    / ____/ | / / ____/  _/ | / / ____/
#   / __/ /  |/ / / __ / //  |/ / __/
#  / /___/ /|  / /_/ // // /|  / /___
# /_____/_/ |_/\____/___/_/ |_/_____/

(import ./config :prefix "")
(import ./globals :as g)
(import ./game :as game)

(defn load-repository [path]
  (var data (slurp path))  
  (string/split "\n" data))

(defn start []
  (var engine (merge config {}))

  (set (engine :repository) (load-repository g/repository)) # TODO: move it to config  
  (set (engine :window-width) g/window-width)
  (set (engine :window-height) g/window-height)
  (set (engine :window-title) g/window-title)
  (set (engine :frames-per-second) g/frames-per-second)
  (set (engine :font-size) g/default-font-size)
  (set (engine :font-spacing) g/default-font-spacing)
  
  (c/screen-start engine)
  (game/init engine)
  (c/screen-end))   
