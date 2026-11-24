# DSH 插件合集 / DSH plugin collection

我的 DeepSeek Harness 插件集合。每个插件保留独立仓库（fork 上游或本地自研），用 git submodule 汇总，`bundle/` 是可一次安装的 DSH bundle。

My DeepSeek Harness plugin set. Every plugin keeps its own repository (upstream fork or local project), gathered here as git submodules; `bundle/` is the installable DSH bundle.

---

## 包含的插件 / Plugins

| 插件 | 仓库 | 上游 / upstream | 分支 |
|---|---|---|---|
| 灯下 Lamplit | [dsh-lamplit](https://github.com/hypo-Z/dsh-lamplit) | lysforge/dsh-lamplit | `main` |
| 桌面宠物 | [dsh-pet](https://github.com/hypo-Z/dsh-pet) | PC2005-cloud/dsh-pet | `local` |
| 顶部行情条 | [dsh-stock-bar](https://github.com/hypo-Z/dsh-stock-bar) | NoCandles/dsh-stock-bar | `dev-1.11` |
| 持仓看板 | [dsh-portfolio](https://github.com/hypo-Z/dsh-portfolio) | HPNY/dsh-portfolio | `main` |
| 音乐面板 | [dsh-music-panel](https://github.com/hypo-Z/dsh-music-panel) | Aliboder/dsh-music-panel | `local` |
| B 站多屏 | [dsh-bilibili-multiview](https://github.com/hypo-Z/dsh-bilibili-multiview) | Xinrea/dsh-bilibili-multiview | `main` |
| B 站小窗 | [dsh-bili-widget](https://github.com/hypo-Z/dsh-bili-widget) | pyf2818/dsh-bili-widget | `main` |
| 换肤 Dream Skin | [dsh-dream-skin](https://github.com/hypo-Z/dsh-dream-skin) | gitcode.com/LLLAAAAA/dsh-dream-skin | `main` |
| 导航宫格 | [dsh-nav-grid](https://github.com/hypo-Z/dsh-nav-grid) | 本地自研 | `main` |
| 上游同步 | [dsh-fork-sync](https://github.com/hypo-Z/dsh-fork-sync) | 本地自研 | `main` |

另有 7 个 npm 插件作为依赖锁定版本：`dshmarket`、`dsh-better-sidebar`、`@linxin666/dsh-client-ui-git-graph`、`dsh-pixel-ui`、`dsh-context`、`dsh-game-skins`、`dsh-github-flow`。

`local` / `dev-1.11` 分支承载与上游分叉的本地改动，`main` 保持与上游一致，方便继续同步。

The `local` / `dev-1.11` branches carry changes that diverged from upstream; `main` tracks upstream so `git fetch upstream && git rebase upstream/main` still works.

---

## 目录结构 / Layout

```
dsh-plugins/
├── bundle/                 # 可安装的 DSH bundle
│   ├── package.json        # 10 个 file: 依赖 + 7 个 npm 依赖
│   ├── cordis.patch.yml    # 由各插件的 patch 合并生成
│   ├── locale/{zh,en}.json
│   ├── docs/DETAIL.md
│   └── icon.svg
├── plugins/                # 各插件的 git submodule
└── scripts/
    ├── build-bundle-patch.py   # 重新生成合并后的 patch
    └── check.sh                # 本地自检（patch/YAML/依赖）
```

---

## 安装 / Install

```bash
git clone --recurse-submodules https://github.com/hypo-Z/dsh-plugins.git
```

然后在 DSH：**插件 → 添加插件 → 选择本仓库的 `bundle` 目录**。

> 已 clone 但没带 submodule 时：
> ```bash
> git submodule update --init --recursive
> ```

**注意 / Warning**：`bundle` 的 patch 合并了所有插件的行。如果当前 profile 已经单独装了这些插件，不要同时安装，否则会重复加载。迁移步骤：

1. 在插件管理器里禁用/移除旧的单插件 bundle
2. 完整退出 DSH
3. 安装 `dsh-plugins/bundle`
4. 重新进入后检查插件列表

---

## 更新 / Update

**更新某个插件到上游**

每个 submodule 都保留了 `upstream` remote：

```bash
cd plugins/dsh-lamplit
git fetch upstream
git rebase upstream/main          # 或在 local 分支上合并
git push origin HEAD
```

**更新合集指针**

```bash
cd dsh-plugins
git submodule update --remote --merge
git commit -am "chore: bump submodules"
```

**重新生成 bundle patch**（插件自己的 patch 变化后）

```bash
python3 scripts/build-bundle-patch.py
```

**安装新版本**

DSH 插件管理器里移除旧的 `dsh-plugins` bundle，再重新添加一次 `bundle` 目录。

---

## 数据与配置 / Data

插件配置与数据仍在 `~/.dsh/` 下，与仓库无关：

- `~/.dsh/lamplit/`（书架、微信读书凭据）
- `~/.dsh/dsh-pet/`
- `~/.dsh/dsh-stock-bar/`
- `~/.dsh/.leekbox-watchlist.json` 等

本仓库只保存代码，不包含个人数据。

---

## 许可 / License

各插件保留其原始许可证；本仓库仅做汇总与配置。

- 上游 fork 的插件遵循各自 upstream 的 LICENSE（dsh-lamplit、dsh-stock-bar、dsh-portfolio、dsh-music-panel、dsh-bilibili-multiview、dsh-bili-widget、dsh-dream-skin、dsh-pet）
- 本地自研的 dsh-nav-grid、dsh-fork-sync 由我维护
- 分发或二次修改时请保留对应上游的版权与许可声明

---

## 已知限制 / Known limitations

- `bundle` 里的 patch 是**合并快照**：插件各自的配置默认值被复制到这里，插件侧更新默认值时需要重新生成
- pet / music 的 `local` 分支与上游 `main` 有分叉，rebase 上游时可能需要手动解决冲突
- dsh-dream-skin 上游在 GitCode，无法用 GitHub 的 fork 同步机制，只能手动 cherry-pick
