;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
  (gnu)
  (gnu system nss)
  (gnu packages)
;;  (nongnu packages linux)
;;  (nongnu system linux-initrd)
)
(use-service-modules
  desktop
  dbus
  networking
  virtualization
  sddm
  cups
  pm
  sound
  xorg
  ssh
  docker)
(use-package-modules
  bootloaders
  certs
  xdisorg
  usb-modeswitch
  screen
  fonts
  disk
  guile-xyz
  guile
  emacs-xyz
  emacs
  image
  wm
  terminals
  display-managers
  vim
  gtk
  audio
  compton
  pulseaudio
  version-control
  linux
  xfce
  lxde
  suckless
  file-systems
  gnome
  shells
  cups)

(define %backlight-udev-rule
  (udev-rule
    "90-backlight.rules"
    (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
		   "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
		   "\n"
		   "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
		   "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

(operating-system
;;  (kernel linux)
;;  (initrd microcode-initrd)
;;  (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us" #:model "thinkpad"))
  (host-name "DMC-L")
  (users (cons* (user-account
                  (name "dylan")
                  (comment "Dylan")
                  (group "users")
                  (home-directory "/home/dylan")
                  (supplementary-groups
                    '("wheel" "docker" "netdev" "audio" "video" "kvm" "tty" "input" "realtime" "lp")))
                %base-user-accounts))

  (groups (cons (user-group (system? #t) (name "realtime"))
		%base-groups))
  
  (packages
    (append
      (list sway
	    swayidle
	    swaylock
	    usb-modeswitch
	    screen
	    font-hack
	    fdisk
	    guile-readline
	    guile-colorized
	    dmenu
	    emacs-guix
	    glibc-utf8-locales
	    hikari
	    cagebreak
	    dwl
            alacritty
	    wofi
	    wl-clipboard
	    wob
	    grim
            emacs
	    thunar
	    git
	    lxappearance
	    pavucontrol
	    fuse-exfat
	    vim
	    bluez
	    bluez-alsa
	    gvfs
	    nss-certs)
      %base-packages))
  (services
    (append
      (list (service openssh-service-type
		     (openssh-configuration
		       (port-number 45221)
		       (permit-root-login #f)
		       (public-key-authentication? #t)))
	    (service docker-service-type)
	    (service sddm-service-type)
	    (screen-locker-service hikari "hikari-unlocker")
	    (service libvirt-service-type
		     (libvirt-configuration
		       (unix-sock-group "libvirt")
		       (tls-port "16555")))
	    (bluetooth-service #:auto-enable? #t))
      (modify-services %desktop-services
		       (delete gdm-service-type))))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "F7DB-1326" 'fat32))
             (type "vfat")
	     (flags '(no-atime)))
           (file-system
             (mount-point "/")
             (device
               (file-system-label "my-root"))
             (type "ext4")
	     (flags '(lazy-time))
	     (needed-for-boot? #t))
	   (file-system
	     (mount-point "/gnu")
	     (device
	       (file-system-label "gnu"))
	     (type "ext4")
	     (flags '(lazy-time))
	     (needed-for-boot? #t))
	   (file-system
	     (mount-point "/tmp")
	     (device
	       (file-system-label "tmp"))
	     (type "ext4")
	     (flags '(no-atime))
	     (needed-for-boot? #t))
           %base-file-systems)))