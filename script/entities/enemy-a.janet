#     _______   __________  _____  __   ___
#    / ____/ | / / ____/  |/  /\ \/ /  /   |
#   / __/ /  |/ / __/ / /|_/ /  \  /  / /| |
#  / /___/ /|  / /___/ /  / /   / /  / ___ |
# /_____/_/ |_/_____/_/  /_/   /_/  /_/  |_|

(import ./base :as base)
(import ../colors :as color)

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

(defn- do-update [self game time]  
  (if (= (self :dir) 'left)
    (set (self :pos-x) 
      (- (self :pos-x) (self :speed-x))) 
    (set (self :pos-x) 
      (+ (self :pos-x) (self :speed-x))))

  (when (< (self :pos-x) 0)
    (set (self :pos-x) 0)
    (set (self :dir) 'right))
  (when (> (+ (self :pos-x) (self :width)) (game :window-width))
    (set (self :pos-x) (- (game :window-width) (self :width))) 
    (set (self :dir) 'left)))   

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [self game] 
  (c/draw-rect (self :pos-x) (self :pos-y) (self :width) (self :height) (self :color)))  

#   ___  ____  ___  ____ ___  __  __      ____ _
#  / _ \/ __ \/ _ \/ __ `__ \/ / / /_____/ __ `/
# /  __/ / / /  __/ / / / / / /_/ /_____/ /_/ /
# \___/_/ /_/\___/_/ /_/ /_/\__, /      \__,_/
#                          /____/

(def- enemy-a
  @{:width 50
    :height 50
    :speed-x 5
    :dir 'left
    :color color/orange
    #
    :do-update do-update
    :do-render do-render})    

#    _________  ____ __      ______
#   / ___/ __ \/ __ `/ | /| / / __ \
#  (__  ) /_/ / /_/ /| |/ |/ / / / /
# /____/ .___/\__,_/ |__/|__/_/ /_/
#     /_/

(defn spawn [x y]
  (merge (base/get-ref) (table/clone enemy-a) @{:pos-x x :pos-y y}))