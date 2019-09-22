#    _________    __  _________
#   / ____/   |  /  |/  / ____/
#  / / __/ /| | / /|_/ / __/
# / /_/ / ___ |/ /  / / /___
# \____/_/  |_/_/  /_/_____/

(import ./config :prefix "")
(import ./utils :as util)
(import ./keys :as key)
(import ./colors :as color)
(import ./entities/word :as word)
(import ./entities/player :as player)

(var no-more? false)
(var won? false)
(var cleanup-tick 0)
(var cleanup-time 1)
(var word-tick 0)
(var word-time 1)
(var word-idx 0)
(var seed-flag true)
(var first-word nil)
(var repo-len 0)
(var game
  @{:won? false
    :lost? false
    :player nil
    :objects (array/new 1)
    :word nil})

#        __            _                   __
#   ____/ /___        (_)___  ____  __  __/ /_
#  / __  / __ \______/ / __ \/ __ \/ / / / __/
# / /_/ / /_/ /_____/ / / / / /_/ / /_/ / /_
# \__,_/\____/     /_/_/ /_/ .___/\__,_/\__/
#                         /_/

(defn- do-input []
  (if (c/is-key-pressed key/exit) (set (game :lost?) true)))  

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

(defn- do-update [tick]  
  (var objects (game :objects)) 

  (when (not no-more?)
    (when (> (- tick word-tick) word-time)
      (set word-tick tick)

      (if seed-flag
        (math/seedrandom (math/floor (os/clock)))
        (math/seedrandom (math/floor tick)))

      (set seed-flag (not seed-flag))

      (var pos-x (math/floor (* (game :window-width) (math/random))))
      (var text ((game :repository) word-idx))
      (var size (c/text-size (game :font) text (game :font-size) (game :font-spacing)))      

      (when (>= (+ pos-x (size :x)) (game :window-width))
        (-= pos-x (size :x)))

      (array/concat objects (word/spawn text pos-x -15 (size :x) (size :y)))
      (++ word-idx)
      (when (>= word-idx repo-len)
        (set no-more? true))))

  (set first-word
    (find-index
      (fn [obj] 
        (and 
          (not (obj :delete?)) 
          (= (obj :type) :WORD)))
      objects))

 
  (when (not (nil? first-word))
    (set (game :word) (objects first-word))
    (set ((game :word) :locked?) true)
    (set ((game :player) :target) (game :word)))
        

  (when (> (- tick cleanup-tick) cleanup-time)    
    (set cleanup-tick tick)
    (var idx (- (length objects) 1))
    (while (>= idx 0) 
      (when (= ((objects idx) :delete?) true)
        (array/remove objects idx))
      (-- idx))))

#     _       _ __
#    (_)___  (_) /_
#   / / __ \/ / __/
#  / / / / / / /_
# /_/_/ /_/_/\__/

(defn init [eng]  
  (set game (merge eng game))
  (var objects (game :objects))    
  (set repo-len (length (game :repository)))

  (var plyr (player/spawn (/ (game :window-width) 2) 0 nil))
  (set (game :player) plyr)
  (set (plyr :pos-y) (- (game :window-height) (plyr :height)))
  
  (var time (c/get-time))
    
  (while (and (not (game :won?)) (not (game :lost?)))
    (set time (c/get-time))

    (do-input)    
    (:do-input plyr game)
    
    
    (do-update time)
    (:do-update plyr game time)
    (each obj objects (:do-update obj game time))

    (util/render            
      (each obj objects (:do-render obj game))
      (:do-render plyr game)))

  (when (game :won?)
    (while (not (c/is-key-pressed key/exit))
      (util/render            
        (c/draw-text (game :font) "you win" 100 100 (game :font-size) 1 color/white))))

  (when (game :lost?)
    (while (not (c/is-key-pressed key/exit))
      (util/render            
        (c/draw-text (game :font) "you lost" 100 100 (game :font-size) 1 color/maroon)))))
      