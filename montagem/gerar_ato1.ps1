# gerar_ato1.ps1
# Homenagem Marlene — Ato 1: A Origem (0:00 – 0:47)
# Salvar este arquivo em UTF-8 antes de executar.

$temp = "$PSScriptRoot\temp"

# --- verificacoes ---

if (-not (Test-Path "$PSScriptRoot\..\assets\casamento-marlene-pai.jpg")) {
    Write-Warning "FOTO AUSENTE: assets\casamento-marlene-pai.jpg - slides 02 e 03 serao pulados."
    Write-Warning "Confirmar com Mayko e copiar a foto antes de continuar."
}

$veo01 = "$PSScriptRoot\..\revividas\v01_casamento.mp4"

# --- segmentos ---

# 01 — Tela preta (3s)
ffmpeg -f lavfi -i color=black:s=1280x720:r=30 -t 3 -c:v libx264 -pix_fmt yuv420p "$temp\01_preto.mp4"

# 02 — Casamento P&B, fade in (7s)
if (Test-Path "$PSScriptRoot\..\assets\casamento-marlene-pai.jpg") {
    ffmpeg -loop 1 -i "$PSScriptRoot\..\assets\casamento-marlene-pai.jpg" `
        -vf "format=gray,scale=1280x720,fade=t=in:st=0:d=3" `
        -t 7 -c:v libx264 -pix_fmt yuv420p "$temp\02_casamento_pb.mp4"
}

# 03 — Ken Burns no rosto (12s) — substituido por Veo se disponivel
if (Test-Path $veo01) {
    Write-Host "Usando Veo para slide 03: $veo01"
    ffmpeg -i $veo01 -vf "scale=1280x720" -c:v libx264 -pix_fmt yuv420p "$temp\03_casamento_kenbur.mp4"
} elseif (Test-Path "$PSScriptRoot\..\assets\casamento-marlene-pai.jpg") {
    ffmpeg -loop 1 -i "$PSScriptRoot\..\assets\casamento-marlene-pai.jpg" `
        -vf "format=gray,scale=1920:1080,zoompan=z='zoom+0.0005':x='iw/2-(iw/zoom/2)':y='ih/3-(ih/zoom/3)':d=360:s=1280x720" `
        -t 12 -c:v libx264 -pix_fmt yuv420p "$temp\03_casamento_kenbur.mp4"
}

# 04 — "MARLENE" (6s)
ffmpeg -f lavfi -i color=black:s=1280x720:r=30 `
    -vf "drawtext=fontfile=C\:/Windows/Fonts/Georgia.ttf:text=MARLENE:fontcolor=#F0E0C0:fontsize=80:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=in:st=0:d=2" `
    -t 6 -c:v libx264 -pix_fmt yuv420p "$temp\04_titulo_marlene.mp4"

# 05 — Sobrenome (6s)
ffmpeg -f lavfi -i color=black:s=1280x720:r=30 `
    -vf "drawtext=fontfile=C\:/Windows/Fonts/Georgia.ttf:text=Rodrigues da Conceicao:fontcolor=white:fontsize=48:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=in:st=0:d=2" `
    -t 6 -c:v libx264 -pix_fmt yuv420p "$temp\05_titulo_sobrenome.mp4"

# 06 — Datas (8s)
ffmpeg -f lavfi -i color=black:s=1280x720:r=30 `
    -vf "drawtext=fontfile=C\:/Windows/Fonts/Georgia.ttf:text=20 de outubro de 1955 - 22 de junho de 2025:fontcolor=white:fontsize=36:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=in:st=0:d=2" `
    -t 8 -c:v libx264 -pix_fmt yuv420p "$temp\06_titulo_datas.mp4"

# 07 — Fade para preto / transicao (5s)
ffmpeg -f lavfi -i color=black:s=1280x720:r=30 `
    -t 5 -c:v libx264 -pix_fmt yuv420p "$temp\07_fade_preto.mp4"

Write-Host ""
Write-Host "Ato 1 concluido. Segmentos em: $temp"
Write-Host "Total esperado: 47s (01+02+03+04+05+06+07 = 3+7+12+6+6+8+5)"
