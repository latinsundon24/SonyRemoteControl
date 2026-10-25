#!/usr/bin/env bash
# 从 icon-1024.png 生成 iOS App 图标全套尺寸，并写入 Contents.json。
# 依赖 macOS 自带的 sips。CI 与本机（macOS）均可运行。
set -euo pipefail

SRC="SonyRemoteControl/Assets.xcassets/AppIcon.appiconset/icon-1024.png"
DST="SonyRemoteControl/Assets.xcassets/AppIcon.appiconset"

if [ ! -f "$SRC" ]; then
  echo "缺少图标源图: $SRC" >&2
  exit 1
fi

make_icon() { sips -z "$2" "$2" "$SRC" --out "$DST/icon-$1.png" >/dev/null; }

make_icon 20  20
make_icon 29  29
make_icon 40  40
make_icon 58  58
make_icon 60  60
make_icon 76  76
make_icon 80  80
make_icon 87  87
make_icon 120 120
make_icon 152 152
make_icon 167 167
make_icon 180 180

cat > "$DST/Contents.json" <<'EOF'
{
  "images" : [
    { "idiom" : "iphone", "scale" : "2x", "size" : "20x20", "filename" : "icon-40.png" },
    { "idiom" : "iphone", "scale" : "3x", "size" : "20x20", "filename" : "icon-60.png" },
    { "idiom" : "iphone", "scale" : "2x", "size" : "29x29", "filename" : "icon-58.png" },
    { "idiom" : "iphone", "scale" : "3x", "size" : "29x29", "filename" : "icon-87.png" },
    { "idiom" : "iphone", "scale" : "2x", "size" : "40x40", "filename" : "icon-80.png" },
    { "idiom" : "iphone", "scale" : "3x", "size" : "40x40", "filename" : "icon-120.png" },
    { "idiom" : "iphone", "scale" : "2x", "size" : "60x60", "filename" : "icon-120.png" },
    { "idiom" : "iphone", "scale" : "3x", "size" : "60x60", "filename" : "icon-180.png" },
    { "idiom" : "ipad", "scale" : "1x", "size" : "20x20", "filename" : "icon-20.png" },
    { "idiom" : "ipad", "scale" : "2x", "size" : "20x20", "filename" : "icon-40.png" },
    { "idiom" : "ipad", "scale" : "1x", "size" : "29x29", "filename" : "icon-29.png" },
    { "idiom" : "ipad", "scale" : "2x", "size" : "29x29", "filename" : "icon-58.png" },
    { "idiom" : "ipad", "scale" : "1x", "size" : "40x40", "filename" : "icon-40.png" },
    { "idiom" : "ipad", "scale" : "2x", "size" : "40x40", "filename" : "icon-80.png" },
    { "idiom" : "ipad", "scale" : "1x", "size" : "76x76", "filename" : "icon-76.png" },
    { "idiom" : "ipad", "scale" : "2x", "size" : "76x76", "filename" : "icon-152.png" },
    { "idiom" : "ipad", "scale" : "2x", "size" : "83.5x83.5", "filename" : "icon-167.png" },
    { "idiom" : "ios-marketing", "scale" : "1x", "size" : "1024x1024", "filename" : "icon-1024.png" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
EOF

echo "App 图标集生成完成：$DST"
ls "$DST"
