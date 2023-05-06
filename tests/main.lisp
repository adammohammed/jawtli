(defpackage jawtli/tests/main
  (:use :cl
        :jawtli
        :rove))
(in-package :jawtli/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :jawtli)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
