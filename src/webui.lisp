
(in-package :jawtli)

(defvar *webui* (make-instance 'ningle:app)
  "WebUI application")

(defun request-body ()
  (let ((r (lack.request:request-content ningle:*request*)))
    (flexi-streams:octets-to-string r)))

(defun form-params (body)
  (let ((uri (quri:uri (str:concat "?" body))))
    (quri:uri-query-params uri)))

(defun webui/home (params)
  (declare (ignore params))
  (render #P"index.html"))

(defun webui/token-submit (params)
  (declare (ignore params))
  (let* ((body (form-params (request-body)))
	 (subject (cdar body))
	 (scopes (cdadr body))
	 (jwt-payload (format nil "{\"sub\": \"~a\", \"scp\": \"~a\"}" subject scopes))
	 (token (generate-jwt jwt-payload)))
    (render #P"token-resp.html" `(:subject ,subject :scopes ,scopes :token ,token))))




(setf (ningle:route *webui* "/") #'webui/home)
(setf (ningle:route *webui* "/create-token" :method :post) #'webui/token-submit)
(djula:add-template-directory  #P"~/repos/lisp/jawtli/templates/")

(defparameter *template-registry* (make-hash-table :test 'equal))

(defun render (template-path &optional data)
  (let ((template (gethash template-path *template-registry*)))
    (unless template
      (setf template (djula:compile-template* (princ-to-string template-path)))
      (setf (gethash template-path *template-registry*) template))
    (apply #'djula:render-template* template nil data)))

(defun webui/start-app (&optional (host "127.0.0.1") (port 9090))
  (clack:clackup *webui* :address host :port port))
