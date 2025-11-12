#!/bin/bash
set -e

# 构建AppImage的脚本

# 设置变量
APP_NAME="VideoDownloader"
APP_ID="com.github.unrud.VideoDownloader"
APP_VERSION="0.12.28"
APP_DIR="$PWD/AppDir"

# 创建临时目录
mkdir -p "$APP_DIR/usr/bin"
mkdir -p "$APP_DIR/usr/share"
mkdir -p "$APP_DIR/usr/share/applications"
mkdir -p "$APP_DIR/usr/share/icons/hicolor/scalable/apps"
mkdir -p "$APP_DIR/usr/share/glib-2.0/schemas"
mkdir -p "$APP_DIR/usr/share/metainfo"
mkdir -p "$APP_DIR/usr/share/video_downloader"

# 安装构建依赖
echo "安装构建依赖..."
sudo apt-get update
sudo apt-get install -y meson python3 python3-gi python3-gi-cairo libgtk-4-dev yt-dlp ffmpeg gettext

# 构建项目
echo "构建项目..."
meson setup build
meson compile -C build

# 安装到AppDir
echo "安装到AppDir..."
DESTDIR="$APP_DIR" meson install -C build

# 复制必要的依赖文件
echo "复制依赖文件..."
# 复制Python模块和依赖
pip3 install --target="$APP_DIR/usr/share/video_downloader/vendor" yt-dlp[default]

# 创建启动脚本
cat > "$APP_DIR/AppRun" << 'EOF'
#!/bin/bash
set -e

# 设置Python路径
export PYTHONPATH="$(dirname "$0")/usr/share/video_downloader:$(dirname "$0")/usr/share/video_downloader/vendor:${PYTHONPATH}"

# 运行应用
"$(dirname "$0")/usr/bin/video-downloader"
EOF

chmod +x "$APP_DIR/AppRun"

# 创建桌面文件
cat > "$APP_DIR/$APP_ID.desktop" << 'EOF'
[Desktop Entry]
Name=Video Downloader
Comment=Simple video downloader for YouTube and many other websites
Exec=video-downloader
Icon=com.github.unrud.VideoDownloader
Terminal=false
Type=Application
Categories=AudioVideo;Network;
MimeType=x-scheme-handler/youtube;
StartupNotify=true
EOF

# 下载或复制图标
if [ -f "data/com.github.unrud.VideoDownloader.svg" ]; then
    cp "data/com.github.unrud.VideoDownloader.svg" "$APP_DIR/com.github.unrud.VideoDownloader.svg"
else
    echo "警告: 图标文件未找到，将使用默认图标"
fi

# 下载appimagetool
echo "下载appimagetool..."
wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
chmod +x appimagetool

# 构建AppImage
echo "构建AppImage..."
./appimagetool "$APP_DIR" "${APP_NAME}-${APP_VERSION}-x86_64.AppImage"

echo "AppImage构建完成: ${APP_NAME}-${APP_VERSION}-x86_64.AppImage"