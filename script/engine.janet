#     _______   _____________   ________
#    / ____/ | / / ____/  _/ | / / ____/
#   / __/ /  |/ / / __ / //  |/ / __/
#  / /___/ /|  / /_/ // // /|  / /___
# /_____/_/ |_/\____/___/_/ |_/_____/

(import ./config :prefix "")
(import ./globals :as g)
(import ./game :as game)

(def engine (merge config @{}))

(defn load-repository [path]
  (var data (slurp path))  
  (string/split "\n" data))

(defn start []
  (c/screen-start config)  
  (set (engine :repository) (load-repository g/repository))
  (set (engine :font) (c/load-font g/default-font g/default-font-size))
  (set (engine :font-size) g/default-font-size)
  (set (engine :font-spacing) 1)
  (game/init engine)
  (c/screen-end))   
