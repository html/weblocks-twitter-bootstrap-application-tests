(in-package :weblocks-twitter-bootstrap-application-tests)

(def-test-suite weblocks-twitter-bootstrap-application-tests)

(defun sample-dialog-assertions ()
  (do-screen-state-test "bootstrap/shows-dialog" :wait-after-resize 1000)
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

(deftest shows-gridedit ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (delete-all 'test-model)
    (do-click-and-wait "link=Gridedit")
    (do-screen-state-test "bootstrap/gridedit" :wait-after-resize 1000)
    (do-click-and-wait "link=Back")))

(deftest shows-gridedit-with-pagination ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (delete-all 'test-model :store *bootstrap-tests-store*)

    (loop for i from 1 to 30 do 
          (persist-object *bootstrap-tests-store* (make-instance 'test-model :title "Test" :content "Test")))

    (do-click-and-wait "link=Gridedit")

    (do-screen-state-test "bootstrap/gridedit-filled-first-page" :wait-after-resize 1000)

    (do-click-and-wait "css=.next-page")

    (do-screen-state-test "bootstrap/gridedit-filled-last-page" :wait-after-resize 1000)

    (do-click-and-wait "link=Back")))

(deftest adds-items-to-gridedit-and-shows-flash ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (delete-all 'test-model :store *bootstrap-tests-store*)

    (do-click-and-wait "link=Gridedit")

    (do-click-and-wait "name=add")
    (do-screen-state-test "bootstrap/gridedit-add-form-1" :wait-after-resize 1000)
    (do-type "name=title" "Test")
    (do-type "name=content" "Test")
    (do-click-and-wait "name=submit")

    (do-click-and-wait "name=add")
    (do-screen-state-test "bootstrap/gridedit-add-form-2" :wait-after-resize 1000)
    (do-type "name=title" "Test")
    (do-type "name=content" "Test")
    (do-click-and-wait "name=submit")

    (do-screen-state-test "bootstrap/gridedit-add-form-flash-showed" :wait-after-resize 1000)

    (do-click-and-wait "link=Back")))

(deftest shows-choices ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (do-click-and-wait "link=Choices")
    (do-screen-state-test "bootstrap/choices" :wait-after-resize 1000)
    (do-click-and-wait "name=ok")))

(deftest shows-hidden-field ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (do-click-and-wait "link=Hidden field")
    (do-screen-state-test "bootstrap/hidden-field" :wait-after-resize 1000)
    (do-click-and-wait "name=cancel")))

(deftest shows-checkbox-fields ()
  (with-new-or-existing-selenium-session-on-bootstrap-site
    (do-click-and-wait "link=Checkbox fields")
    (do-screen-state-test "bootstrap/checkbox-fields" :wait-after-resize 1000)
    (do-click-and-wait "name=cancel")))
