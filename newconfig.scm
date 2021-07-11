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
  sddm
  sound
  ssh
  xorg
  docker)
(use-package-modules
  bootloaders
  certs
  emacs
  libusb
  suckless
  wm
  nfs
  xorg
  vim
  gtk
  audio
  compton
  pulseaudio
  xdisorg
  version-control
  linux
  xfce
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

(define %my-desktop-services
  (cons* (service sddm-service-type)
	 (simple-service 'mtp udev-service-type
			 (list libmtp))
	 (service sane-service-type)
	 polkit-wheel-service
	 (simple-service 'mount-setuid-helpers setuid-program-service-type
			 (list (file-append nfs-utils "/sbin/mount.nfs")
			       (file-append ntfs-3g "/sbin/mount.ntfs-3g")))
	 (fontconfig-file-system-service)
	 (service network-manager-service-type)
	 (service wpa-supplicant-service-type)
	 (simple-service 'network-manager-applet
			 profile-service-type
			 (lits network-manager-applet))
	 (service modem-manager-service-type)
	 (service usb-modeswitch-service-type)
	 (service avahi-service-type)
	 (udisks-service)
	 (service upower-service-type)
	 (accountsservice-service)
	 (service cups-pk-helper-service-type)
	 (service colord-service-type)
	 (geoclue-service)
	 (service polkit-service-type)
	 (elogind-service)
	 (dbus-service)

	 (service ntp-service-type)

	 (service pulseaudio-service-type)
	 (service alsa-service-type)

	 %base-services))


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
      (list sway
	    hikari
            alacritty
	    clipman
	    grim
	    wofi
            emacs
	    thunar
	    git
	    fuse-exfat
	    vim
	    ntfs-3g
	    bluez
	    bluez-alsa
	    pulseaudio
	    gvfs
	    nss-certs))
      %base-packages)
  (services
    (append
      (list (service openssh-service-type)
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
	    (bluetooth-service #:auto-enable? #t)))
      %my-base-services)
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
	   (file-system
	     (mount-point "/mnt/storage")
	     (device 
	       (uuid "BC8209EC8209ABC8" 'ntfs))
	     (type "ntfs"))
           %base-file-systems)))
