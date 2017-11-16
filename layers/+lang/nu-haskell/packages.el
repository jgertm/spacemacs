;;; packages.el --- nu-haskell layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Tim Jaeger <tjger@bs>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `nu-haskell-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `nu-haskell/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `nu-haskell/pre-init-PACKAGE' and/or
;;   `nu-haskell/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:
(defconst nu-haskell-packages
  '(company-ghci
    flycheck
    (flycheck-stack :requires flycheck)
    haskell-mode
    ggtags
    ghc))

(defun nu-haskell/init-company-ghc ()
  (use-package company-ghc
    :defer t
    :init (spacemacs|add-company-backends
            :backends (company-ghc company-dabbrev-code company-yasnippet)
            :modes haskell-mode)))

(defun nu-haskell/init-company-ghci ()
  (use-package company-ghci
    :defer t
    :init (spacemacs|add-company-backends
            :backends (company-ghci company-dabbrev-code company-yasnippet)
            :modes haskell-mode)))

(defun nu-haskell/post-init-flycheck ()
  (spacemacs/enable-flycheck 'haskell-mode))

(defun nu-haskell/init-flycheck-stack ()
  (use-package flycheck-stack
    :defer t
    :init (progn
            (require 'flycheck-stack)
            (add-hook 'haskell-mode-hook (lambda ()
                                           (flycheck-select-checker 'stack))))))

(defun nu-haskell/init-haskell-mode ()
  (use-package haskell-mode
    :defer t
    :init
    (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
    :config
    (progn
      (setq haskell-stylish-on-save t
            haskell-interactive-popup-errors nil
            haskell-tags-on-save nil
            haskell-process-auto-import-loaded-modules t
            haskell-process-type 'stack-ghci)

      (defun haskell-process-do-type-on-prev-line ()
        (interactive)
        (haskell-process-do-type 1))

      (spacemacs/set-leader-keys-for-major-mode 'haskell-mode
        "F"  'haskell-mode-stylish-buffer

        "sb" 'haskell-process-load-file
        "sc" 'haskell-interactive-mode-clear
        "ss" 'haskell-interactive-switch

        "ht" 'haskell-process-do-type-on-prev-line
        "hT" 'haskell-process-do
        "hi" 'haskell-process-do-info)
      )))

(defun nu-haskell/post-init-ggtags ()
  (add-hook 'haskell-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun nu-haskell/init-ghc ()
  (use-package ghc
    :defer t))

;;; packages.el ends here
