#     ____  __  ____    __    ____________
#    / __ )/ / / / /   / /   / ____/_  __/
#   / __  / / / / /   / /   / __/   / /
#  / /_/ / /_/ / /___/ /___/ /___  / /
# /_____/\____/_____/_____/_____/ /_/

(import ./base :as base)
(import ../globals :as g)
(import ../colors :as color)

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

(defn- do-update [self game time]
  (var tar-x (+ ((self :target) :pos-x) (/ ((self :target) :width) 2)))
  (var tar-y (+ ((self :target) :pos-y) (/ ((self :target) :height) 2)))
  
  (var dif-x (- tar-x (self :pos-x)))
  (var dif-y (- tar-y (self :pos-y)))
  (var dist (math/sqrt (+ (math/pow dif-x 2) (math/pow dif-y 2))))

  (if (> dist 10)
    (do
      (var dir-x (/ dif-x dist))
      (var dir-y (/ dif-y dist))
      
      (set (self :pos-x) (math/floor (+ (self :pos-x) (* dir-x (self :speed-x)))))
      (set (self :pos-y) (math/floor (+ (self :pos-y) (* dir-y (self :speed-y))))))  
    (do
      (set ((self :target) :delete?) true)
      (set (self :delete?) true))))  

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [self game]
  (when (not (self :delete?))
    (c/draw-texture 
      (self :gfx)
      (self :pos-x)
      (self :pos-y)
      color/pink)))

#     __          ____     __
#    / /_  __  __/ / /__  / /_      ____ _
#   / __ \/ / / / / / _ \/ __/_____/ __ `/
#  / /_/ / /_/ / / /  __/ /_/_____/ /_/ /
# /_.___/\__,_/_/_/\___/\__/      \__,_/

(def- bullet
  @{:width 8
    :height 8
    :speed-x 15
    :speed-y 20
    :shooter nil
    :target nil
    :color color/green
    #
    :do-update do-update
    :do-render do-render})    

#    _________  ____ __      ______
#   / ___/ __ \/ __ `/ | /| / / __ \
#  (__  ) /_/ / /_/ /| |/ |/ / / / /
# /____/ .___/\__,_/ |__/|__/_/ /_/
#     /_/

(var gfx nil)

(defn spawn [shooter target]
  (when (nil? gfx)
    (set gfx (c/load-texture g/bullet-image)))
  (merge 
    (base/get-ref) 
    (table/clone bullet)
    @{:shooter shooter 
      :target target
      :gfx gfx
      :pos-x (+ (shooter :pos-x) (/ (shooter :width) 2))
      :pos-y (shooter :pos-y)}))