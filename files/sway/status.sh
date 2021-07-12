uptime_formatted=$(uptime | cut -d ',' -f1 | cut -d ' ' -f5,6)

date_formatted=$(date "+%a %F %I:%M")

linux_version=$(uname -r | cut -d '-' -f1)

battery1_capacity=$(cat /sys/class/power_supply/BAT1/capacity)

battery0_capacity=$(cat /sys/class/power_supply/BAT0/capacity)

echo $uptime_formatted $linux_version "Battery 1:" $battery1_capacity '%' "Battery 0:" $battery0_capacity '%' $date_formatted
