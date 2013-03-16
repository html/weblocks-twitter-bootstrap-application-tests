;;;; weblocks-twitter-bootstrap-application.asd

(asdf:defsystem #:weblocks-twitter-bootstrap-application-tests
  :serial t
  :description "Demo app for weblocks-twitter-bootstrap-application"
  :author "Olexiy Zamkoviy <olexiy.z@gmail.com>"
  :license "LLGPL"
  :version (:read-from-file "version.lisp-expr")
  :depends-on (#:weblocks-twitter-bootstrap-application #:weblocks-selenium-tests)
  :components 
  ((:file "package")
   (:file "tests-app-updates" :depends-on ("package"))
   (:file "tests" :depends-on ("tests-app-updates"))))

