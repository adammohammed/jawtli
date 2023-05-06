(in-package :jawtli)

(defun urlb64-decode (s)
  "Base64 URLsafe decode of S."
  (let ((string s)
	(padding-length (mod (length s) 4)))
    (setf string (str:replace-all "-" "+" string))
    (setf string (str:replace-all "_" "/" string))
    (cond ((= 2 padding-length) (setf string (str:concat string "==")))
	  ((= 3 padding-length) (setf string (str:concat string "="))))
    (cl-base64:base64-string-to-string string)))

(defun urlb64-encode (s)
  "Base64 URLsafe encode of S."
  (let ((string (cl-base64:string-to-base64-string s)))
    (setf string (str:replace-all "=" "" string))
    (setf string (str:replace-all "+" "-" string))
    (setf string (str:replace-all "/" "_" string))
    string))
