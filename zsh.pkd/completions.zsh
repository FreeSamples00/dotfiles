# ZSH completions config

# ========== CUSTOM COMPLETIONS ==========

# filters out binary completions
_files_text_readable() {
  local BINARY_EXTENSIONS=(
    "o" "a" "so" "dylib" "dll" "lib"
    "obj" "def" "rlib" "wasm"
    "exe" "bin" "out"
    "deb" "rpm" "msi" "nupkg" "apk"
    "pdf" "doc" "docx" "ppt" "pptx" "xls" "xlsx"
    "png" "jpg" "jpeg" "gif" "bmp" "ico" "tiff" "webp" "svg"
    "heic" "heif"
    "mp4" "mov" "avi" "mkv" "flv" "webm" "mp3" "wav" "flac" "aac" "ogg"
    "m4a" "opus"
    "zip" "tar" "gz" "bz2" "xz" "7z" "rar" "iso" "dmg"
    "tgz" "tbz" "txz"
    "db" "sqlite" "sqlite3" "sqlite-shm" "sqlite-wal"
    "ttf" "otf" "woff" "woff2"
    "pyc" "pyo" "class" "jar"
  )
  _files -g '*~(*.('${(j:|:)BINARY_EXTENSIONS}'))'
}

# ========== ASSIGNING COMPLETIONS ==========

compdef _files_text_readable $EDITOR
compdef _files_text_readable $GUI_EDITOR
