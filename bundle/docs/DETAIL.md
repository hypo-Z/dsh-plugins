# Hypo 插件合集

一个 DSH bundle，把常用的 17 个插件装到一起。

## 包含

- 阅读：灯下 Lamplit（微信读书 / 番茄 / 本地书）
- 桌面：dsh-pet 蓝色宠物
- 行情：dsh-stock-bar 顶部行情条 + dsh-portfolio 持仓看板
- 音乐：dsh-music-panel
- 视频：dsh-bilibili-multiview、dsh-bili-widget
- 外观：dsh-dream-skin、dsh-pixel-ui、dsh-game-skins
- 工具：dsh-nav-grid、dsh-fork-sync、dshmarket、dsh-better-sidebar、git-graph、dsh-context、dsh-github-flow

## 本地开发插件

`plugins/` 下是 git submodule，各自保留上游 fork 关系：

- 上游同步：在各子模块里 `git fetch upstream && git rebase upstream/main`
- 更新合集：`git submodule update --remote`

## 安装

DSH → 插件 → 添加插件 → 选择本仓库的 `bundle` 目录。
