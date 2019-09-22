#     ____  __    _____  ____________
#    / __ \/ /   /   \ \/ / ____/ __ \
#   / /_/ / /   / /| |\  / __/ / /_/ /
#  / ____/ /___/ ___ |/ / /___/ _, _/
# /_/   /_____/_/  |_/_/_____/_/ |_|

(import ../colors :as color)
(import ../keys :as key)
(import ./base :as base)
(import ./bullet-a :as bullet-a)

#        __            _                   __
#   ____/ /___        (_)___  ____  __  __/ /_
#  / __  / __ \______/ / __ \/ __ \/ / / / __/
# / /_/ / /_/ /_____/ / / / / /_/ / /_/ / /_
# \__,_/\____/     /_/_/ /_/ .___/\__,_/\__/
#                         /_/

(defn- do-input [self game]
  (when (not (nil? (self :target)))
    (let [key (c/get-key-pressed)
          char ((:get-child (game :word)) :value)
          ucode (c/u/str-to-code (string/ascii-upper char))
          lcode (c/u/str-to-code (string/ascii-lower char))]      
      (when (and 
              (not (= -1 key)) 
              (or 
                (= key ucode) 
                (= key lcode)))

        (var child (:get-child (game :word)))

        (when (not (nil? child))
          # (debug/break)
          (set (child :hit?) true)
          # (debug/break)
          (array/concat (game :objects) 
            (bullet-a/spawn self (game :word))))))))

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
  (c/draw-rect (self :pos-x) (self :pos-y) (self :width) (self :height) (self :color)))

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
  @{:width 20
    :height 20
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
  (merge 
    (base/get-ref) 
    (table/clone player)
    @{:pos-x (- x (/ (player :width) 2))
      :pos-y y
      :target target}))