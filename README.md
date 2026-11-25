# 我在 DSH 里每天用的插件，打包成了一个合集

这不是一个"插件市场合集"，而是我自己日常使用的 DeepSeek Harness 环境。

我每天用 DSH 做几件事：读微信读书（主要是听书）、看 A 股行情和持仓、听歌、挂着 B 站直播、顺便养一只蓝色宠物。上游插件都很好，但用久了会有一些"要是能这样就好了"的瞬间：

- 听书时希望高亮跟着声音走，切页回来还能接着读
- 行情条希望能直接看到持仓看板里的自选
- 宠物动画希望每段都能轮到，而不是总看到那几个
- B 站直播小窗希望拖不出屏幕、切页回来还在播

于是我把这些插件 fork 下来，按自己的使用习惯改了一轮，再用一个 bundle 装齐。**上游的版权和 fork 关系都保留着**，想同步上游随时可以 rebase。

---

## 和上游比，我改了什么

每个子模块都保留了 `upstream` remote，改动集中在自己维护的分支（`local` / `dev-1.11`）。

### 灯下 Lamplit（微信读书阅读器）

- **听书**：macOS `say` 合成，支持「月/婷婷/美佳」音色与 0.8–1.5 倍速
- **小窗 + 悬浮球**：可拖动、可缩放、位置记忆；收起成小球后菜单里暂停/回页面/关闭
- **逐句高亮**：按当前句文本匹配段落，不再依赖句子下标，切页回来立刻恢复
- **进度写回**：听书位置写回书架进度，首页「继续阅读」和阅读时长都会更新
- **自动续章**：读完自动进入下一章；预取后两句减少句间等待
- **微信读书会话**：支持 `wr_rt` 长效凭据，20 分钟自动续期，不再两小时掉线

### 桌面宠物 dsh-pet

- 动画改为**双池公平轮播**（A 池抽完倒进 B 池，再倒回来），每段动作一轮内都会出现
- 轮播状态写入 localStorage，**退出/重启不清空**
- 段与段之间播待机循环（呼吸 / 哼歌 / 东张西望），而不是停在末帧
- 待机后不会立刻又抽到待机；拖动边界与甩出速度也调过

### 行情条 dsh-stock-bar

- 升级到 **1.11.1**（委比修复、分时刻度、K 线副图、框选、预警历史、收益曲线）
- **与持仓看板联动**：看板增删自选后，行情条按插件自己的添加/删除逻辑同步，不写假数据
- 允许拖到标题栏/顶栏区域，覆盖后仍可点击
- 东财接口不可达时**自动回落腾讯**：分时、K 线、五档盘口、代码/名称搜索
- 只在对话页显示，不挡其他页面

### 音乐 dsh-music-panel

- 与宠物/直播联动：直播开始自动暂停音乐，直播结束恢复
- 顶栏紧凑播放控制、缓存上限、mediaSession 修复

### B 站多屏 dsh-bilibili-multiview

- HLS 直播、独立迷你小窗、小窗弹幕
- 小窗拖动限制在窗口内，缩放/DPI 变化自动回可见范围
- 刷新/换源被浏览器拦截时自动静音起播，点击恢复声音

### B 站小窗 dsh-bili-widget（默认禁用）

- 内嵌 HLS 直播、b23/直播间链接解析、关注列表导入、拖动修复
- 与多屏功能重叠，合集里默认关闭，需要时在插件管理器打开

### 其他

- **持仓看板 / Dream Skin / 导航宫格 / 上游同步**：原样或本地自研，未做破坏性修改
- **npm 插件**：dshmarket、dsh-better-sidebar、git-graph、pixel-ui、dsh-context、game-skins、github-flow，锁定版本，避免自动升级带来行为变化

---

## 几个跨插件联动

| 联动 | 效果 |
|---|---|
| 行情条 ↔ 持仓看板 | 看板自选自动出现在行情条，删除同步移除 |
| 音乐 ↔ B 站直播 | 开播自动暂停音乐，避免两路声音打架 |
| 灯下 ↔ 书架进度 | 听书进度写回，书架排序和「继续阅读」跟随 |
| 宠物 ↔ 音乐面板 | 音乐播放时宠物有对应动作（上游联动保留） |
| GitHub 插件 ↔ 本仓库 | 直接在这里提 PR / 看 CI |

---

## 为什么用这个合集

**适合你，如果：**

- 主要在 macOS 上用 DSH
- 常用微信读书听书、看 A 股、挂 B 站直播
- 喜欢宠物/皮肤，愿意接受"完整退出再打开"的更新方式
- 想一次装齐，而不是逐个找插件

**不适合你，如果：**

- 只需要其中一两个插件（直接装上游更轻）
- 磁盘/流量紧张（合集约 141MB，主要是宠物和音乐素材）
- 希望 `dsh plugin add` 一条命令搞定（合集目前是 bundle + submodule，npm 发布暂未做）

---

## 安装

