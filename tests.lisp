(in-package :weblocks-twitter-bootstrap-application-tests)

(def-test-suite weblocks-twitter-bootstrap-application-tests)

(defun sample-dialog-assertions ()
  (is (string= "Dialog title" (do-get-text "css=.modal-header h3")))
  (is (string= "Some dialog content" (do-get-text "css=div.modal-body p")))
  (is (string= "Close dialog" (do-get-text "css=div.modal-body a"))))

(deftest shows-dialog ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (do-click-and-wait "link=Dialog")
    (sample-dialog-assertions)
    (do-click-and-wait "link=Close dialog")))

(deftest shows-dialog-after-page-reloading ()
  (with-new-or-existing-selenium-session-on-bootstrap-site 
    (do-click-and-wait "link=Dialog")
    (sample-dialog-assertions)
    (do-refresh)
    (do-open-and-wait *site-url*)
    (sleep 1) ; waiting for dialog to do all effects
    (sample-dialog-assertions)
    (do-click-and-wait "link=Close dialog")))

(deftest does-not-display-hidden-field ()
  (with-new-or-existing-selenium-session-on-bootstrap-site 
    (do-click-and-wait "link=Hidden field")
    (handler-case 
      (progn 
        (do-get-text "css=.some-field")
        (error "There should not be div with class some-field"))
      (execution-error ()))
    (do-click-and-wait "name=cancel")))
