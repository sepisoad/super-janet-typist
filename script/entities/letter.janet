#     __    ____________________________
#    / /   / ____/_  __/_  __/ ____/ __ \
#   / /   / __/   / /   / / / __/ / /_/ /
#  / /___/ /___  / /   / / / /___/ _, _/
# /_____/_____/ /_/   /_/ /_____/_/ |_|

(import ./base :as base)
(import ../utils :as u)
(import ../colors :as color)

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [self game]
  (when (and (not (self :delete?)) (self :visible))
    (if (self :typed?)
      (c/draw-text 
        (game :font) 
        (self :value) 
        (self :pos-x) 
        (self :pos-y) 
        (self :height) 
        1 # spacing !!!
        color/gray)
      (c/draw-text 
        (game :font) 
        (self :value) 
        (self :pos-x) 
        (self :pos-y) 
        (self :height) 
        1 # spacing !!!
        color/white))))

#     __     __  __
#    / /__  / /_/ /____  _____
#   / / _ \/ __/ __/ _ \/ ___/
#  / /  __/ /_/ /_/  __/ /
# /_/\___/\__/\__/\___/_/

(def- letter
  @{:width 15 # is not used !!!
    :height 20    
    :visible true
    #
    :do-render do-render})

#    _________  ____ __      ______
#   / ___/ __ \/ __ `/ | /| / / __ \
#  (__  ) /_/ / /_/ /| |/ |/ / / / /
# /____/ .___/\__,_/ |__/|__/_/ /_/
#     /_/

(defn spawn [x y v]  
  (merge (base/get-ref) 
         (table/clone letter) 
         @{:pos-x x
           :pos-y y
           :typed? false
           :value v}))
