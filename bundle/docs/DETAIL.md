# Hypo 插件合集

把我在 DSH 里每天用的插件打包成一个合集：灯下听书、桌面宠物、行情条 + 持仓看板、音乐面板、B 站多屏/小窗、皮肤与常用工具。

## 为什么做这个合集

上游插件都很好，但我有自己的使用习惯：

- 听书要高亮跟着声音、切页回来能接着读、进度写回书架
- 行情条要能看到持仓看板的自己选股
- 宠物每段动画都要轮得到，重启后别重头再来
- B 站直播小窗拖不出屏幕，切页回来还在播

所以 fork 下来改了一轮，保留 upstream remote，再用一个 bundle 装齐。

## 包含

- 阅读：灯下 Lamplit（微信读书 / 番茄 / 本地书，听书、小窗、悬浮球）
- 桌面：dsh-pet 蓝色宠物
- 行情：dsh-stock-bar 顶部行情条 + dsh-portfolio 持仓看板（自选联动）
- 音乐：dsh-music-panel（与直播联动，开播自动暂停）
- 视频：dsh-bilibili-multiview（HLS 多屏 + 迷你小窗）
- 外观：dsh-dream-skin、dsh-pixel-ui、dsh-game-skins
- 工具：dsh-nav-grid、dsh-fork-sync、dshmarket、dsh-better-sidebar、git-graph、dsh-context、dsh-github-flow

## 和上游的差别

各子模块保留 `upstream`，改动在 `local` / `dev-1.11` 分支。主要改动：

- **灯下**：听书（音色/语速/逐句高亮/进度写回/自动续章）、小窗与悬浮球、微信读书长效会话
- **宠物**：双池公平轮播（持久化）、待机填充、拖动边界
- **行情条**：与持仓看板自选单向同步、可覆盖顶栏、东财不可达时回落腾讯
- **音乐**：直播开始自动暂停、顶栏控制、缓存上限
- **B 站多屏**：HLS 直播、小窗弹幕、窗口内约束、自动静音起播

## 安装

DSH → 插件 → 添加插件 → 选择本仓库的 `bundle` 目录，然后完整退出再打开。

不要与已安装的同名单插件同时启用；迁移步骤见仓库 `docs/INSTALL.md`。

## 限制

- 合计约 141MB（宠物/音乐素材为主）
- patch 是合并快照，插件默认值变化后需要重新生成
- dream-skin 上游在 GitCode，无法用 GitHub fork 机制自动同步
