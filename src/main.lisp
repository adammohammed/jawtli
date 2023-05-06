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

(defun generate-jwt (body)
  (let ((b64hdr (urlb64-encode *hdr*))
	(b64payload (urlb64-encode body))
	signable
	signature)
    (setf signable (str:join "." (list b64hdr b64payload)))
    (setf signature (urlb64-encode (flexi-streams:octets-to-string (ironclad:sign-message *privkey* (flexi-streams:string-to-octets signable)))))
    (str:join "." (list signable signature))))
