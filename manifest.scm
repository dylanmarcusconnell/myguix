;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(specifications->manifest
  (list "arc-icon-theme"
        "papirus-icon-theme"
        "calibre"
        "ghc"
        "gcc-toolchain"
        "mpv"
        "icecat"
        "qbittorrent"
        "ncmpcpp"
        "gnome-icon-theme"
        "powertop"
        "cpufrequtils"
        "light"))
