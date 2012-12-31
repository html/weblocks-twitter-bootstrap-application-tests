(in-package :weblocks-twitter-bootstrap-application-tests)

#+l(defun ajax-file-field-demonstration-action (&rest args)
  (do-page 
    (make-quickform 
      (defview 
        nil 
        (:caption "Ajax file form field demo" :type form :persistp nil :enctype "multipart/form-data" :use-ajax-p t)
        (file 
          :present-as ajax-file-upload 
          :parse-as (ajax-file-upload 
                      :upload-directory (weblocks-selenium-tests-app::get-upload-directory)
                      :file-name :unique)
          :writer (lambda (value item)))))))

(defvar *test-webapp-prefix*  "/bootstrap-app")

(defwebapp twitter-bootstrap-sample-app
           :prefix *test-webapp-prefix*
           :description "Sample twitter bootstrap application"
           :init-user-session 'weblocks-selenium-tests-app::init-user-session-prototype
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

;(weblocks-selenium-tests-app::define-demo-action "Ajax file upload" #'ajax-file-field-demonstration-action :prototype-engine-p nil)

