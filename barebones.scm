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
  dbus
  networking
  virtualization
  cups
  pm
  xorg
  ssh
  docker)
(use-package-modules
  bootloaders
  certs
  disk
  guile-xyz
  guile
  vim
  version-control
  linux
  file-systems
  shells
  cups)

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
      (list 
	    fdisk
	    guile-readline
	    guile-colorized
	    glibc-utf8-locales
	    git
	    fuse-exfat
	    vim
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
	    (service libvirt-service-type
		     (libvirt-configuration
		       (unix-sock-group "libvirt")
		       (tls-port "16555"))))))
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
           %base-file-systems)))
