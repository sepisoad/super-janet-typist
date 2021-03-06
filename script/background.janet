#     ____  ___   ________ ____________  ____  __  ___   ______
#    / __ )/   | / ____/ //_/ ____/ __ \/ __ \/ / / / | / / __ \
#   / __  / /| |/ /   / ,< / / __/ /_/ / / / / / / /  |/ / / / /
#  / /_/ / ___ / /___/ /| / /_/ / _, _/ /_/ / /_/ / /|  / /_/ /
# /_____/_/  |_\____/_/ |_\____/_/ |_|\____/\____/_/ |_/_____/

(import ./colors :as color)

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

# (defn do-update [game] nil)

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn do-render [game]	
  (c/draw-texture 
    (game :background)
    0
    0
    color/gray))
