;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu home services bash))

(home-environment
  (packages
    (map specification->package
         (list "unrar"
               "lynx"
               "xdg-dbus-proxy"
               "xdg-desktop-portal"
               "xdg-desktop-portal-gtk"
               "xdg-desktop-portal-wlr"
               "flatpak"
               "keepassxc"
               "ding"
               "qbittorrent"
               "qutebrowser"
               "zathura-cb"
               "mcomix"
               "octave"
               "libreoffice"
               "redshift-wayland"
               "r"
               "cantata"
               "sonata"
               "cutter"
               "radare2"
               "telegram-desktop"
               "tumbler"
               "zathura-djvu"
               "zathura-pdf-mupdf"
               "zathura"
               "firefox"
               "rsync"
               "btrfs-progs"
               "network-manager-openvpn"
               "youtube-dl"
               "libzip"
               "android-libsparse"
               "android-libselinux"
               "android-libutils"
               "android-libziparchive"
               "kconfig"
               "virglrenderer"
               "adb"
               "nmap"
               "qemu"
               "python"
               "xcalc"
               "gcc-toolchain"
               "autoconf"
               "automake"
               "cmake"
               "tcpdump"
               "ffmpeg"
               "mc"
               "dosfstools"
               "blueman"
               "emacs-bluetooth"
               "mupdf"
               "imv"
               "htop"
               "ffmpegthumbnailer"
               "ungoogled-chromium"
               "anki"
               "calibre"
               "thunar-volman"
               "xdg-utils"
               "ghc"
               "mpv"
               "icecat"
               "ncmpcpp"
               "fontconfig"
               "font-mplus-testflight"
               "glibc-utf8-locales"
               "mythes"
               "gcide"
               "ispell"
               "gccgo"
               "gcc-objc++"
               "gcc-objc"
               "lean"
               "zlib"
               "tree"
               "p7zip"
               "binutils"
               "avr-toolchain"
               "make"
               "avrdude"
               "unzip"
               "zip"
               "file"
               "nnn"
               "neovim"
               "font-adobe-source-han-sans"
               "gnome-icon-theme"
               "arc-icon-theme"
               "powertop"
               "cpufrequtils"
               "light")))
  (services
    (list (service
            home-bash-service-type
            (home-bash-configuration
              (bashrc
                (list (local-file "/home/dylan/.bashrc")))
              (bash-profile
                (list (local-file "/home/dylan/.bash_profile"))))))))
