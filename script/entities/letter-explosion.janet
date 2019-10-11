#     __    ____________________________     _______  __ ____  __    ____  _____ ________  _   __
#    / /   / ____/_  __/_  __/ ____/ __ \   / ____/ |/ // __ \/ /   / __ \/ ___//  _/ __ \/ | / /
#   / /   / __/   / /   / / / __/ / /_/ /  / __/  |   // /_/ / /   / / / /\__ \ / // / / /  |/ /
#  / /___/ /___  / /   / / / /___/ _, _/  / /___ /   |/ ____/ /___/ /_/ /___/ // // /_/ / /|  /
# /_____/_____/ /_/   /_/ /_____/_/ |_|  /_____//_/|_/_/   /_____/\____//____/___/\____/_/ |_/

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
  (when (not (self :sounded?))
    (set (self :sounded?) true)
    (c/play-sound (self :sfx)))
  (if (>= (self :current-frame) (self :max-frames))
    (set (self :delete?) true)
    (when (> (- time (self :last-tick)) (self :frames-speed))
      (set (self :last-tick) time)
      (set (self :current-frame) (+ 1 (self :current-frame))))))
#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [self game]
  (when (not (self :delete?))
    (c/draw-sprite-ex
      (self :gfx)
      {:x (* (self :current-frame) (self :width))
       :y 0 
       :w (self :width)
       :h (self :height)}
      {:x ((self :letter) :pos-x) 
       :y ((self :letter) :pos-y)
       :w (* 2.5 (self :width))
       :h (* 2.5 (self :height))}
      {:x -1 :y -3}
      0
      color/purple)))

#     __     __  __                                  __           _
#    / /__  / /_/ /____  _____      ___  _  ______  / /___  _____(_)___  ____
#   / / _ \/ __/ __/ _ \/ ___/_____/ _ \| |/_/ __ \/ / __ \/ ___/ / __ \/ __ \
#  / /  __/ /_/ /_/  __/ /  /_____/  __/>  </ /_/ / / /_/ (__  ) / /_/ / / / /
# /_/\___/\__/\__/\___/_/         \___/_/|_/ .___/_/\____/____/_/\____/_/ /_/
#                                         /_/

(def- letter-explosion
  @{:frames-speed 0.02
    :current-frame 0
    :width 6
    :height 6
    :max-frames 10
    :last-tick 0
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
(var sfx nil)

(defn spawn [letter]
  (when (nil? gfx)
    (set gfx (c/load-texture g/letter-explosion-image)))
  (when (nil? sfx)
    (set sfx (c/load-sound g/letter-explosion-wave)))

  (merge 
    (base/get-ref)
    (table/clone letter-explosion)
    @{:letter letter       
      :gfx gfx
      :sfx sfx
      :sounded? false}))      