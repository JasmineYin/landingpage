# 本目录工作约定

## 做网页时

**先加载 skill `web-from-reference`**，按它的流水线走：定标 → 骨架 → 视觉 → 适配 → 动效 → 自检。

三条不能省：

1. 动笔前先给「结构清单 + 设计令牌表」，等确认。
2. 改动用精确字符串替换，不整文件重写；一次只改一类。
3. 改完用 `scripts\snap.ps1` 截图自查，和参考图并排看。

## 文件

- `index.html` — 主页面（单文件，样式内联，CSS 变量集中声明）
- `landing.html` — 三部分落地页（hero + 三步 + 视频墙）
- `assets/` — 图片素材
- `preview.png` / `preview-mobile.png` — 历史截图
- `snaps/` — `snap.ps1` 产出的对照截图
- `DESIGN.md` — 设计令牌（有就必读，且优先级高于口头描述）
- `screenshot-to-code/` — 参考项目的源码，只读，不当依赖用

## 截图

```bat
scripts\snap.cmd                                  :: 1440 + 390
scripts\snap.cmd -Widths 1440,1024,768,390        :: 四档
scripts\snap.cmd -Height 2400                     :: 长图
```

本机 PowerShell 执行策略是 Restricted，`.ps1` 不能直接双击运行，统一走 `.cmd` 包装。
`.ps1` 需要时用：`powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\snap.ps1`
