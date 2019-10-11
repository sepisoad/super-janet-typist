#    _________    __  _________
#   / ____/   |  /  |/  / ____/
#  / / __/ /| | / /|_/ / __/
# / /_/ / ___ |/ /  / / /___
# \____/_/  |_/_/  /_/_____/

(import ./profile :as profile)
(import ./globals :as g)
(import ./utils :as util)
(import ./keys :as key)
(import ./colors :as color)
(import ./background :as background)
(import ./hud :as hud)
(import ./entities/word :as word)
(import ./entities/player :as player)

(var still-more? true)
(var won? false)
(var cleanup-tick 0)
(var cleanup-time 1)
(var word-tick 0)
(var word-time 2)
(var word-idx 0)
(var seed-flag true)
(var first-word nil)
(var repo-len 0)
(var music nil)
(var game @{})

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
  (when (not (c/music-playing? music))
    (c/play-music music))

  (var objects (game :objects)) 

  (when still-more?
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
        (set still-more? false))))

  (set first-word
    (find-index
      (fn [obj] 
        (and 
          (not (obj :dead?)) 
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
  (when (nil? music)
    (set music (c/load-music g/music)))

  (set still-more? true)
  (set won? false)
  (set cleanup-tick 0)
  (set cleanup-time 1)
  (set word-tick 0)
  (set word-time 2)
  (set word-idx 0)
  (set seed-flag true)
  (set first-word nil)
  (set repo-len 0)  
  (set game @{})

  (set game
   @{:won? false    
     :lost? false
     :score 0
     :streak 0
     :best-streak 0
     :hud-height 50
     :player nil
     :objects (array/new 1)
     :word nil})

  (set game (merge eng game))
  (set (game :font) (c/load-font g/default-font g/default-font-size))
  (set (game :background) (c/load-texture g/background-image))
  (set (game :hud) (c/load-texture g/hud-image))
  (var objects (game :objects))    
  (set repo-len (length (game :repository)))

  (var plyr (player/spawn (/ (game :window-width) 2) 1000 nil))
  (set (game :player) plyr)
  (set (plyr :pos-y) (- (game :window-height) (plyr :height) 9))
  
  (var time (c/get-time))
    
  (while (and (not (game :won?)) (not (game :lost?)))
    (set time (c/get-time))

    (do-input)    
    (:do-input plyr game)
    
    
    (do-update time)
    (:do-update plyr game time)
    (each obj objects (:do-update obj game time))

    (util/render
      (background/do-render game)
      (each obj objects (:do-render obj game))      
      (:do-render plyr game)      
      (hud/do-render game)))

  (profile/update (game :score) (game :best-streak))

  (when (game :won?)
    (while (not (c/is-key-released key/select))
      (util/render            
        (c/draw-text (game :font) "You Win" 140 100 20 1 color/red))))

  (when (game :lost?)
    (while (not (c/is-key-released key/select))
      (when (not (c/music-playing? music))
        (c/play-music music))
      (util/render
        (c/draw-text (game :font) "You Lost" 140 100 20 1 color/red)
        (c/draw-text (game :font) "You Scored: " 40 400 20 1 color/light-gray)
        (c/draw-text (game :font) (string (game :score)) 60 420 20 1 color/gold)
        (c/draw-text (game :font) "Your best Streak: " 40 440 20 1 color/light-gray)
        (c/draw-text (game :font) (string (game :best-streak)) 60 460 20 1 color/gold)
        (c/draw-text (game :font) "press enter to continue" 40 600 20 1 color/sky-blue)))))
      