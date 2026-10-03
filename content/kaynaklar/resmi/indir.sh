#!/usr/bin/env bash
# Resmî kaynakları yeniden indirir ve SHA-256 değerlerini KAYNAKLAR.md ile karşılaştırmak için yazdırır.
set -euo pipefail
cd "$(dirname "$0")"
dl() { curl -sfL -m 60 -A "Mozilla/5.0" -o "$1" "$2" && echo "indirildi: $1"; }
dl test_karari_tesmer.pdf "https://www.tesmer.org.tr/wp-content/uploads/2024/12/2684286SMMM-Sinavi-Yapilma-Yontemi__5.pdf"
dl test_karari_ismmmo.pdf "https://www.ismmmo.org.tr/dosya/5865/Staj-Dosya/15012026-smmm-sinav-degisiklik-duyuru.pdf"
dl sinav_yonetmeligi_2025.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/YONETMELIKLER_3MART2025/6-S%C4%B1nav-2025.pdf"
dl staj_yonetmeligi_2025.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/YONETMELIKLER_3MART2025/4-Staj-2025.pdf"
dl yonerge_2026.pdf "https://www.tesmer.org.tr/wp-content/uploads/2026/01/TESMER-Staj-ve-Sinavlara-Iliskin-Uygulama-Yonergesi-2026.pdf"
dl takvim_2026.pdf "https://www.tesmer.org.tr/wp-content/uploads/2024/12/TURMOB_2026_sinav_takvimi.pdf"
dl asym_sgs_2025_1.pdf "https://asym.ankara.edu.tr/wp-content/uploads/sites/372/2025/03/TURMOB-TESMER-STAJA-GIRIS-SINAVI-2025-1.DONEM-UYGULAMA-KILAVUZU.pdf"
for f in *.pdf; do pdftotext -layout "$f" "${f%.pdf}.txt"; done
sha256sum *.pdf
