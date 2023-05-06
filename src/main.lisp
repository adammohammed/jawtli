(defpackage jawtli
  (:use :cl))

(in-package :jawtli)

(defvar *pubkey*
  :doc "Public Key used for verifying the JWT")

(defvar *privkey*
  :doc "Private key used to sign the JWT")

(defvar *hdr*
  "{
    \"alg\": \"RSA256\",
    \"typ\": \"at+jwt\"
}"
  "Default header for the JWT")

(defun generate-signing-keys ()
  "Sets up internal state of JWT Keys"
  (multiple-value-bind (priv pub) (ironclad:generate-key-pair :rsa :num-bits 4096)
    (setf *pubkey* pub)
    (setf *privkey* priv)))

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

(defun generate-jwt (body)
  (let ((b64hdr (urlb64-encode *hdr*))
	(b64payload (urlb64-encode body))
	signable
	signature)
    (setf signable (str:join "." (list b64hdr b64payload)))
    (setf signature (urlb64-encode (flexi-streams:octets-to-string (ironclad:sign-message *privkey* (flexi-streams:string-to-octets signable)))))
    (str:join "." (list signable signature))))
