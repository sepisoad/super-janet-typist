(def- profile-dir (string (os/getenv "HOME") "/.super-janet-typist"))
(def- best-score (string profile-dir "/best-score"))
(def- best-streak (string profile-dir "/best-streak"))
(def- last-score (string profile-dir "/last-score"))
(def- last-streak (string profile-dir "/last-streak"))
(def- top-scores (string profile-dir "/top-scores"))

(defn- make-sure-profile-exists [] 
 (when (nil? (os/stat profile-dir))  
  (when (not (os/mkdir profile-dir))
   (error "cannot create profile directory")))

 (when (nil? (os/stat best-score))
  (let [file (file/open best-score :wb)]
   (when (nil? file)
    (error "cannot open/create best score file"))    
   (file/close file)))

 (when (nil? (os/stat best-streak))
  (let [file (file/open best-streak :wb)]
   (when (nil? file)
    (error "cannot open/create best streak file"))
   (file/close file)))

 (when (nil? (os/stat last-score))
  (let [file (file/open last-score :wb)]
   (when (nil? file)
    (error "cannot open/create last score file"))    
   (file/close file)))

 (when (nil? (os/stat last-streak))
  (let [file (file/open last-streak :wb)]
   (when (nil? file)
    (error "cannot open/create last streak file"))
   (file/close file)))

 (when (nil? (os/stat top-scores))
  (let [file (file/open top-scores :wb)]
   (when (nil? file)
    (error "cannot open/create top scores file"))
   (file/close file))))   
    

(defn load [] 
 (make-sure-profile-exists)
 (var res @{})
 (let [last-score-file (file/open last-score :rb)
       last-streak-file (file/open last-streak :rb)
       best-score-file (file/open best-score :rb)
       best-streak-file (file/open best-streak :rb)]

   (when (not (nil? last-score-file))
     (var buf @"") 
     (file/read last-score-file :all buf)         
     (when (empty? buf) (set buf @"0"))
     (set (res :last-score) (scan-number buf))
     (file/close last-score-file))

   (when (not (nil? last-streak-file))
     (var buf @"") 
     (file/read last-streak-file :all buf)         
     (when (empty? buf) (set buf @"0"))
     (set (res :last-streak) (scan-number buf))
     (file/close last-streak-file))

   (when (not (nil? best-score-file))
     (var buf @"") 
     (file/read best-score-file :all buf)         
     (when (empty? buf) (set buf @"0"))
     (set (res :best-score) (scan-number buf))
     (file/close best-score-file))

   (when (not (nil? best-streak-file))
     (var buf @"") 
     (file/read best-streak-file :all buf)         
     (when (empty? buf) (set buf @"0"))
     (set (res :best-streak) (scan-number buf))
     (file/close best-streak-file)))

 res)

(defn update [score streak]
 (make-sure-profile-exists) 
 (let [last-score-file (file/open last-score :wb)
       last-streak-file (file/open last-streak :wb)
       best-score-file (file/open best-score :r+b)
       best-streak-file (file/open best-streak :r+b)]

  (when (not (nil? last-score-file))
   (file/write last-score-file (string score))
   (file/close last-score-file))
   
  (when (not (nil? last-streak-file))
   (file/write last-streak-file (string streak))
   (file/close last-streak-file))

  (when (not (nil? best-score-file))
   (var buf @"") 
   (file/read best-score-file :all buf)   
   (when (empty? buf) (set buf @"0"))
   (when (> score (scan-number buf))
    (file/seek best-score-file :set 0)
    (file/write best-score-file (string score)))
   (file/close best-score-file))

  (when (not (nil? best-streak-file))
   (var buf @"") 
   (file/read best-streak-file :all buf)
   (when (empty? buf) (set buf @"0"))
   (when (> score (scan-number buf))
     (file/seek best-streak-file :set 0) 
     (file/write best-streak-file (string streak)))
   (file/close best-streak-file))))
