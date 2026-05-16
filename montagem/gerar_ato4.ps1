# gerar_ato4.ps1
# Homenagem Marlene — Ato 4: Despedida e Legado (4:11 – 5:14)
# Salvar este arquivo em UTF-8 antes de executar.

$temp   = "$PSScriptRoot\temp"
$assets = "$PSScriptRoot\..\assets"
$fonte  = "C\:/Windows/Fonts/Georgia.ttf"

# --- segmentos ---

# 26 — Chapeu vermelho, fade in muito lento (14s)
ffmpeg -y -loop 1 -i "$assets\IMG_20241027_144232221_HDR_PORTRAIT.jpg" `
    -vf "scale=1280x720,fade=t=in:st=0:d=5" `
    -t 14 -c:v libx264 -pix_fmt yuv420p "$temp\26_chapeuvermelho_final.mp4"

# 27 — Mesma foto desfocada + frase dela (13s)
ffmpeg -y -loop 1 -i "$assets\IMG_20241027_144232221_HDR_PORTRAIT.jpg" `
    -vf "scale=1280x720,gblur=sigma=8,fade=t=in:st=0:d=2,drawtext=fontfile=${fonte}:text=Vai dar certo\, seu fresco!!!:fontcolor=white:fontsize=50:x=(w-text_w)/2:y=(h-text_h)/2" `
    -t 13 -c:v libx264 -pix_fmt yuv420p "$temp\27_frase_vai.mp4"

# 28 — Foto escurece + frase de encerramento (10s)
ffmpeg -y -loop 1 -i "$assets\IMG_20241027_144232221_HDR_PORTRAIT.jpg" `
    -vf "scale=1280x720,gblur=sigma=4,fade=t=out:st=1:d=7,drawtext=fontfile=${fonte}:text=Honrar a mae e honrar a origem.:fontcolor=white:fontsize=42:x=(w-text_w)/2:y=(h-text_h)/2" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\28_frase_origem.mp4"

# 29 — Dedicatoria (7s)
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 `
    -vf "drawtext=fontfile=${fonte}:text=Com amor eterno - Mayko e os seus filhos:fontcolor=white:fontsize=38:x=(w-text_w)/2:y=(h-text_h)/2" `
    -t 7 -c:v libx264 -pix_fmt yuv420p "$temp\29_dedicatoria.mp4"

# 30 — In memoriam, fade out final (10s)
# Nota: "Conceicao" sem cedilha — para usar o c-cedilha correto, confirmar encoding UTF-8 deste arquivo
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 `
    -vf "drawtext=fontfile=${fonte}:text=In memoriam - Marlene Rodrigues da Conceicao:fontcolor=white:fontsize=36:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=out:st=8:d=2" `
    -t 10 -c:v libx264 -pix_fmt yuv420p "$temp\30_in_memoriam.mp4"

# 31 — Preto absoluto, silencio final (9s)
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 `
    -t 9 -c:v libx264 -pix_fmt yuv420p "$temp\31_preto_final.mp4"

Write-Host ""
Write-Host "Ato 4 concluido. Segmentos em: $temp"
Write-Host "Total esperado: 63s (26..31 = 14+13+10+7+10+9)"
