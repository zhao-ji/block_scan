#!/bin/bash
# 所有谷歌DNS没有解析出来的域名
# 所有香港也无法连通的IP
# 所有被屏蔽域名排行

export LC_ALL=C

join -1 2 -2 1 \
	<( cat ../top-1m.csv | sed 's/,/ /g' | sort -k 2 ) \
	<( comm -23 \
		<(cut -d, -f2 ../top-1m.csv|sort) \
		<(cat ../scan_log/16_05_23_DNS_record|cut -d ' ' -f 1|sort) \
        | sort \
	) | awk '{print $2, $1}' > lost_domain

comm -23 <(cat ../scan_log/16_05_23_foreign_ip_list|sort) <(cat ../scan_log/16_05_23_hongkong|sort) > lost_ip

join -1 2 -2 1 \
	<( cat ../top-1m.csv | sed 's/,/ /g' | sort -k 2) \
	<( join -1 3 -2 1 \
		<(cat ../scan_log/16_05_23_DNS_record | sort -k 3 -u) \
		<(cat ../scan_log/16_05_23_diff | sort) \
        | awk '{print $2, $3, $1}' | sort \
	) | sort -k 2 -n | awk '{print $2, $1, $3, $4}' > block_domain
