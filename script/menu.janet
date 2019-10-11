#     __  __________   ____  __
#    /  |/  / ____/ | / / / / /
#   / /|_/ / __/ /  |/ / / / /
#  / /  / / /___/ /|  / /_/ /
# /_/  /_/_____/_/ |_/\____/

(import ./globals :as g)
(import ./profile :as profile)
(import ./utils :as util)
(import ./keys :as key)
(import ./colors :as color)
(import ./game :as game)
(import ./background :as background)

#        __            _                   __
#   ____/ /___        (_)___  ____  __  __/ /_
#  / __  / __ \______/ / __ \/ __ \/ / / / __/
# / /_/ / /_/ /_____/ / / / / /_/ / /_/ / /_
# \__,_/\____/     /_/_/ /_/ .___/\__,_/\__/
#                         /_/

(defn- do-input [menu]
  (if (c/is-key-pressed key/select) (set (menu :start?) true))
  (if (c/is-key-pressed key/exit) (set (menu :quit?) true)))

#        __                            __      __
#   ____/ /___        __  ______  ____/ /___ _/ /____
#  / __  / __ \______/ / / / __ \/ __  / __ `/ __/ _ \
# / /_/ / /_/ /_____/ /_/ / /_/ / /_/ / /_/ / /_/  __/
# \__,_/\____/      \__,_/ .___/\__,_/\__,_/\__/\___/
#                       /_/

(defn- do-update [tick] nil)

#        __                                __
#   ____/ /___        ________  ____  ____/ /__  _____
#  / __  / __ \______/ ___/ _ \/ __ \/ __  / _ \/ ___/
# / /_/ / /_/ /_____/ /  /  __/ / / / /_/ /  __/ /
# \__,_/\____/     /_/   \___/_/ /_/\__,_/\___/_/

(defn- do-render [menu]
  (util/render
  	(background/do-render menu)
  	(c/draw-text (menu :font) "a game made for\n lisp game jam\n    (GPLv3)" 100 10 16 1 color/dark-gray)
  	(c/draw-text (menu :font) "press       to start" 60 100 20 1 color/white)
  	(c/draw-text (menu :font) "      enter         " 60 100 20 1 color/sky-blue)
  	(c/draw-text (menu :font) "press        to quit" 60 140 20 1 color/white)
  	(c/draw-text (menu :font) "      escape        " 60 140 20 1 color/red)
  	(c/draw-text (menu :font) "A game by:" 60 200 20 1 color/light-gray)
  	(c/draw-text (menu :font) "		@sepisoad" 60 220 20 1 color/gold)  	
  	(c/draw-text (menu :font) "GFX by:" 60 240 20 1 color/light-gray)
  	(c/draw-text (menu :font) "		@surt" 60 260 20 1 color/gold)
  	(c/draw-text (menu :font) "SFX and Music by:" 60 280 20 1 color/light-gray)
  	(c/draw-text (menu :font) "		@sepisoad" 60 300 20 1 color/gold)

  	(c/draw-text (menu :font) "Follow me on twitter:" 60 340 20 1 color/gray)
  	(c/draw-text (menu :font) "		@sepisoad" 60 360 20 1 color/dark-gray)
  	(c/draw-text (menu :font) "Follow me on github:" 60 380 20 1 color/gray)
  	(c/draw-text (menu :font) "		@sepisoad" 60 400 20 1 color/dark-gray)

  	(c/draw-text (menu :font) "License: GPLv3" 60 620 20 1 color/purple)
		(when (not (empty? (menu :info)))
			(c/draw-text (menu :font) (string "best score: " ((menu :info) :best-score)) 60 480 20 1 color/dark-gray)
			(c/draw-text (menu :font) (string "best streak: " ((menu :info) :best-streak)) 60 500 20 1 color/dark-gray)
			(c/draw-text (menu :font) (string "last score: " ((menu :info) :last-score)) 60 520 20 1 color/dark-gray)
			(c/draw-text (menu :font) (string "last streak: " ((menu :info) :last-streak)) 60 540 20 1 color/dark-gray))))

#    ____ ___  ___  ____  __  __
#   / __ `__ \/ _ \/ __ \/ / / /
#  / / / / / /  __/ / / / /_/ /
# /_/ /_/ /_/\___/_/ /_/\__,_/

(var menu nil)

#     _       _ __
#    (_)___  (_) /_
#   / / __ \/ / __/
#  / / / / / / /_
# /_/_/ /_/_/\__/

(defn init [eng]
	(when (nil? menu)
		(set menu @{})
		(set (menu :start?) false)
		(set (menu :quit?) false)
		(set (menu :info) (profile/load))
		(set (menu :font) (c/load-font g/default-font g/default-font-size))
		(set (menu :background) (c/load-texture g/background-image)))

  (var time 0) 
  
  (while (not (menu :quit?))  
	  (while (and (not (menu :start?)) (not (menu :quit?)))
	    (set time (c/get-time))
	    (do-input menu)
	    (do-update time)
	    (do-render menu))	
		(when (menu :start?)
			(set (menu :quit?) false)
			(set (menu :start?) false)
			(game/init eng))))