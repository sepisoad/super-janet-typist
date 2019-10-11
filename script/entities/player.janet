#     ____  __    _____  ____________
#    / __ \/ /   /   \ \/ / ____/ __ \
#   / /_/ / /   / /| |\  / __/ / /_/ /
#  / ____/ /___/ ___ |/ / /___/ _, _/
# /_/   /_____/_/  |_/_/_____/_/ |_|

(import ../globals :as g)
(import ../colors :as color)
(import ../keys :as key)
(import ./base :as base)
(import ./bullet :as bullet)

(var wrong-letter-sfx nil)

#        __            _                   __
#   ____/ /___        (_)___  ____  __  __/ /_
#  / __  / __ \______/ / __ \/ __ \/ / / / __/
# / /_/ / /_/ /_____/ / / / / /_/ / /_/ / /_
# \__,_/\____/     /_/_/ /_/ .___/\__,_/\__/
#                         /_/

(defn- do-input [self game]
  (when (not (nil? (self :target)))
    (var key (c/get-key-pressed))
    (var letter (:get-child (game :word)))
    (var last? (:last? (game :word)))
    (var char (letter :value))    
    (when (and (not (nil? char)) (not (= -1 key)))
      (var ucode (c/u/str-to-code (string/ascii-upper char)))
      (var lcode (c/u/str-to-code (string/ascii-lower char)))
      (if (or (= key ucode) (= key lcode))
        (do
          (set (letter :typed?) true)
          (set (game :score) (+ 1 (game :score)))
          (set (game :streak) (+ 1 (game :streak)))
          (array/concat (game :objects) 
            (bullet/spawn self letter last?)))

        (do 
          (c/play-sound wrong-letter-sfx)
          (when (> (game :streak) (game :best-streak))
            (set (game :best-streak) (game :streak)))
          (set (game :streak) 0))))))

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

(defn- do-update [self game time]
  (when (< (self :pos-x) 0)
    (set (self :pos-x) 0))   
  (when (> (+ (self :pos-x) (self :width)) (game :window-width))
    (set (self :pos-x) (- (game :window-width) (self :width)))))

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [self game]  
  (c/draw-texture 
    (self :janet)
    (self :pos-x)
    (self :pos-y)
    color/pink))

#               __        __                        __
#    ________  / /_      / /_____ __________ ____  / /_
#   / ___/ _ \/ __/_____/ __/ __ `/ ___/ __ `/ _ \/ __/
#  (__  )  __/ /_/_____/ /_/ /_/ / /  / /_/ /  __/ /_
# /____/\___/\__/      \__/\__,_/_/   \__, /\___/\__/
#                                    /____/

(defn- set-target [self target]
  (pp target)
  (set (self :target) target))

#            __
#     ____  / /___ ___  _____  _____
#    / __ \/ / __ `/ / / / _ \/ ___/
#   / /_/ / / /_/ / /_/ /  __/ /
#  / .___/_/\__,_/\__, /\___/_/
# /_/            /____/

(def- player
  @{:width 16
    :height 16
    :speed-x 5
    :last-fire 0
    :color color/maroon
    :target nil
    #
    :do-input do-input
    :do-render do-render
    #    
    :set-target set-target})
       
#    _________  ____ __      ______
#   / ___/ __ \/ __ `/ | /| / / __ \
#  (__  ) /_/ / /_/ /| |/ |/ / / / /
# /____/ .___/\__,_/ |__/|__/_/ /_/
#     /_/

(defn spawn [x y target]
  (when (nil? wrong-letter-sfx)
    (set wrong-letter-sfx (c/load-sound g/wrong-letter-wave)))
  (merge 
    (base/get-ref) 
    (table/clone player)
    @{:pos-x (- x (/ (player :width) 2))
      :pos-y y
      :janet (c/load-texture g/janet-image)
      :target target}))