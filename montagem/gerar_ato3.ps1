# gerar_ato3.ps1
# Homenagem Marlene — Ato 3: O que ela deixou (2:21 – 4:11)
# Salvar este arquivo em UTF-8 antes de executar.

$temp   = "$PSScriptRoot\temp"
$assets = "$PSScriptRoot\..\assets"
$rev    = "$PSScriptRoot\..\revividas"

# slide 21: usando substituta indicada por Mayko (171117252 esta rotacionado 90 graus)
$foto_21 = "IMG-20200726-WA0018.jpg"   # aniversario Claudio, jul/2020 — familia reunida

# --- segmentos ---

# 17 — Chapeu vermelho, fade in lento (14s)
ffmpeg -loop 1 -i "$assets\IMG_20241027_144232221_HDR_PORTRAIT.jpg" `
    -vf "scale=1280x720,fade=t=in:st=0:d=3" `
    -t 14 -c:v libx264 -pix_fmt yuv420p "$temp\17_chapeuvermelho.mp4"

# 18 — Ken Burns no rosto (13s) — substituido por Veo se disponivel
if (Test-Path "$rev\v03_chapeuvermelho-julia.mp4") {
    Write-Host "Usando Veo para slide 18."
    ffmpeg -i "$rev\v03_chapeuvermelho-julia.mp4" `
        -vf "scale=1280x720" -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\18_chapeuvermelho_kb.mp4"
} else {
    ffmpeg -loop 1 -i "$assets\IMG_20241027_144232221_HDR_PORTRAIT.jpg" `
        -vf "scale=1920:1080,zoompan=z='zoom+0.0006':x='iw/2-(iw/zoom/2)':y='ih/3-(ih/zoom/3)':d=390:s=1280x720" `
        -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\18_chapeuvermelho_kb.mp4"
}

# 19 — Aniversario Davi (12s) — substituido por Veo se disponivel
if (Test-Path "$rev\v04_aniversario-davi.mp4") {
    Write-Host "Usando Veo para slide 19."
    ffmpeg -i "$rev\v04_aniversario-davi.mp4" `
        -vf "scale=1280x720" -t 12 -c:v libx264 -pix_fmt yuv420p "$temp\19_aniv_davi.mp4"
} else {
    ffmpeg -loop 1 -i "$assets\IMG_20250201_171120224.jpg" `
        -vf "scale=1280x720" `
        -t 12 -c:v libx264 -pix_fmt yuv420p "$temp\19_aniv_davi.mp4"
}

# 20 — Familia reunida (12s)
ffmpeg -loop 1 -i "$assets\IMG_20250201_171115049_HDR.jpg" `
    -vf "scale=1280x720" `
    -t 12 -c:v libx264 -pix_fmt yuv420p "$temp\20_familia.mp4"

# 21 — Familia reunida jul/2020 (10s)
ffmpeg -loop 1 -i "$assets\$foto_21" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\21_familia_b.mp4"

# 22 — FOTO CLIMAX, fade in lento (13s)
ffmpeg -loop 1 -i "$assets\IMG_20250201_172114541_HDR.jpg" `
    -vf "scale=1280x720,fade=t=in:st=0:d=3" `
    -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\22_climax.mp4"

# 23 — Ken Burns nas maos (13s) — substituido por Veo se disponivel
if (Test-Path "$rev\v02_marlene-davi-bolo.mp4") {
    Write-Host "Usando Veo para slide 23."
    ffmpeg -i "$rev\v02_marlene-davi-bolo.mp4" `
        -vf "scale=1280x720" -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\23_climax_kb.mp4"
} else {
    ffmpeg -loop 1 -i "$assets\IMG_20250201_172114541_HDR.jpg" `
        -vf "scale=1920:1080,zoompan=z='zoom+0.0005':x='iw/2-(iw/zoom/2)':y='min(ih*(2/3)-(ih/zoom/2),ih*(1-1/zoom))':d=390:s=1280x720" `
        -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\23_climax_kb.mp4"
}

# 24 — Foto 2025 complementar (10s)
ffmpeg -loop 1 -i "$assets\IMG_20250201_172115623_HDR.jpg" `
    -vf "scale=1280x720" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\24_2025_b.mp4"

# 25 — Fechamento Ato 3, fade out (13s)
ffmpeg -loop 1 -i "$assets\IMG_20250201_171118673_HDR.jpg" `
    -vf "scale=1280x720,fade=t=out:st=11:d=2" `
    -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\25_fechamento_ato3.mp4"

Write-Host ""
Write-Host "Ato 3 concluido. Segmentos em: $temp"
Write-Host "Total esperado: 110s (17..25 = 14+13+12+12+10+13+13+10+13)"
