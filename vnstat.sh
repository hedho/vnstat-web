vnstati -d 300 -i enp41s0 -o /dir/public_html/network-log.png
vnstati --summary --iface enp41s0 --output /dir/summary.png
vnstati -vs -o /dir/vnstat.png
vnstati -h -o /dir/public_html/hour.png
vnstati -m -o /dir/public_html/month.png
