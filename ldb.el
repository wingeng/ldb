;;
;; ldb Lua Debugger handler for emacs
;;
;; This is a front end to the debugger.lua file to
;; track the filename:line-number markers spat out
;; by the debugger to allow for full screen debugging
;; under emacs
;;
;; Copyright (c) 2014 Wing Eng
;;

;;
;; The marker used to move the overlay-arrow around
;;
(defvar ldb-marker (make-marker))

(defcustom ldb-line-marker-regexp
  "ldb:@\\([^ :]*\\):\\([0-9]+\\)"
  "Regular expression matching lua debug information.
Used to extract the current line and filename being debugged."
  :type 'string
  :group 'lua
  :safe 'stringp)

(defun ldb-clear-arrow ()
  (interactive)
  (setq overlay-arrow-position nil)
  )

;;
;; Test function to find the nearest ldb filename-line-no
;; marker in the current file
;; like this one  'ldb:@./ldb.el:16'
;;
(defun ldb-goto-line ()
  (interactive)
  (save-excursion
    ;; bring cursor to last ldb line location marker
    (goto-char (line-end-position))
    (re-search-backward ldb-line-marker-regexp nil t)

    ;; parse out the ldb line location marker and goto it
    ;; in other buffer
    (let* ((cur-line (buffer-substring 
		      (line-beginning-position) (line-end-position))))

      (if (string-match ldb-line-marker-regexp cur-line)
	  (let ((filename (match-string 1 cur-line))
	      (line-no (string-to-number (match-string 2 cur-line))))

	    (ldb-arrow-at filename line-no)
	    )
	(message "ldb line-marker not found")))
    )
  )

;;
;; Moves the overlay-arrow to the filename:line-no
;; in the other window
;;
(defun ldb-arrow-at (filename line-no)
  (save-excursion
    (if (file-exists-p filename)
	(progn
	  ;; check if we have only one window open, split if so
	  (if (one-window-p)
	      (split-window-below))

	  ;; goto next window and open the filename
	  (other-window 1)
	  (find-file filename)
	  (goto-line line-no)

	  (setq overlay-arrow-position ldb-marker)
	  (set-marker ldb-marker (line-beginning-position))

	  ;; back to original window
	  (other-window -1)
	  )
      (message (concat "filename doesn't exist: " filename)))
    )
  )

(defun ldb-comint-output-filter-function (output)
  "Move overlay arrow to current ldb line in tracked buffer.
Argument OUTPUT is a string with the output from the comint process."
  (when (not (string= output ""))
    (let* ((full-output (ansi-color-filter-apply
                         (buffer-substring comint-last-input-end (point-max))))
	   (line-number)
	   (file-name
	    (with-temp-buffer
	      (insert full-output)

              (goto-char (point-max))

	      (when (re-search-backward ldb-line-marker-regexp nil t)
                (setq line-number (string-to-number
                                   (match-string-no-properties 2)))
		(match-string-no-properties 1)))))
	   (when file-name
	     (ldb-arrow-at file-name line-number))
      )
    )
  )

(defun ldb-add-comint-hook ()
"Adds the comint (shell-mode) hooks to parse
edo-lua debugger filename:line-no markers"
    (interactive)
    (add-hook 'comint-output-filter-functions
	      'ldb-comint-output-filter-function))

(defun ldb-remove-comint-hook ()
"Removes the comint (shell-mode) hooks to parse
edo-lua debugger filename:line-no markers"
    (interactive)
    (ldb-clear-arrow)
    (remove-hook 'comint-output-filter-functions
		 'ldb-comint-output-filter-function))


(ldb-add-comint-hook)
