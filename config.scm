(use-modules
  (gnu)
  (gnu system nss)
  (gnu packages)
  (nongnu packages linux)
  (nongnu system linux-initrd))
(use-service-modules
  desktop
  dbus
  networking
  virtualization
  sddm
  cups
  web
  pm
  databases
  sound
  audio
  xorg
  ssh
  docker)
(use-package-modules
  bootloaders
  certs
  xdisorg
  vpn
  usb-modeswitch
  screen
  fonts
  databases
  disk
  web
  guile-xyz
  guile
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
                    '("wheel" "docker" "netdev" "httpd" "audio" "video" "kvm" "tty" "input" "realtime" "lp")))
                %base-user-accounts))

  (groups (cons* (user-group (system? #t) (name "realtime"))
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
	    glibc-utf8-locales
	    hikari
	    cagebreak
	    nginx
	    dwl
            alacritty
	    wireguard-tools
	    dosfstools
	    wofi
	    wl-clipboard
	    wob
	    grim
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
	    (service postgresql-service-type
		     (postgresql-configuration
		       (postgresql postgresql-14)))
	    (service httpd-service-type
		     (httpd-configuration
		       (config
			 (httpd-config-file
			   (server-name "localhost")
			   (document-root "/var/www")
			   (listen '("80"))
			   (modules (cons*
				      (httpd-module
					(name "proxy_module")
					(file "modules/mod_proxy.so"))
				      (httpd-module
					(name "proxy_fcgi_module")
					(file "modules/mod_proxy_fcgi.so"))
				      %default-httpd-modules))
			   (extra-config (list "\
			   <FilesMatch \\.php$>
			   SetHandler \"proxy:unix:/var/run/php-fpm.sock|fcgi://localhost/\"
			   </FilesMatch>"))))))
	    (service php-fpm-service-type
		     (php-fpm-configuration
		       (socket "/var/run/php-fpm.sock")
		       (socket-group "httpd")))
	    (service sddm-service-type
		     (sddm-configuration
		       (display-server "wayland")
		       (theme "elarun")))
	    (udev-rules-service 'brightness %backlight-udev-rule)
	    (service mpd-service-type
		     (mpd-configuration
		       (user "dylan")
		       (music-dir "~/music")))
	    (screen-locker-service hikari "hikari-unlocker")
	    (service libvirt-service-type
		     (libvirt-configuration
		       (unix-sock-group "libvirt")
		       (tls-port "16555")))
	    (bluetooth-service #:auto-enable? #t))
      (modify-services %desktop-services
		       (delete gdm-service-type)
		       (network-manager-service-type config => (network-manager-configuration
								 (inherit config)
								 (vpn-plugins (list network-manager-openvpn))))
		       (guix-service-type config => (guix-configuration
						      (inherit config)
						      (substitute-urls
							(append (list "https://substitutes.nonguix.org")
								%default-substitute-urls))
						      (authorized-keys
							(append (list (plain-file "non-guix.pub" 
										  "
										  (public-key
										    (ecc
										      (curve Ed25519)
										      (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)
										      )
										    )
										  "))
								%default-authorized-guix-keys)))))))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "08D2-C791" 'fat32))
             (type "vfat")
	     (flags '(no-atime)))
           (file-system
             (mount-point "/")
             (device
               (file-system-label "my-root"))
             (type "btrfs")
	     (flags '(lazy-time))
	     (needed-for-boot? #t))
           %base-file-systems)))
