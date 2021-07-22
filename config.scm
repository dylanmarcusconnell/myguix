(use-modules
  (gnu)
  (gnu system nss)
  (gnu packages)
  (nongnu packages linux)
  (nongnu system linux-initrd)
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
  audio
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
    "97-backlight.rules"
    (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
		   "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
		   "\n"
		   "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
		   "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

(operating-system
  (kernel linux)
  (initrd base-initrd)
  (firmware (list linux-firmware))
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
	    ntfs-3g
	    guile-readline
	    guile-colorized
	    dmenu
	    emacs-guix
	    glibc-utf8-locales
	    hikari
	    cagebreak
	    dwl
            alacritty
	    dosfstools
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
	    (service mpd-service-type
		     (mpd-configuration
		       (user "dylan")
		       (music-dir "/mnt/storage/Music")
		       (port "6666")
		       (outputs
			 (list (mpd-output
				 (name "MPD")
				 (type "pulse")
				 (enabled? #t)
				 (always-on? #t))))))
	    (service sddm-service-type)
	    (udev-rules-service 'brightness %backlight-udev-rule)
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
             (device (uuid "2C44-284A" 'fat32))
             (type "vfat")
	     (flags '(no-atime)))
           (file-system
             (mount-point "/")
             (device
               (file-system-label "my-root"))
             (type "btrfs")
	     (flags '(lazy-time))
	     (needed-for-boot? #t))
	   (file-system
	     (mount-point "/gnu")
	     (device
	       (file-system-label "gnu"))
	     (type "btrfs")
	     (flags '(lazy-time))
	     (needed-for-boot? #t))
	   (file-system
	     (mount-point "/tmp")
	     (device
	       (file-system-label "tmp"))
	     (type "btrfs")
	     (flags '(no-atime))
	     (needed-for-boot? #t))
;;	   (file-system
;;	     (mount-point "/mnt/storage")
;;	     (device
;;	       (uuid "BC8209EC8209ABC8" 'ntfs))
;;	     (type "ntfs")
;;	     (needed-for-boot? #f))
           %base-file-systems))
  (swap-devices
    (list (file-system-label "swap"))))
