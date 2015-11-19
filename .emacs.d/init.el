;; /This/ file (~init.el~) that you are reading
;; should be in this folder
;; (add-to-list 'load-path "~/.emacs.d/")
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; Package Manager
;; See ~Cask~ file for its configuration
;; https://github.com/cask/cask
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Keeps ~Cask~ file in sync with the packages
;; that you install/uninstall via ~M-x list-packages~
;; https://github.com/rdallasgray/pallet
(require 'pallet)

;; Root directory
(setq root-dir (file-name-directory
                (or (buffer-file-name) load-file-name)))

;; Theme
;; https://github.com/bbatsov/zenburn-emacs
(load-theme 'zenburn t)
(set-cursor-color "firebrick")

;; don't use default keybindings from jedi.el; keep C-. free
(setq jedi:setup-keys nil)
(setq jedi:tooltip-method nil)
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)

(defvar jedi:goto-stack '())
(defun jedi:jump-to-definition ()
  (interactive)
  (add-to-list 'jedi:goto-stack
               (list (buffer-name) (point)))
  (jedi:goto-definition))
(defun jedi:jump-back ()
  (interactive)
  (let ((p (pop jedi:goto-stack)))
    (if p (progn
            (switch-to-buffer (nth 0 p))
            (goto-char (nth 1 p))))))

;; redefine jedi's C-. (jedi:goto-definition)
;; to remember position, and set C-, to jump back
(add-hook 'python-mode-hook
          '(lambda ()
             (global-set-key (kbd "M-,") 'jedi:jump-to-definition)
             (global-set-key (kbd "M-0") 'jedi:jump-back)
             (local-set-key (kbd "C-c d") 'jedi:show-doc)
             (local-set-key (kbd "C-<tab>") 'jedi:complete)))

;; Font
;; https://www.mozilla.org/en-US/styleguide/products/firefox-os/typeface/#download-primary
(set-frame-font "Fira Mono OT-14" nil t)

;; Don't show startup screen
(setq inhibit-startup-screen t)

;; Show keystrokes
(setq echo-keystrokes 0.02)

;; Path
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Git
(require 'magit)
(eval-after-load 'magit
  (progn '(global-set-key (kbd "C-x g") 'magit-status)))

;; flx-ido completion system, recommended by Projectile
(require 'flx-ido)
(flx-ido-mode 1)
;; change it if you have a fast processor.
(setq flx-ido-threshhold 1000)

;; Project management
(require 'ack-and-a-half)
(require 'projectile)
(projectile-global-mode)

;; Snippets
;; https://github.com/capitaomorte/yasnippet
(require 'yasnippet)
(yas-load-directory (concat root-dir "snippets"))
(yas-global-mode 1)

;; Python editing
(require 'elpy)
(elpy-enable)
(elpy-use-ipython)

;; (add-to-list 'load-path "~/.emacs.d/ergoemacs-mode")
(require 'ergoemacs-mode)
(ergoemacs-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode t)
 '(line-number-mode nil)
 '(org-CUA-compatible nil)
 '(org-replace-disputed-keys nil)
 '(recentf-mode t)
 '(shift-select-mode nil)
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "default" :foundry "default" :slant normal :weight normal :height 1 :width normal)))))

;; use Shift+arrow_keys to move cursor around split panes
(windmove-default-keybindings)

;; when cursor is on edge, move to the other side, as in a toroidal space
(setq windmove-wrap-around t )

;; Disable autosave
(setq auto-save-default nil)
(add-hook 'python-mode-hook 'hs-minor-mode)

;; Save temporary files in one location
(setq auto-save-file-name-transforms
          `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;; Save last position of edit
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saved-places")
