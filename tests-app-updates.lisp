(in-package :weblocks-twitter-bootstrap-application-tests)

(defvar *test-webapp-prefix*  "/bootstrap-app")

(defstore *bootstrap-tests-store* :memory)

(defwebapp twitter-bootstrap-sample-app
           :prefix *test-webapp-prefix*
           :description "Sample twitter bootstrap application"
           :init-user-session 'init-user-session-bootstrap
           :subclasses (weblocks-twitter-bootstrap-application:twitter-bootstrap-webapp)
           :autostart t                   
           :ignore-default-dependencies nil 
           :debug t)

(flet ((prepend-webapp-path (value)
         (format nil "~A~A" *test-webapp-prefix* value)))

  (push (hunchentoot:create-static-file-dispatcher-and-handler 
          (prepend-webapp-path "/pub/scripts/jquery-seq.js")
          (merge-pathnames 
            "jquery-seq/jquery-seq.js"
            (asdf-system-directory :weblocks-twitter-bootstrap-application-tests))) weblocks::*dispatch-table*) 

  (push (hunchentoot:create-static-file-dispatcher-and-handler 
          (prepend-webapp-path "/pub/scripts/weblocks-jquery.js")
          (merge-pathnames 
            "weblocks-jquery/weblocks-jquery.js"
            (asdf-system-directory :weblocks-twitter-bootstrap-application-tests))) weblocks::*dispatch-table*)) 

(define-demo-action 
  "Bootstrap theme demos" 
  (lambda (&rest args)
    (redirect *test-webapp-prefix* :defer nil))
  :prototype-engine-p nil)

(defvar *demo-actions* nil)

(defun define-bootstrap-demo-action (link-name action &key (prototype-engine-p t) (jquery-engine-p t))
  "Used to add action to demo list, 
   :prototype-engine-p and :jquery-engine-p keys 
   are responsive for displaying action in one or both demo applications"
  (push (list link-name action prototype-engine-p jquery-engine-p) *demo-actions*))

(define-bootstrap-demo-action "Dialog" #'weblocks-selenium-tests-app::dialog-demonstration-action)

(defclass test-model ()
  ((id) 
   (title :accessor test-model-title :initarg :title) 
   (content :accessor test-model-content :initarg :content)))

(defun add-demo-records-to-test-model ()
  (loop for i from 1 to 5 do 
        (persist-object 
          *bootstrap-tests-store* 
          (make-instance 
            'test-model
            :title (format nil "Title-~A" i)
            :content (format nil "Content-~A" i))))) 

(defun init-user-session-bootstrap (root &optional (add-demo-records t))
  (when add-demo-records 
    (add-demo-records-to-test-model))
  (setf (widget-children root)
        (list (lambda (&rest args)
                (with-html
                  (:h1 "Twitter bootstrap for weblocks demo")
                  (:ul
                    (loop for (link-title action) in (reverse *demo-actions*) 
                          do
                          (cl-who:htm (:li (render-link action link-title))))))))))

(defun gridedit-demonstration-action (&rest args)
  (let* ((widget))
    (setf widget (make-instance 'gridedit :data-class 'test-model))
    (do-page 
      (list 
        (lambda (&rest args)
          (with-html 
            (:h1 "Gridedit")))
        widget 
        (lambda (&rest args)
          (render-link 
            (lambda (&rest args)
              (init-user-session-bootstrap (root-widget) nil))
            "Back"))))))

(define-bootstrap-demo-action "Gridedit" #'gridedit-demonstration-action)

