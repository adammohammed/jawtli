(in-package :jawtli)

(defun generate-signing-keys ()
  "Sets up internal state of JWT Keys"
  (multiple-value-bind (priv pub) (ironclad:generate-key-pair :rsa :num-bits 4096)
    (setf *pubkey* pub)
    (setf *privkey* priv)))
