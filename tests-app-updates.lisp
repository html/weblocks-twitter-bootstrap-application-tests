(in-package :weblocks-twitter-bootstrap-application-tests)

(defvar *test-webapp-prefix*  "/bootstrap-app")

(defstore *bootstrap-tests-store* :memory)

(defwebapp twitter-bootstrap-sample-app
           :prefix *test-webapp-prefix*
           :description "Weblocks with twitter bootstrap demo"
           :init-user-session 'init-user-session-bootstrap
           :subclasses (weblocks-twitter-bootstrap-application:twitter-bootstrap-webapp)
           :autostart t                   
           :ignore-default-dependencies nil 
           :debug t)

(defmethod render-page-body :after ((app twitter-bootstrap-sample-app) body-string)
  (weblocks-selenium-tests-app::render-apps-list))

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
    (setf widget (make-instance 'gridedit :data-class 'test-model :class-store *bootstrap-tests-store*))
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
(define-bootstrap-demo-action "Choices" 
                              (lambda (&rest args)
                                (do-choice "Test choice" '((:ok . "Ok") (:great . "Great") (:good . "Good")))))

(defun empty-writer (&rest args)
  (declare (ignore args)))

(defun hidden-field-demonstration-action (&rest args)
  (do-page 
    (make-quickform 
      (defview 
        nil 
        (:caption "Form with hidden field" :type form :persistp nil)
        (some-field 
          :present-as hidden 
          :writer #'empty-writer)))))

(define-bootstrap-demo-action "Hidden field" #'hidden-field-demonstration-action)

(defun checkbox-field-demonstration-action (&rest args)
  (do-page 
    (make-quickform 
      (defview 
        nil 
        (:caption "Form with checkbox fields" :type form :persistp nil)
        (some-field 
          :present-as checkbox 
          :writer #'empty-writer)
        (some-other-field 
          :present-as checkbox 
          :writer #'empty-writer)
        (some-another-field 
          :present-as checkbox 
          :writer #'empty-writer)))))

(define-bootstrap-demo-action "Checkbox fields" #'checkbox-field-demonstration-action)

(defun navbar-selector-demonstration-action (&rest args)
  (let ((widget))
    (setf widget (make-instance 
                   'composite 
                   :widgets (list
                              (lambda (&rest args)
                                (with-html 
                                  (:br)))
                              (make-navbar-selector "test-selector"
                                                    (list "First pane" "First tab" nil)
                                                    (list "Second pane" "Second tab" "second")
                                                    (list "Third pane" "Third tab" "third"))
                              (lambda (&rest args)
                                (with-html 
                                  (render-link (lambda (&rest args)
                                                 (answer widget t))
                                               "back"))))))
    (do-page widget)))

(define-bootstrap-demo-action "Navbar selector" #'navbar-selector-demonstration-action)

(defparameter *bootstrap-site-url* "http://localhost:5555/bootstrap-app")

(defmacro with-new-or-existing-selenium-session-on-bootstrap-site (&body body)
  `(let ((*site-url* *bootstrap-site-url*))
     (with-new-or-existing-selenium-session ,@body)))
