# 视频放这里

页面会从这个目录引用视频。建议命名：

```
assets/videos/
├── hero.mp4          # 第 1 部分：手机里的竖屏视频（9:16 或 9:19）
├── showreel.mp4      # 第 2 部分：大视频（16:9）
├── card-01.mp4       # 第 3 部分：视频墙六张卡
├── card-02.mp4
├── card-03.mp4
├── card-04.mp4
├── card-05.mp4
└── card-06.mp4
```

配套封面图（可选，放 `assets/`）：

```
assets/hero-poster.jpg
assets/showreel-poster.jpg
assets/card-01-poster.jpg
```

## 格式要求

浏览器能直接播的只有这几种：

| 容器 | 编码 | 能用吗 |
|---|---|---|
| .mp4 | H.264 / AVC | ✅ 首选，全平台通吃 |
| .webm | VP9 / AV1 | ✅ 可选，做第二源 |
| .mp4 | H.265 / HEVC | ⚠️ Chrome 部分支持，Safari 要好，别赌 |
| .mov | H.264 | ⚠️ 改后缀没用，容器不对，先转码 |
| .mov | ProRes | ❌ 浏览器不认 |

**iPhone 直出通常是 HEVC 的 .mov，先用 ffmpeg 转一遍再用。**

## 压缩（重要）

街采素材动辄几百 MB，直接丢进去页面会卡死。目标：

| 用途 | 分辨率 | 码率 | 单文件 |
|---|---|---|---|
| 手机 hero 竖屏 | 1080×1920 | 4–6 Mbps | < 8 MB |
| 大视频播放器 | 1920×1080 | 5–8 Mbps | < 15 MB |
| 视频墙卡片 | 1280×800 | 2–3 Mbps | < 4 MB |

ffmpeg 一行命令（有 ffmpeg 就能跑）：

```bash
# 1080p H.264，无音轨（背景视频不需要声音，还能省一半体积）
ffmpeg -i input.mov -vf "scale=-2:1080" -c:v libx264 -crf 23 -preset slow -an -movflags +faststart hero.mp4

# 带声音的版本（教程类）
ffmpeg -i input.mov -vf "scale=-2:1080" -c:v libx264 -crf 23 -preset slow -c:a aac -b:a 128k -movflags +faststart hero.mp4
```

`-movflags +faststart` 别漏——它把索引挪到文件头，浏览器不用下完整个文件就能开始播。

## 封面图

从视频里抽一帧当 poster：

```bash
ffmpeg -ss 00:00:03 -i hero.mp4 -frames:v 1 -q:v 3 hero-poster.jpg
```

## 填进页面的位置

1. **Hero（手机里）** — `.phone-video`，竖屏，`object-fit: cover` 会裁掉超出部分
2. **大视频** — `.showreel .video-slot video`，16:9
3. **视频墙** — 六张卡各自的 `<video>`，16:10

每处都在 HTML 注释里标了「换视频」。
