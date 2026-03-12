#!/usr/bin/env bash

ENGINE="$HOME/dotfiles/bin/grimblast_engine"
SAVE_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
TEMP_FILE="${XDG_RUNTIME_DIR:-/tmp}/screenshot.png"
SAVE_FILE=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
mkdir -p "$SAVE_DIR"

ANNOTATOR="swappy"
OCR_LANG="eng+por"

LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/grimblast.lock"
if [ -e "$LOCK_FILE" ]; then
    exit 2
fi

notify() {
    notify-send -a "System" -r 9 -i "$1" "$2" "$3"
}

USAGE() {
    cat <<USAGE
Usage: $(basename "$0") [option]
Options:
    p   Screenshot all outputs
    s   Select area or window
    sf  Select area or window with frozen screen
    m   Screenshot focused monitor
    sc  OCR: Scan text to clipboard
    sq  QR: Scan QR code to clipboard
USAGE
}

take_screenshot() {
    local mode=$1
    local extra=$2
    
    if grimblast $extra copysave "$mode" "$TEMP_FILE"; then
        if [[ -n "$ANNOTATOR" && "$extra" != "--ocr" ]]; then
            $ANNOTATOR -f "$TEMP_FILE" -o "$SAVE_DIR/$SAVE_FILE"
        fi
        
        if [ -f "$SAVE_DIR/$SAVE_FILE" ]; then
            notify "$SAVE_DIR/$SAVE_FILE" "Screenshot Saved" "Saved to $SAVE_DIR"
        fi
    else
        notify "dialog-error" "Error" "Failed to capture screenshot"
    fi
}

ocr_screenshot() {
    if grimblast --freeze copysave area "$TEMP_FILE"; then
        notify "document-scan" "OCR" "Extracting text..."
        if tesseract "$TEMP_FILE" stdout -l "$OCR_LANG" | wl-copy; then
            notify "document-properties" "OCR Success" "Text copied to clipboard"
        else
            notify "dialog-error" "OCR Error" "Failed to extract text"
        fi
    fi
}

qr_screenshot() {
    if grimblast --freeze copysave area "$TEMP_FILE"; then
        notify "document-scan" "QR Scan" "Reading code..."
        local qr_content=$(zbarimg --quiet --raw "$TEMP_FILE")
        if [[ -n "$qr_content" ]]; then
            echo "$qr_content" | wl-copy
            notify "complete" "QR Success" "Content copied to clipboard"
        else
            notify "dialog-error" "QR Error" "No QR code found"
        fi
    fi
}

case $1 in
    p)  take_screenshot "screen" ;;
    s)  take_screenshot "area" ;;
    sf) take_screenshot "area" "--freeze" ;;
    m)  take_screenshot "output" ;;
    sc) ocr_screenshot ;;
    sq) qr_screenshot ;;
    *)  USAGE ;;
esac

[ -f "$TEMP_FILE" ] && rm "$TEMP_FILE"
