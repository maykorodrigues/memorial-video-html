# gerar_ato2.ps1
# Homenagem Marlene — Ato 2: Quem ela foi (0:47 – 2:21)
# Salvar este arquivo em UTF-8 antes de executar.

$temp   = "$PSScriptRoot\temp"
$assets = "$PSScriptRoot\..\assets"

# --- fotos confirmadas por Mayko ---
$foto_11 = "IMG-20180524-WA0000.jpg"   # Marlene de chapeu e oculos
$foto_13 = "IMG-20181224-WA0008.jpg"   # evento Casados para Sempre (dez/2018)
$foto_14 = "IMG-20180402-WA0012.jpg"   # casal no parque

# --- segmentos ---

# 08 — Casamento colorido, fade in (15s)
ffmpeg -loop 1 -i "$assets\casamento-marlene-pai.jpg" `
    -vf "scale=1280x720,fade=t=in:st=0:d=2" `
    -t 15 -c:v libx264 -pix_fmt yuv420p "$temp\08_casamento_color.mp4"

# 09 — 2013 familia (10s)
ffmpeg -loop 1 -i "$assets\20130907_205255.jpg" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\09_2013_a.mp4"

# 10 — 2013 grupo, Ken Burns (10s)
ffmpeg -loop 1 -i "$assets\20130907_205356.jpg" `
    -vf "scale=1920:1080,zoompan=z='zoom+0.001':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=300:s=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\10_2013_b_kb.mp4"

# 11 — Marlene de chapeu e oculos (8s)
ffmpeg -loop 1 -i "$assets\$foto_11" `
    -vf "scale=1280x720" `
    -t 8 -c:v libx264 -pix_fmt yuv420p "$temp\11_2015.mp4"

# 12 — 2016 evento outubro (10s)
ffmpeg -loop 1 -i "$assets\IMG-20161022-WA0009.jpg" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\12_2016_a.mp4"

# 13 — Casados para Sempre (10s)
ffmpeg -loop 1 -i "$assets\$foto_13" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\13_2016_b.mp4"

# 14 — Casal no parque (10s)
ffmpeg -loop 1 -i "$assets\$foto_14" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\14_2016_c.mp4"

# 15 — Natal dez/2018 (10s) — usando 20181201 pois 20181224 ja esta no slide 13
ffmpeg -loop 1 -i "$assets\20181201_105825.jpg" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\15_2018_natal.mp4"

# 16 — 2019/2020, fade out para Ato 3 (11s)
ffmpeg -loop 1 -i "$assets\IMG-20190120-WA0015.jpg" `
    -vf "scale=1280x720,fade=t=out:st=9:d=2" `
    -t 11 -c:v libx264 -pix_fmt yuv420p "$temp\16_2019_2020.mp4"

Write-Host ""
Write-Host "Ato 2 concluido. Segmentos em: $temp"
Write-Host "Total esperado: 94s (08..16 = 15+10+10+8+10+10+10+10+11)"
