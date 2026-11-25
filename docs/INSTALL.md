# 安装与排查

## 方式一：插件管理器（桌面端，推荐）

1. 克隆仓库并初始化子模块：

   ```bash
   git clone https://github.com/hypo-Z/dsh-plugins.git
   cd dsh-plugins
   ./scripts/init-submodules.sh
   ```

2. DSH → **插件** → **添加插件**
3. 选择本仓库的 **`bundle` 目录**（不是仓库根目录）
4. **完整退出 DSH 再打开**（`Cmd+Q`，不是关窗口）

## 方式二：Release tarball（不用克隆）

1. 从 <https://github.com/hypo-Z/dsh-plugins/releases> 下载 `dsh-plugins-hypo-<version>.tgz`
2. 安装：

   ```bash
   dsh plugin --profile desktop add ./dsh-plugins-hypo-0.1.0.tgz
   ```

3. 重启 DSH

## 迁移：从单插件切换到合集

合集 patch 合并了所有插件的行。**同时安装会重复加载**（`duplicate loader entry id` 或双份侧边栏）。

1. 插件管理器里移除旧的单插件 bundle（lamplit、pet、stock-bar……）
2. 完整退出 DSH
3. 安装合集
4. 重新打开，确认插件列表里只有 `dsh-plugins-hypo` 一份

## 只想装其中一部分

合集默认带全部 17 项。不需要的可以在插件管理器里对对应行点 **禁用**，行 id 形如：

```
lamplit / dsh-pet / stock-bar / portfolio / music / bilibili-multiview /
bili-widget / dream-skin / nav-grid / fork-sync / hypo-market / hypo-better-sidebar /
hypo-ui-git-graph / hypo-pixel-ui / hypo-dsh-context / hypo-game-skins / hypo-github-flow
```

## 常见问题

### 大仓库克隆失败（pet / music）

GitHub 连接不稳定时会报 `invalid index-pack output` / `early EOF`。重试：

```bash
git submodule update --init plugins/dsh-pet
git submodule update --init plugins/dsh-music-panel
```

### stock-bar 版本不对

不要用 `--depth 1` / `--shallow-submodules` 克隆子模块：stock-bar 跟踪的是 `dev-1.11`，不是默认分支。

```bash
git submodule update --init plugins/dsh-stock-bar
git -C plugins/dsh-stock-bar checkout 7880f4a
```

### 插件没出现

- 确认添加的是 `bundle` 目录，不是仓库根目录
- 确认已完整退出并重启
- 看插件管理器里 `dsh-plugins-hypo` 是否 `active`；有红色诊断按提示处理

### 与已有的单插件冲突

见上面的「迁移」。尤其 `dsh-better-sidebar`、`dsh-pixel-ui`、`dsh-context`、`dshmarket` 这些以 npm 包名加载的插件，重复 mount 会直接报错。

## 更新

```bash
./scripts/update.sh
```

然后插件管理器里移除旧合集、重新添加 `bundle`。
