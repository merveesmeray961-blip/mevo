#!/usr/bin/env bash
# Mevzuat arşivini (kanunlar + ikincil mevzuat) yeniden indirir, metinleri üretir ve SHA-256 yazdırır.
# Gerekenler: curl, pdftotext (poppler-utils), python3, unzip; ekler için LibreOffice (soffice);
# OCR satırları için tesseract (+ tesseract-ocr-tur). Karşılaştırma: KAYNAKLAR.md.
set -uo pipefail
cd "$(dirname "$0")"
UA="Mozilla/5.0"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
dl() {  # dl <dosya> <url> : PDF/ofis dosyası indirir; HTML hata sayfası gelirse uyarır
  curl -sfL -m 180 -A "$UA" -o "$TMP/dl" "$2" || { echo "HATA: $1"; return 1; }
  case "$1" in *.pdf) head -c 5 "$TMP/dl" | grep -q '%PDF' || { echo "HATA (PDF değil): $1"; return 1; };; esac
  mv "$TMP/dl" "$1" && echo "indirildi: $1"
}
totxt() { pdftotext -layout "$1" "${1%.pdf}.txt"; }
office2txt() {  # office2txt <dosya>  -> <ad>.txt
  soffice --headless --norestore --convert-to pdf --outdir "$TMP" "$PWD/$1" >/dev/null 2>&1 \
    && pdftotext -layout "$TMP/${1%.*}.pdf" "${1%.*}.txt"
}
ocr2txt() {  # ocr2txt <dosya.pdf> -> <ad>.txt (tesseract, Türkçe)
  local d; d=$(mktemp -d); pdftoppm -r 300 -gray "$1" "$d/p"; : > "${1%.pdf}.txt"
  for i in $(ls "$d"/p-*.pgm | sort -V); do tesseract "$i" - -l tur --psm 6 2>/dev/null >> "${1%.pdf}.txt"; printf '\f' >> "${1%.pdf}.txt"; done
  rm -rf "$d"
}
h2t() { python3 -c '
import re,html,sys
s=sys.stdin.buffer.read()
m=re.search(rb"charset=[\"\x27]?([\w-]+)",s,re.I); enc=(m.group(1).decode() if m else "utf-8")
enc="windows-1254" if enc.lower() in ("iso-8859-1","iso-8859-9","windows-1254") else enc
s=s.decode(enc,"replace")
s=re.sub(r"(?is)<(script|style)[^>]*>.*?</\1>","",s); s=re.sub(r"(?i)<br\s*/?>","\n",s)
s=re.sub(r"(?i)</(p|div|tr|h[1-6]|li|table)>","\n",s); s=re.sub(r"(?i)</t[dh]>","\t",s)
s=html.unescape(re.sub(r"<[^>]+>","",s)).replace("\xa0"," ")
s=re.sub(r"[ \t]+\n","\n",s); s=re.sub(r"\n{3,}","\n\n",s); print(s.strip())'; }


# ---- Kanunlar (daha önce indirilmiş) ----
dl gvk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.4.193.pdf" && totxt gvk.pdf
dl kvk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.5520.pdf" && totxt kvk.pdf
dl kdvk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.3065.pdf" && totxt kdvk.pdf
dl vuk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.4.213.pdf" && totxt vuk.pdf
dl aatuhk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.3.6183.pdf" && totxt aatuhk.pdf
dl otvk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.4760.pdf" && totxt otvk.pdf
dl dvk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.488.pdf" && totxt dvk.pdf
dl vivk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.3.7338.pdf" && totxt vivk.pdf
dl mtvk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.197.pdf" && totxt mtvk.pdf
dl evk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.1319.pdf" && totxt evk.pdf
dl harclar.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.492.pdf" && totxt harclar.pdf
dl ttk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.6102.pdf" && totxt ttk.pdf
dl tbk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.6098.pdf" && totxt tbk.pdf
dl isk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.4857.pdf" && totxt isk.pdf
dl sgk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.5510.pdf" && totxt sgk.pdf
dl iyuk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.2577.pdf" && totxt iyuk.pdf
dl spkn.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.6362.pdf" && totxt spkn.pdf
dl smmm_kanunu.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.3568.pdf" && totxt smmm_kanunu.pdf
dl sendikalar.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.6356.pdf" && totxt sendikalar.pdf
dl is_mahkemeleri.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.7036.pdf" && totxt is_mahkemeleri.pdf
dl kmyk.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.5018.pdf" && totxt kmyk.pdf
dl idare_mahkemeleri.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/1.5.2576.pdf" && totxt idare_mahkemeleri.pdf

# ---- A) Meslek hukuku ----
dl calisma_usul_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/2026Yonetm/4-CalismaUsul.pdf" && totxt calisma_usul_yon.pdf
dl etik_ilkeler_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/3568YASAYONETMELIK7NISAN2025/14-SMMM-YMMEtik.pdf" && totxt etik_ilkeler_yon.pdf
dl haksiz_rekabet_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/3568YASAYONETMELIK7NISAN2025/13-SMMM-YMMHaks%C4%B1zRekabet.pdf" && totxt haksiz_rekabet_yon.pdf
dl disiplin_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/2026Yonetm/15-Disiplin.pdf" && totxt disiplin_yon.pdf
dl smmm_odalari_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/2026Yonetm/5-SMMMOdalari.pdf" && totxt smmm_odalari_yon.pdf
dl ymm_odalari_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/2026Yonetm/6-YMMOdalari.pdf" && totxt ymm_odalari_yon.pdf
dl turmob_birlik_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/2026Yonetm/7-TURMOB.pdf" && totxt turmob_birlik_yon.pdf
dl ucretler_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/3568YASAYONETMELIK7NISAN2025/2-SMMM-YMMUcretler.pdf" && totxt ucretler_yon.pdf
dl smge_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/2026Yonetm/19-SURGEM.pdf" && totxt smge_yon.pdf
dl ymm_tasdik_yon.pdf "https://www.turmob.org.tr/Arsiv/FCKEditor/userfiles/file/3568YASAYONETMELIK7NISAN2025/3-YMMTasdik.pdf" && totxt ymm_tasdik_yon.pdf
dl smmm_ucret_tarifesi_2026.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42771.pdf" && totxt smmm_ucret_tarifesi_2026.pdf
dl smmm_ucret_tarifesi_2026_ek.xlsx "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42771-EK.xlsx" && office2txt smmm_ucret_tarifesi_2026_ek.xlsx

# ---- B) Denetim ----
dl bagimsiz_denetim_yon.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=16907&mevzuatTur=KurumVeKurulusYonetmeligi&mevzuatTertip=5" && totxt bagimsiz_denetim_yon.pdf
dl bd_etik_kurallar.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BagimsizDenetcilerIcinEtik%20Kurallar_11_08_2025.pdf" && totxt bd_etik_kurallar.pdf
dl kys_1.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/KYS%201_2025.pdf" && totxt kys_1.pdf
dl kys_2.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/KYS%202_2025.pdf" && totxt kys_2.pdf
dl bds_200.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20200_2025.pdf" && totxt bds_200.pdf
dl bds_210.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20210_2025.pdf" && totxt bds_210.pdf
dl bds_220.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20220_2025.pdf" && totxt bds_220.pdf
dl bds_230.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20230_2025.pdf" && totxt bds_230.pdf
dl bds_240.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20240_2025.pdf" && totxt bds_240.pdf
dl bds_250.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20250_2025.pdf" && totxt bds_250.pdf
dl bds_260.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20260_2025.pdf" && totxt bds_260.pdf
dl bds_265.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20265_2025.pdf" && totxt bds_265.pdf
dl bds_300.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20300_2025.pdf" && totxt bds_300.pdf
dl bds_315.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20315_2025.pdf" && totxt bds_315.pdf
dl bds_320.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20320_2025.pdf" && totxt bds_320.pdf
dl bds_330.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20330_2025.pdf" && totxt bds_330.pdf
dl bds_402.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20402_2025(1).pdf" && totxt bds_402.pdf
dl bds_450.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20450_2025.pdf" && totxt bds_450.pdf
dl bds_500.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20500_2025.pdf" && totxt bds_500.pdf
dl bds_501.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20501_2025.pdf" && totxt bds_501.pdf
dl bds_505.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20505_2025.pdf" && totxt bds_505.pdf
dl bds_510.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20510_2025.pdf" && totxt bds_510.pdf
dl bds_520.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20520_2025.pdf" && totxt bds_520.pdf
dl bds_530.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20530_2025.pdf" && totxt bds_530.pdf
dl bds_540.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20540_2025.pdf" && totxt bds_540.pdf
dl bds_550.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20550_2025.pdf" && totxt bds_550.pdf
dl bds_560.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20560_2025.pdf" && totxt bds_560.pdf
dl bds_570.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20570_2025.pdf" && totxt bds_570.pdf
dl bds_580.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20580_2025.pdf" && totxt bds_580.pdf
dl bds_600.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20600_2026.pdf" && totxt bds_600.pdf
dl bds_610.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20610_2025.pdf" && totxt bds_610.pdf
dl bds_620.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20620_2025.pdf" && totxt bds_620.pdf
dl bds_700.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20700_2025.pdf" && totxt bds_700.pdf
dl bds_701.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20701_2025.pdf" && totxt bds_701.pdf
dl bds_705.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20705_2025.pdf" && totxt bds_705.pdf
dl bds_706.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20706_2025.pdf" && totxt bds_706.pdf
dl bds_710.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20710_2025.pdf" && totxt bds_710.pdf
dl bds_720.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20720_2025(1).pdf" && totxt bds_720.pdf
dl bds_800.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20800_2025.pdf" && totxt bds_800.pdf
dl bds_805.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20805_2025.pdf" && totxt bds_805.pdf
dl bds_810.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/BDS%20810_2025.pdf" && totxt bds_810.pdf
dl sbds_2400.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/SBDS%202400_2025(1).pdf" && totxt sbds_2400.pdf
dl sbds_2410.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/SBDS%202410_2025.pdf" && totxt sbds_2410.pdf
dl gds_3000.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/GDS%203000_2025__.pdf" && totxt gds_3000.pdf
dl ihs_4400.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/%C4%B0HS%204400_2025.pdf" && totxt ihs_4400.pdf
dl ihs_4410.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TDS/TDS_2025_Seti/%C4%B0HS%204410_2025.pdf" && totxt ihs_4410.pdf

# ---- C) Muhasebe ----
dl kavramsal_cerceve.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Finansal%20Raporlamaya%20%C4%B0li%C5%9Fkin%20Kavramsal%20%C3%87er%C3%A7eve.pdf" && totxt kavramsal_cerceve.pdf
dl tfrs_3.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%203.pdf" && totxt tfrs_3.pdf
dl tfrs_5.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%205.pdf" && totxt tfrs_5.pdf
dl tfrs_8.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%208.pdf" && totxt tfrs_8.pdf
dl tfrs_9.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%209.pdf" && totxt tfrs_9.pdf
dl tfrs_10.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%2010.pdf" && totxt tfrs_10.pdf
dl tfrs_15.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%2015.pdf" && totxt tfrs_15.pdf
dl tfrs_16.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TFRS/TFRS%2016.pdf" && totxt tfrs_16.pdf
dl tms_1.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%201.pdf" && totxt tms_1.pdf
dl tms_2.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%202.pdf" && totxt tms_2.pdf
dl tms_7.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS7.pdf" && totxt tms_7.pdf
dl tms_8.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%208.pdf" && totxt tms_8.pdf
dl tms_10.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2010.pdf" && totxt tms_10.pdf
dl tms_12.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS_12.pdf" && totxt tms_12.pdf
dl tms_16.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2016.pdf" && totxt tms_16.pdf
dl tms_19.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2019.pdf" && totxt tms_19.pdf
dl tms_20.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2020.pdf" && totxt tms_20.pdf
dl tms_21.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS_21.pdf" && totxt tms_21.pdf
dl tms_23.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2023.pdf" && totxt tms_23.pdf
dl tms_24.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2024.pdf" && totxt tms_24.pdf
dl tms_27.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS27.pdf" && totxt tms_27.pdf
dl tms_28.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2028.pdf" && totxt tms_28.pdf
dl tms_29.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2029.pdf" && totxt tms_29.pdf
dl tms_33.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS33.pdf" && totxt tms_33.pdf
dl tms_34.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2034.pdf" && totxt tms_34.pdf
dl tms_36.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2036.pdf" && totxt tms_36.pdf
dl tms_37.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2037.pdf" && totxt tms_37.pdf
dl tms_38.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2038.pdf" && totxt tms_38.pdf
dl tms_40.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2040.pdf" && totxt tms_40.pdf
dl tms_41.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Mavi_Kitap/TMS/TMS%2041.pdf" && totxt tms_41.pdf
dl tfrs_18.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/TMS_TFRS_Setleri/2026/Kirmizi_Kitap/TFRS/TFRS%2018%20.pdf" && totxt tfrs_18.pdf
dl bobi_frs.pdf "https://www.kgk.gov.tr/Portalv2Uploads/files/Duyurular/v2/BOB%C4%B0_FRS/BOBIFRS2021S%C3%BCr%C3%BCm%C3%BC.pdf" && totxt bobi_frs.pdf
curl -sf -m 300 -A "$UA" -X POST -H 'Content-Type: application/json' "https://gib.gov.tr/api/gibportal/mevzuat/teblig/list?page=0&size=3000" -d '{}' -o "$TMP/gibteb.json"
# MSUGT ana metni ve 2–15 değişiklik tebliğleri GİB API kayıtlarının "description" (HTML) alanından üretilir:
python3 - "$TMP/gibteb.json" <<'PY'
import json,re,html,sys
def h2t(s):
    s=re.sub(r"(?is)<(script|style)[^>]*>.*?</\1>","",s); s=re.sub(r"(?i)<br\s*/?>","\n",s)
    s=re.sub(r"(?i)</(p|div|tr|h[1-6]|li|table)>","\n",s); s=re.sub(r"(?i)</t[dh]>","\t",s)
    s=html.unescape(re.sub(r"<[^>]+>","",s)).replace("\xa0"," ")
    s=re.sub(r"[ \t]+\n","\n",s); s=re.sub(r"\n{3,}","\n\n",s); return s.strip()+"\n"
rows={r["id"]:r for r in json.load(open(sys.argv[1]))["resultContainer"]["content"]}
r=rows[10705]
open("msugt_1.txt","w").write(f"1 SIRA NO'LU MUHASEBE SİSTEMİ UYGULAMA GENEL TEBLİĞİ\nRG: 26.12.1992 / 21447 (Mükerrer)\nKaynak: {r['siteLink']} (GİB portalı, API kaydı id=10705)\n\n"+h2t(r["description"]))
xs=sorted([x for x in rows.values() if "MUHASEBE SİSTEMİ UYGULAMA" in x["title"] and 10691<=x["id"]<=10704],key=lambda x:x["resmiGazeteTarih"])
buf=["MUHASEBE SİSTEMİ UYGULAMA GENEL TEBLİĞLERİ – SIRA NO 2–15 (değişiklik tebliğleri)\nKaynak: GİB portalı (https://gib.gov.tr/api/gibportal/mevzuat/teblig/list), her bölümün başında kayıt bağlantısı verilmiştir.\n"]
for x in xs:
    buf.append("\n"+"="*78+f"\n{x['title'].strip()}\nRG: {x['resmiGazeteTarih'][:10]} / {x.get('resmiGazeteSayi')}\nKaynak: {x.get('siteLink')}\n"+"="*78+"\n"+h2t(x.get("description") or ""))
open("msugt_2_15.txt","w").write("\n".join(buf)); print("üretildi: msugt_1.txt, msugt_2_15.txt")
PY
{ echo "MSUGT Sıra No 1 – Ek 1"; echo "Kaynak: https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh1.html"; echo; curl -sfL -m 120 -A "$UA" "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh1.html" | h2t | sed "1{/^muhsisteb1ekmuh/d}"; } > msugt_1_ek1_temel_kavramlar.txt && echo "indirildi: msugt_1_ek1_temel_kavramlar.txt"
{ echo "MSUGT Sıra No 1 – Ek 2"; echo "Kaynak: https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh2.html"; echo; curl -sfL -m 120 -A "$UA" "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh2.html" | h2t | sed "1{/^muhsisteb1ekmuh/d}"; } > msugt_1_ek2_muhasebe_politikalari.txt && echo "indirildi: msugt_1_ek2_muhasebe_politikalari.txt"
{ echo "MSUGT Sıra No 1 – Ek 3"; echo "Kaynak: https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh3.html"; echo; curl -sfL -m 120 -A "$UA" "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh3.html" | h2t | sed "1{/^muhsisteb1ekmuh/d}"; } > msugt_1_ek3_mali_tablolar_ilkeleri.txt && echo "indirildi: msugt_1_ek3_mali_tablolar_ilkeleri.txt"
{ echo "MSUGT Sıra No 1 – Ek 4"; echo "Kaynak: https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh4.html"; echo; curl -sfL -m 120 -A "$UA" "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/yedek/fileadmin/mevzuatek/eski/muhsisteb1ekmuh4.html" | h2t | sed "1{/^muhsisteb1ekmuh/d}"; } > msugt_1_ek4_mali_tablolar_duzenlenmesi.txt && echo "indirildi: msugt_1_ek4_mali_tablolar_duzenlenmesi.txt"
dl msugt_1_ek5_thp_guncel.pdf "https://cdn.gib.gov.tr/api/gibportal-file/file/getFile?objectKey=MEVZUAT_TEBLIGLER/UNIVERSAL/2025/arsiv_yedek_fileadmin_mevzuatek_eski_muhsisteb1ekmuh5_04102019.pdf" && totxt msugt_1_ek5_thp_guncel.pdf
dl msugt_1_ek5_thp_dipnotlu.pdf "https://cdn.gib.gov.tr/api/gibportal-file/file/getFile?objectKey=MEVZUAT_TEBLIGLER/2025/213_Teblig1MS_Ek5.pdf" && totxt msugt_1_ek5_thp_dipnotlu.pdf

# ---- D) Vergi tebliğleri ve kararlar ----
dl kdv_gut.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.19631.pdf" && totxt kdv_gut.pdf
dl kv_genel_teblig_1.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.11219.pdf" && totxt kv_genel_teblig_1.pdf
dl yerel_kuresel_asgari_kv_teblig.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42811.pdf" && totxt yerel_kuresel_asgari_kv_teblig.pdf
dl otv_2_liste_teblig.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.20695.pdf" && totxt otv_2_liste_teblig.pdf
dl otv_3_liste_teblig.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.21034.pdf" && totxt otv_3_liste_teblig.pdf
dl otv_4_liste_teblig.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.21063.pdf" && totxt otv_4_liste_teblig.pdf
dl gv_teblig_329_2025.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.41166.pdf" && totxt gv_teblig_329_2025.pdf
dl gv_teblig_332_2026.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42890.pdf" && totxt gv_teblig_332_2026.pdf
dl vuk_teblig_577_2025.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.41168.pdf" && totxt vuk_teblig_577_2025.pdf
dl vuk_teblig_588_2026.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42892.pdf" && totxt vuk_teblig_588_2026.pdf
dl otv_1_liste_teblig.pdf "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/fileadmin/user_upload/Tebligler/OTV_Kanunu/1sayili_liste.pdf" && ocr2txt otv_1_liste_teblig.pdf   # OCR; fgk_cbk_3490.txt içindeki %10 düzeltmesi elle yapılmıştı
dl kv_teblig_23_asgari_kv.pdf "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/fileadmin/mevzuatek/kurumlarteblig23.pdf" && ocr2txt kv_teblig_23_asgari_kv.pdf   # OCR; fgk_cbk_3490.txt içindeki %10 düzeltmesi elle yapılmıştı
dl fgk_cbk_3490.pdf "https://cdn.gib.gov.tr/api/gibportal-file/file/getFileResources?objectKey=arsiv/fileadmin/user_upload/Cumhurbaskani_Karari/3490.pdf" && ocr2txt fgk_cbk_3490.pdf   # OCR; fgk_cbk_3490.txt içindeki %10 düzeltmesi elle yapılmıştı
dl gvk_teblig_332.pdf "https://www.resmigazete.gov.tr/eskiler/2025/12/20251231M5-30.pdf"   # .txt özel glif çözümlemesiyle üretilmişti; pdftotext anlamsız çıktı verir
dl vuk_teblig_577_2025_ek.docx "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.41168-Ek.docx" && office2txt vuk_teblig_577_2025_ek.docx
dl otv_3_liste_teblig_ek.docx "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.21034-EK.docx" && office2txt otv_3_liste_teblig_ek.docx
dl otv_4_liste_teblig_ek.docx "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.21063-EK.docx" && office2txt otv_4_liste_teblig_ek.docx
[ -f "$TMP/otv2.zip" ] || curl -sfL -m 180 -A "$UA" -o "$TMP/otv2.zip" "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.20695-Ek.zip"
unzip -p "$TMP/otv2.zip" "9.5.20695 Ek/9.5.20695-ek.pdf" > otv_2_liste_teblig_ek.pdf && echo "çıkarıldı: otv_2_liste_teblig_ek.pdf" && totxt otv_2_liste_teblig_ek.pdf
[ -f "$TMP/otv2.zip" ] || curl -sfL -m 180 -A "$UA" -o "$TMP/otv2.zip" "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.20695-Ek.zip"
unzip -p "$TMP/otv2.zip" "9.5.20695 Ek/EK 1.docx" > otv_2_liste_teblig_ek1.docx && echo "çıkarıldı: otv_2_liste_teblig_ek1.docx" && office2txt otv_2_liste_teblig_ek1.docx

# ---- E) SPK tebliğleri ----
dl spk_ii_5_1_izahname.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=18509&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_5_1_izahname.pdf
dl spk_ii_5_2_satis.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=18527&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_5_2_satis.pdf
dl spk_ii_15_1_ozel_durumlar.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=19331&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_15_1_ozel_durumlar.pdf
dl spk_ii_23_2_birlesme_bolunme.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=19190&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_23_2_birlesme_bolunme.pdf
dl spk_ii_23_3_onemli_islemler.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=34645&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_23_3_onemli_islemler.pdf
dl spk_iii_37_1_yatirim_hizmetleri.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=18576&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_iii_37_1_yatirim_hizmetleri.pdf
dl spk_iii_52_1_yatirim_fonlari.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.18564.pdf" && totxt spk_iii_52_1_yatirim_fonlari.pdf
dl spk_ii_19_1_kar_payi.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=19333&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_19_1_kar_payi.pdf
dl spk_ii_17_1_kurumsal_yonetim.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=19225&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_17_1_kurumsal_yonetim.pdf
dl spk_ii_18_1_kayitli_sermaye.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=19167&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_ii_18_1_kayitli_sermaye.pdf
dl spk_vii_128_1_pay.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.18510.pdf" && totxt spk_vii_128_1_pay.pdf
dl spk_iii_48_1_gyo.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=18404&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_iii_48_1_gyo.pdf
dl spk_iii_35a_2_kitle_fonlamasi.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=39017&mevzuatTur=Teblig&mevzuatTertip=5" && totxt spk_iii_35a_2_kitle_fonlamasi.pdf
dl spk_iii_35b_1_kripto_kurulus.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42329.pdf" && totxt spk_iii_35b_1_kripto_kurulus.pdf
dl spk_iii_35b_2_kripto_calisma.pdf "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42327.pdf" && totxt spk_iii_35b_2_kripto_calisma.pdf
dl spk_ii_5_2_satis_ek.doc "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.18527%20ek.doc" && office2txt spk_ii_5_2_satis_ek.doc
dl spk_iii_48_1_gyo_ek.doc "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.18404-EK.doc" && office2txt spk_iii_48_1_gyo_ek.doc
dl spk_iii_35a_2_kitle_fonlamasi_ek.docx "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.39017-Ek.docx" && office2txt spk_iii_35a_2_kitle_fonlamasi_ek.docx
dl spk_iii_35b_1_kripto_kurulus_ek.docx "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/9.5.42329-Ek.docx" && office2txt spk_iii_35b_1_kripto_kurulus_ek.docx

# ---- F) SGK / İş ----
dl sosyal_sigorta_islemleri_yon.pdf "https://www.mevzuat.gov.tr/File/GeneratePdf?mevzuatNo=13973&mevzuatTur=KurumVeKurulusYonetmeligi&mevzuatTertip=5" && totxt sosyal_sigorta_islemleri_yon.pdf
dl sosyal_sigorta_islemleri_yon_ekler.zip "https://www.mevzuat.gov.tr/MevzuatMetin/yonetmelik/7.5.13973-Ek.zip"  # ekler: unzip + office2txt ile tek .txt’de birleştirilmişti (bkz. KAYNAKLAR.md)

# ---- kontrol ----
sha256sum $(ls | grep -v -E "\.txt$|^KAYNAKLAR\.md$|^indir\.sh$") 2>/dev/null; sha256sum msugt_*.txt
