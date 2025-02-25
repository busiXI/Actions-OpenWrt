# WR802N v1-OpenWrt v24.10.0

## 思路

1. 环境准备：本地搭建OpenWrt编译环境，或者使用GitHub Actions。用户可能更倾向于后者，但需要处理依赖和缓存问题。

2. 获取OpenWrt源码：从官方仓库克隆，切换到合适的分支，比如最新的稳定版或开发版（如22.03或master）。

3. 配置目标设备：确认WR802N在源码中的支持情况。如果原厂设备在Target系统中，比如ath79或ramips，可能需要找到对应的配置文件。可能需要查看target/linux目录下的子目录，找到对应的设备。

4. 添加Tailscale包：Tailscale可能存在于OpenWrt的包仓库中。检查package目录中的feeds.conf是否有相关的feed，或者需要添加第三方feed，比如使用openwrt/packages中的Tailscale包，或者从Tailscale官方获取。

5. 调整配置：通过make menuconfig选择正确的Target System、Subtarget、设备型号，然后在Network或Utilities里找到Tailscale并选中。同时可能需要调整其他配置，比如启用必要的内核模块或依赖项。

6. 处理依赖：Tailscale可能需要Go语言的支持，所以需要确保在编译时包含Go编译环境，这可能需要在make menuconfig中选择相应的开发包，或者在feeds中添加额外的包源。

7. 自定义文件系统：可能需要修改files目录，添加Tailscale的配置文件或启动脚本，确保服务在启动时运行。

8. GitHub Actions配置：创建.yml文件，设置触发条件（如push到main分支），安装依赖（如Ubuntu镜像，安装编译工具），缓存下载的包和源码，执行编译命令。

9. 处理镜像大小：检查生成的固件是否超过64MB（实际应该不会，但需要确认），可能需要调整包选择，排除不必要的模块。

10. 测试编译后的固件：通过本地刷机测试，或者提供用户刷机指南。

潜在的问题点：

- WR802N的硬件改版可能需要调整设备树文件（DTS），尤其是内存和Flash的配置。原厂的DTS可能针对较小的Flash，需要检查分区表是否正确，确保编译后的固件适合64MB Flash。可能需要修改dts文件中的分区设置，例如将firmware分区的大小调整到更大的空间。

- Tailscale的依赖问题，比如是否要求内核版本，或者需要特定的配置选项。例如，可能需要启用CONFIG_PACKAGE_tailscale，以及相关的网络和加密模块。

- GitHub Actions的编译时间可能较长，导致超时。可能需要优化步骤，比如提前下载所有依赖，或者使用自托管Runner。

- 用户可能不熟悉OpenWrt编译流程，需要详细的步骤说明，包括如何配置menuconfig，如何处理可能出现的错误。

现在需要将这些步骤整理成用户能够理解的指导，同时结合GitHub仓库的配置。可能需要分步骤说明如何在本地配置，再迁移到GitHub Actions，或者直接使用Actions进行自动化。

另外，用户提到“最好通过GitHub flow实现”，可能意味着希望有版本控制、分支管理、PR流程等，但主要可能是指自动化编译流程。需要确保在GitHub仓库中设置正确的Actions工作流，每次提交代码后自动编译，并生成固件作为产物。

总结步骤：

1. 创建GitHub仓库，初始化OpenWrt源码。

2. 配置feeds.conf添加Tailscale包所需的源。

3. 调整设备配置（Target、Subtarget、DTS等）。

4. 在menuconfig中选择Tailscale及相关依赖。

5. 编写GitHub Actions配置文件，处理依赖安装、缓存、编译命令。

6. 处理固件生成和上传。

7. 提供刷机说明。


## Usage

- Generate `.config` files.
- Push `.config` file to the GitHub repository.
- Select `Build OpenWrt` on the Actions page.
- Click the `Run workflow` button.
- When the build is complete, click the `Artifacts` button in the upper right corner of the Actions page to download the binaries.

## Tips

- It may take a long time to create a `.config` file and build the OpenWrt firmware. Thus, before create repository to build your own firmware, you may check out if others have already built it which meet your needs by simply [search `Actions-Openwrt` in GitHub](https://github.com/search?q=Actions-openwrt).
- Add some meta info of your built firmware (such as firmware architecture and installed packages) to your repository introduction, this will save others' time.