详细步骤和排查见 **[docs/INSTALL.md](docs/INSTALL.md)**。

```bash
git clone https://github.com/hypo-Z/dsh-plugins.git
cd dsh-plugins
./scripts/init-submodules.sh
```

DSH → **插件 → 添加插件 → 选择 `bundle` 目录** → **完整退出再打开**（`Cmd+Q`）。

> 合集 patch 合并了所有插件的行。**不要和已安装的单插件同时启用**，否则会重复加载。迁移步骤见 INSTALL。

不用克隆的安装方式：从 [Releases](https://github.com/hypo-Z/dsh-plugins/releases) 下载 `dsh-plugins-hypo-<version>.tgz`，然后

```bash
dsh plugin --profile desktop add ./dsh-plugins-hypo-0.1.1.tgz
```

---

## 目录结构

```
dsh-plugins/
├── bundle/                 # 可安装的 DSH bundle
│   ├── package.json        # 10 个 file: 依赖 + 7 个 npm 依赖
│   ├── cordis.patch.yml    # 由各插件的 patch 合并生成
│   ├── locale/{zh,en}.json
│   ├── docs/DETAIL.md
│   └── icon.svg
├── plugins/                # 各插件的 git submodule
├── docs/INSTALL.md         # 安装与排查
└── scripts/
    ├── init-submodules.sh  # 带重试的子模块初始化
    ├── update.sh           # 更新并重新生成 patch
    ├── build-bundle-patch.py
    ├── package.sh          # 打包成可安装 tgz
    └── check.sh            # 本地/CI 自检
```

---

## 插件来源

| 插件 | 仓库 | 上游 | 本地分支 |
|---|---|---|---|
| 灯下 Lamplit | [dsh-lamplit](https://github.com/hypo-Z/dsh-lamplit) | lysforge/dsh-lamplit | `main` |
| 桌面宠物 | [dsh-pet](https://github.com/hypo-Z/dsh-pet) | PC2005-cloud/dsh-pet | `local` |
| 顶部行情条 | [dsh-stock-bar](https://github.com/hypo-Z/dsh-stock-bar) | NoCandles/dsh-stock-bar | `dev-1.11` |
| 持仓看板 | [dsh-portfolio](https://github.com/hypo-Z/dsh-portfolio) | HPNY/dsh-portfolio | `main` |
| 音乐面板 | [dsh-music-panel](https://github.com/hypo-Z/dsh-music-panel) | Aliboder/dsh-music-panel | `local` |
| B 站多屏 | [dsh-bilibili-multiview](https://github.com/hypo-Z/dsh-bilibili-multiview) | Xinrea/dsh-bilibili-multiview | `main` |
| B 站小窗 | [dsh-bili-widget](https://github.com/hypo-Z/dsh-bili-widget) | pyf2818/dsh-bili-widget | `main` |
| Dream Skin | [dsh-dream-skin](https://github.com/hypo-Z/dsh-dream-skin) | gitcode.com/LLLAAAAA/dsh-dream-skin | `main` |
| 导航宫格 | [dsh-nav-grid](https://github.com/hypo-Z/dsh-nav-grid) | 本地自研 | `main` |
| 上游同步 | [dsh-fork-sync](https://github.com/hypo-Z/dsh-fork-sync) | 本地自研 | `main` |

npm 插件（锁定版本）：`dshmarket 1.66.6`、`dsh-better-sidebar 0.24.1`、`@linxin666/dsh-client-ui-git-graph 0.4.4`、`dsh-pixel-ui 1.13.2`、`dsh-context 0.85.1`、`dsh-game-skins 0.3.4`、`dsh-github-flow 0.7.1`。

---

## 更新

```bash
./scripts/update.sh
```

然后在插件管理器移除旧合集、重新添加 `bundle`。

单个插件跟上游：

```bash
cd plugins/dsh-stock-bar
git fetch upstream
git rebase upstream/main
```

---

## 打包 / Package

```bash
./scripts/init-submodules.sh
./scripts/package.sh        # 产出 dist/dsh-plugins-hypo-<version>.tgz
dsh plugin --profile desktop add ./dist/dsh-plugins-hypo-0.1.1.tgz
```

打 `v*` tag 会自动构建并上传到 Release。

---

## 许可

汇总层（`bundle/`、`scripts/`、文档）MIT，见 [LICENSE](LICENSE)。
每个插件保留自己的许可证，第三方清单见 [NOTICE.md](NOTICE.md)。

数据都在 `~/.dsh/`，仓库里只有代码。

---

## 已知限制

- patch 是合并快照：插件默认值更新后需要跑一次 `build-bundle-patch.py`
- pet / music 的 `local` 分支与上游有分叉，rebase 可能需要解冲突
- dsh-dream-skin 上游在 GitCode，无法用 GitHub fork 机制自动同步
- 合集 tarball 约 141MB（压缩后 ~106MB），主要是宠物和音乐素材
