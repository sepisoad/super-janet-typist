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

 (pp "====load====")
 (pp res)
 (pp "============")

 res)

(defn update [score streak]
  (make-sure-profile-exists)

  (var last-score-val 0)
  (var last-streak-val 0)
  (var best-score-val 0)
  (var best-streak-val 0)

  (let [file (file/open last-score :rb)]
    (when (not (nil? file))
      (set last-score-val (scan-number (file/read file :all)))
      (when (nil? last-score-val) (set last-score-val 0))
      (file/close file)))

  (let [file (file/open last-streak :rb)]
    (when (not (nil? file))
      (set last-streak-val (scan-number (file/read file :all)))
      (when (nil? last-streak-val) (set last-streak-val 0))
      (file/close file)))

  (let [file (file/open best-score :rb)]
    (when (not (nil? file))
      (set best-score-val (scan-number (file/read file :all)))
      (when (nil? best-score-val) (set best-score-val 0))
      (file/close file)))

  (let [file (file/open best-streak :rb)]
    (when (not (nil? file))
      (set best-streak-val (scan-number (file/read file :all)))
      (when (nil? best-streak-val) (set best-streak-val 0))
      (file/close file)))

  # 

  (pp "====update====[input]")
  (pp score)
  (pp streak)
  (pp "====update====[last]")
  (pp last-score-val)
  (pp last-streak-val)
  (pp "====update====[best]")
  (pp best-score-val)
  (pp best-streak-val)
  (pp "============")

  (let [file (file/open last-score :wb)]
    (when (not (nil? file))
      (file/write file (string score))
      (file/close file)))

  (let [file (file/open last-streak :wb)]
    (when (not (nil? file))
      (file/write file (string streak))
      (file/close file)))

  (when (> score best-score-val)
    (let [file (file/open best-score :wb)]
      (when (not (nil? file))
        (file/write file (string score))
        (file/close file))))

  (when (> streak best-streak-val)
    (let [file (file/open best-streak :wb)]
      (when (not (nil? file))
        (file/write file (string streak))
        (file/close file)))))
