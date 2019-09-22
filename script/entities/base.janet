#     _____ ___  _____ ______
#    / ___/   | / ___// ____/
#   / __  / /| | \__ \/ __/
#  / /_/ / ___ |___/ / /___
# /_____/_/  |_/____/_____/


(def- base
  @{:type :BASE
    :delete? false
    :pos-x 0
    :pos-y 0    
    :speed-x 0
    :speed-y 0
    :width 0
    :height 0
    :color @{ :r 0 :g 0 :b 0 :a 0}
    # methods
    :do-update (fn [self game time] nil)
    :do-render (fn [self game] nil)}) 

(defn get-ref [] (table/clone base))