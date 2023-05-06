(defsystem "jawtli"
  :version "0.0.1"
  :author "Adam Mohammed <adam@fixergrid.net>"
  :license ""
  :depends-on ("ironclad"
               "cl-base64"
               "str")
  :components ((:module "src"
                :components
                ((:file "main")
		 (:file "keys")
		 (:file "encoding")
		 (:file "webui"))))
  :description "A JWT building library"
  :in-order-to ((test-op (test-op "jawtli/tests"))))

(defsystem "jawtli/tests"
  :author "Adam Mohammed <adam@fixergrid.net>"
  :license ""
  :depends-on ("jawtli"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for jawtli"
  :perform (test-op (op c) (symbol-call :rove :run c)))
