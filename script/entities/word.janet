#  _       ______  ____  ____
# | |     / / __ \/ __ \/ __ \
# | | /| / / / / / /_/ / / / /
# | |/ |/ / /_/ / _, _/ /_/ /
# |__/|__/\____/_/ |_/_____/

(import ./base :as base)
(import ./letter :as letter)
(import ../colors :as color)
(import ../utils :as u)

(def resize-tick 0)

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

(defn- do-update [self game time]
  (when (self :locked?)
    (if (self :grow?)
      (do
        (set (self :width-ex) (+ (self :width-ex) (self :width-gr)))
        (set (self :height-ex) (+ (self :height-ex) (self :height-gr))))
      (do
        (set (self :width-ex) (- (self :width-ex) (self :width-gr)))
        (set (self :height-ex) (- (self :height-ex) (self :height-gr)))))
    (when
      (or
        (>= (self :width-ex) (self :width-max))
        (>= (self :height-ex) (self :height-max)))
      (set (self :grow?) false))
    (when
      (or
        (< (self :width-ex) (self :width))
        (< (self :height-ex) (self :height)))
      (set (self :grow?) true)))

  (when (not (self :produced))
    (set (self :produced) true)
    (var arr (u/split (self :letters)))
    (var idx 0)
    (each l arr
      (array/push (self :children) (letter/spawn (+ (* 15 idx) (self :pos-x)) (self :pos-y) l))
      (++ idx))
    (each child (self :children)
      (array/push (game :objects) child)))

  (if (> (self :pos-y) (- (game :window-height) (self :height)))    
    (each child (self :children)
      # (set (game :lost?) true)
      (set (self :delete?) true)
      (set (child :visible) false)
      (set (child :delete?) true))
    (do            
      (set (self :pos-y) (+ (self :pos-y) (self :speed-y)))
      (each child (self :children)
        (set (child :pos-y) (self :pos-y))))))

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [self game]
  (when (and (self :locked?) (not (self :delete?)))
    (when (self :grow?)
      (var diff (math/floor (/ (- (self :width-ex) (self :width)) 2)))
      (c/draw-rect
        (- (self :pos-x) diff)
        (- (self :pos-y) diff)
        (+ (self :width-ex) diff)
        (+ (self :height-ex) diff)
        (self :color)))
    (when (not (self :grow?))
      (var diff (math/ceil (/ (- (self :width) (self :width-ex)) 2)))
      (c/draw-rect
        (+ (self :pos-x) diff)
        (+ (self :pos-y) diff)
        (- (self :width-ex) diff)
        (- (self :height-ex) diff)
        (self :color)))))

#                __             __    _ __    __
#    ____ ____  / /_      _____/ /_  (_) /___/ /
#   / __ `/ _ \/ __/_____/ ___/ __ \/ / / __  /
#  / /_/ /  __/ /_/_____/ /__/ / / / / / /_/ /
#  \__, /\___/\__/      \___/_/ /_/_/_/\__,_/
# /____/

(defn get-child [self]
  (var idx (find-index (fn [child] (not (child :hit?))) (self :children)))
  
  (if (number? idx)
    ((self :children) idx)
    nil))

#                           __
#  _      ______  _________/ /
# | | /| / / __ \/ ___/ __  /
# | |/ |/ / /_/ / /  / /_/ /
# |__/|__/\____/_/   \__,_/

(def word
  @{:type :WORD
    :produced? false
    :speed-y 1
    :locked? false    
    :color color/red
    #
    :do-update do-update
    :do-render do-render
    :get-child get-child})

#    _________  ____ __      ______
#   / ___/ __ \/ __ `/ | /| / / __ \
#  (__  ) /_/ / /_/ /| |/ |/ / / / /
# /____/ .___/\__,_/ |__/|__/_/ /_/
#     /_/

(defn spawn [letters x y w h]
  (merge 
    (base/get-ref) 
    (table/clone word)
    @{:pos-x x 
      :pos-y y
      :width w
      :height h
      :width-ex w
      :height-ex h
      :width-gr 2
      :height-gr 1
      :width-max (+ w 20)
      :height-max (+ h 10)
      :grow? true
      :letters letters
      :children (array/new 1)}))

# WIERD PROBLEM:
# i used to use :children @[] for word object, but it would somehow get shared
# between all word objects, finally using (array/new 1) the problem got fixed

# wheneve i mistakenly use a value as function I get a verrrrry none helpful
# error message e.g. when I used color/red as (color/red) it took me about
# 15 mins to finally get it right