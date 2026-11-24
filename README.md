# dsh-plugins

One DSH bundle that installs my full plugin set, assembled from forked upstreams and local plugins.

Each plugin keeps its own repository (fork lineage preserved) and is pulled in as a git submodule,
so upstream sync tools keep working.

## Layout

```
bundle/               # the installable DSH bundle (cordis.patch.yml + deps)
plugins/<name>/       # git submodules pointing at my forks
```

## Install

```bash
git clone --recurse-submodules git@github.com:hypo-Z/dsh-plugins.git
cd dsh-plugins
# in DSH: Plugins → Add plugin → select ./bundle
```

## Plugin sources

| plugin | repository | upstream |
|---|---|---|
| dsh-lamplit | hypo-Z/dsh-lamplit | lysforge/dsh-lamplit |
| dsh-pet | hypo-Z/dsh-pet | PC2005-cloud/dsh-pet |
| dsh-stock-bar | hypo-Z/dsh-stock-bar | NoCandles/dsh-stock-bar |
| dsh-portfolio | hypo-Z/dsh-portfolio | HPNY/dsh-portfolio |
| dsh-music-panel | hypo-Z/dsh-music-panel | Aliboder/dsh-music-panel |
| dsh-bilibili-multiview | hypo-Z/dsh-bilibili-multiview | Xinrea/dsh-bilibili-multiview |
| dsh-bili-widget | hypo-Z/dsh-bili-widget | pyf2818/dsh-bili-widget |
| dsh-dream-skin | hypo-Z/dsh-dream-skin | gitcode.com/LLLAAAAA/dsh-dream-skin |
| dsh-nav-grid | hypo-Z/dsh-nav-grid | — |
| dsh-fork-sync | hypo-Z/dsh-fork-sync | — |
