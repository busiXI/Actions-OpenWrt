#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Modify default IP 修改原始IP 【原：lan) ipad=${ipaddr:-"192.168.1.1"}】
sed -i '103s/192.168.1.1/192.168.168.1/g' package/base-files/files/bin/config_generate

#替换tiny-tp-link.mk文件第474行字符
sed -i '474s/4mlzma/16mlzma/g' target/linux/ar71xx/image/tiny-tp-link.mk

#删除02_network文件第147行
sed -i '147d' target/linux/ar71xx/base-files/etc/board.d/02_network

#在158行末尾新增tl-wr802n-v1)设定，新增WAN口LAN口
sed -i 'N;158a\\ttl-wr802n-v1)\n\t\tucidef_set_interface_wan \"eth0\"\n\t\tucidef_set_interface_lan \"eth1\"\n\t\t\;\;' target/linux/ar71xx/base-files/etc/board.d/02_network

#在88行末尾新增，设置WAN信息，默认网口为WAN口
sed -i 'N;88a\\tath79_eth1_data.phy_if_mode = PHY_INTERFACE_MODE_MII\;\n\tath79_eth1_data.duplex = DUPLEX_FULL\;\n\tath79_eth1_data.speed = SPEED_100\;\n\tath79_eth1_data.phy_mask = BIT(4)\;\n\tath79_init_mac(ath79_eth1_data.mac_addr, mac, 2)\;\n\tath79_register_eth(1)\;\n' target/linux/ar71xx/files/arch/mips/ath79/mach-tl-wr802n.c

#默认开启wifi
sed -i '113s/1/0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh


# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
