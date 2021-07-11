;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
  (gnu)
  (gnu system nss)
  (gnu packages)
  (nongnu packages linux)
  (nongnu system linux-initrd)
)
(use-service-modules
  desktop
  networking
  virtualization
  cups
  pm
  sound
  ssh
  xorg
  docker)
(use-package-modules
  bootloaders
  certs
  emacs
  suckless
  wm
  xorg
  vim
  gtk
  audio
  compton
  pulseaudio
  xdisorg
  version-control
  linux
  web-browsers
  xfce
  file-systems
  gnome
  shells
  cups)

(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"

  Option \"Tapping\" \"on\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"on\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
  EndSection
  Section \"InputClass\"
  Identifier \"Keyboards\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsKeyboard \"on\"
  EndSection")

(define %backlight-udev-rule
  (udev-rule
    "90-backlight.rules"
    (string-append "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
		   "RUN+=\"/run/current-system/profile/bin/chgrp video /sys/class/backlight/%k/brightness\""
		   "\n"
		   "ACTION==\"add\", SUBSYSTEM==\"backlight\", "
		   "RUN+=\"/run/current-system/profile/bin/chmod g+w /sys/class/backlight/%k/brightness\"")))

(define %my-desktop-services
  (modify-services %desktop-services
		   (udev-service-type config =>
				      (udev-configuration (inherit config)
							  (rules (cons %backlight-udev-rule
								       (udev-configuration-rules config)))))
		   (gdm-service-type config =>
				     (gdm-configuration (inherit config)
							(xorg-configuration
							  (xorg-configuration
							    (extra-config (list %xorg-libinput-config))))))
		   (network-manager-service-type config =>
						 (network-manager-configuration (inherit config)
										(vpn-plugins (list network-manager-openvpn))))
;;		   (guix-service-type config =>
;;				      (guix-configuration (inherit config)
;;							  (substitute-urls
;;							    (append (list "https://192.168.0.201/")
;;								    %default-substitute-urls))))
))

;;(define storage-drive
;;  (file-system
;;     (mount-point "/mnt/storage")
;;     (device (uuid "C4106B0E106B06B0" 'ntfs))
;;     (type "ntfs")
;;     (flags '(noatime))))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
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
      (list (specification->package "openbox")
            (specification->package "awesome")
            (specification->package "xterm")
	    tint2
	    thunar
	    git
	    fuse-exfat
	    clipit
	    compton
	    vim
	    ntfs-3g
	    bluez
	    bluez-alsa
	    xf86-input-libinput
	    gvfs
	    (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service tor-service-type)
	    (service tlp-service-type)
	    (service docker-service-type)
	    (service libvirt-service-type
		     (libvirt-configuration
		       (unix-sock-group "libvirt")
		       (tls-port "16555")))
	    (service cups-service-type
		     (cups-configuration
		       (web-interface? #t)
		       (extensions
			 (list cups-filters))))
	    (bluetooth-service #:auto-enable? #t)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %my-desktop-services))
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
