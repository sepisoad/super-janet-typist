#    __  ______________   _____
#   / / / /_  __/  _/ /  / ___/
#  / / / / / /  / // /   \__ \
# / /_/ / / / _/ // /______/ /
# \____/ /_/ /___/_____/____/

#                         __
#    ________  ____  ____/ /__  _____
#   / ___/ _ \/ __ \/ __  / _ \/ ___/
#  / /  /  __/ / / / /_/ /  __/ /
# /_/   \___/_/ /_/\__,_/\___/_/

(defmacro render [& commands]
  "renders multiple commands within the same begin and end render pair"
  ~(do 
    (c/begin-draw)
    ,;commands
    (c/end-draw)))

#                            ____
#    ____ ____  ____        / __/________ _____ ___  ___  _____
#   / __ `/ _ \/ __ \______/ /_/ ___/ __ `/ __ `__ \/ _ \/ ___/
#  / /_/ /  __/ / / /_____/ __/ /  / /_/ / / / / / /  __(__  )
#  \__, /\___/_/ /_/     /_/ /_/   \__,_/_/ /_/ /_/\___/____/
# /____/

(defn gen-frames [& numbers] ## todo: convert this to a macro
  (if (or (= (length numbers) 0)
          (not (= (% (length numbers) 4) 0)))  
    (error "gen-frames wrong input arguments count"))
  (var numbers-x numbers)
  (var frames-array @[])
  (var frame nil)
  (while (> (length numbers-x) 0)
    (set frame (take 4 numbers-x))
    (set numbers-x (array/slice numbers-x 4))
    (if (= nil frame) (break)  
      (array/concat frames-array 
        {:x (frame 0) :y (frame 1) :w (frame 2) :h (frame 3)}))) 
  frames-array)  

#    __                   __
#   / /_____        _____/ /_  ____ ___________
#  / __/ __ \______/ ___/ __ \/ __ `/ ___/ ___/
# / /_/ /_/ /_____/ /__/ / / / /_/ / /  (__  )
# \__/\____/      \___/_/ /_/\__,_/_/  /____/

(defn split [str]
  (var len (length str))  
  (var idx 0)
  (var res @[])
  (while (< idx len)
    (array/push res (string/slice str idx (+ idx 1)))
    (++ idx))
  res)
