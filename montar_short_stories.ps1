# ============================================================
# montar_short_stories.ps1 - Homenagem Marlene - Stories 9:16
# 1080x1920 | Fundo desfocado + foto centrada + Ken Burns
# ============================================================

$BASE    = "C:\Users\mayko\homenagem-mae"
$A       = "$BASE\assets"
$R       = "$BASE\revividas"
$MUSICA  = "$BASE\musica.mp3"
$OUT     = "$BASE\montagem"
$TEMP    = "$BASE\montagem\temp_stories"

$W   = 1080
$H   = 1920
$FPS = 25

New-Item -ItemType Directory -Force $OUT  | Out-Null
New-Item -ItemType Directory -Force $TEMP | Out-Null

Write-Host ""
Write-Host "=== Homenagem Marlene - Stories 9:16 ===" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------
# FUNCOES
# ---------------------------------------------------------------

function Make-Photo {
    param($id, $foto, $dur, $kb_dir = "zoom_in")
    $out = "$TEMP\$id.mp4"
    if (Test-Path $out) { return $out }

    $frames = $dur * $FPS

    # Zoom suave (menor que horizontal — evita artefatos no fundo desfocado)
    switch ($kb_dir) {
        "zoom_in"   { $zoom = "z='min(zoom+0.0005,1.12)'"; $xp = "x='iw/2-(iw/zoom/2)'"; $yp = "y='ih/2-(ih/zoom/2)'" }
        "zoom_out"  { $zoom = "z='if(lte(zoom,1.0),1.12,max(1.0,zoom-0.0007))'"; $xp = "x='iw/2-(iw/zoom/2)'"; $yp = "y='ih/2-(ih/zoom/2)'" }
        "pan_right" { $zoom = "z='1.08'"; $xp = "x='if(gte(on,1),x+0.25,0)'";       $yp = "y='ih/2-(ih/zoom/2)'" }
        "pan_left"  { $zoom = "z='1.08'"; $xp = "x='if(gte(on,1),x-0.25,iw*0.08)'"; $yp = "y='ih/2-(ih/zoom/2)'" }
    }

    # BG: mesma foto escalonada para preencher 9:16, desfocada
    # FG: foto escalonada para caber dentro do frame (preserva faces)
    # Resultado: overlay FG centrada sobre BG + Ken Burns no conjunto
    $fc  = "[0:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},boxblur=30:5[bg];"
    $fc += "[0:v]scale=${W}:${H}:force_original_aspect_ratio=decrease[fg];"
    $fc += "[bg][fg]overlay=(W-w)/2:(H-h)/2[ovl];"
    $fc += "[ovl]zoompan=$zoom`:d=$frames`:$xp`:$yp`:s=${W}x${H},fps=$FPS,format=yuv420p[out]"

    ffmpeg -y -loop 1 -i $foto -filter_complex $fc -map "[out]" -t $dur -an "$out" 2>$null
    Write-Host "  [ok] $id"
    return $out
}

function Make-Text {
    param($id, $linha1, $linha2 = "", $dur = 5, $cor = "white", $tam1 = 90, $tam2 = 62)
    $out = "$TEMP\$id.mp4"
    if (Test-Path $out) { return $out }

    $fonte  = "C\:/Windows/Fonts/arialbd.ttf"
    $source = "color=c=0x111111:s=${W}x${H}:r=$FPS"

    if ($linha2 -ne "") {
        $yc = [int]($H / 2)
        $vf = "drawtext=fontfile='$fonte':text='$linha1':fontcolor=${cor}:fontsize=${tam1}:x=(w-text_w)/2:y=$($yc-65),drawtext=fontfile='$fonte':text='$linha2':fontcolor=0xE8D5A3:fontsize=${tam2}:x=(w-text_w)/2:y=$($yc+30),format=yuv420p"
    } else {
        $vf = "drawtext=fontfile='$fonte':text='$linha1':fontcolor=${cor}:fontsize=${tam1}:x=(w-text_w)/2:y=(h-text_h)/2,format=yuv420p"
    }

    ffmpeg -y -f lavfi -i $source -vf $vf -t $dur -pix_fmt yuv420p "$out" 2>$null
    if (Test-Path $out) { Write-Host "  [ok] $id" } else { Write-Host "  [ERRO] $id" -ForegroundColor Red }
    return $out
}

function Make-Black {
    param($id, $dur = 2)
    $out = "$TEMP\$id.mp4"
    if (Test-Path $out) { return $out }
    ffmpeg -y -f lavfi -i "color=c=black:s=${W}x${H}:r=$FPS" -t $dur -pix_fmt yuv420p "$out" 2>$null
    Write-Host "  [ok] $id"
    return $out
}

function Scale-Video {
    param($id, $src)
    $out = "$TEMP\$id.mp4"
    if (Test-Path $out) { return $out }
    # Veo videos (16:9) → fundo desfocado + video centrado
    $fc  = "[0:v]scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},boxblur=30:5[bg];"
    $fc += "[0:v]scale=${W}:${H}:force_original_aspect_ratio=decrease[fg];"
    $fc += "[bg][fg]overlay=(W-w)/2:(H-h)/2,format=yuv420p[out]"
    ffmpeg -y -i $src -filter_complex $fc -map "[out]" -an "$out" 2>$null
    Write-Host "  [ok] $id"
    return $out
}

# ---------------------------------------------------------------
# SEGMENTOS
# ---------------------------------------------------------------
Write-Host "Gerando segmentos..." -ForegroundColor Yellow

$segs = @()

$segs += Make-Black  "s01_preto"                                                                      3
$segs += Make-Photo  "s02_casamento"          "$A\casamento-marlene-pai.jpg"                          5  "zoom_in"
$segs += Make-Text   "s03_nome"               "MARLENE"                                           ""  3  "white"   110
$segs += Make-Text   "s04_datas"              "20 outubro 1955 - 22 junho 2025"                   ""  4  "#AAAAAA" 42

$segs += Make-Photo  "s05_igreja_guitarra"    "$A\IMG-20151030-WA0009.jpg"                            9  "pan_right"
$segs += Make-Photo  "s06_sofa_mayko"         "$A\IMG-20160423-WA0011.jpg"                            6  "zoom_in"
$segs += Make-Photo  "s07_selfie_familia"     "$A\IMG-20161022-WA0016.jpg"                            6  "zoom_out"
$segs += Make-Photo  "s08_mayko_mae_bebe"     "$A\IMG-20160825-WA0001.jpg"                            5  "pan_right"

$segs += Make-Photo  "s09_chapeu_julia"       "$A\IMG_20241027_144232221_HDR_PORTRAIT.jpg"             5  "zoom_in"
$segs += Scale-Video "s10_chapeu_veo"         "$R\v03_chapeuvermelho-julia.mp4"
$segs += Make-Photo  "s11_climax_davi"        "$A\IMG_20250201_172114541_HDR.jpg"                      7  "zoom_in"
$segs += Scale-Video "s12_climax_veo"         "$R\v02_marlene-davi-bolo.mp4"

$segs += Make-Text   "s13_frase1"             "Vai dar certo,"                                    ""  3  "white"   78
$segs += Make-Text   "s14_frase2"             "seu fresco!!!"                                     ""  4  "#E8D5A3" 88
$segs += Make-Text   "s15_in_memoriam"        "In memoriam" "Marlene Rodrigues da Conceicao"          5  "#E8D5A3" 62  42
$segs += Make-Black  "s16_fim"                                                                         4

# ---------------------------------------------------------------
# CONCATENAR VIDEO
# ---------------------------------------------------------------
Write-Host ""
Write-Host "Concatenando video..." -ForegroundColor Yellow

$concat_list = "$TEMP\concat.txt"
($segs | ForEach-Object { "file '$_'" }) | Out-File -Encoding ascii $concat_list

$video_sem_audio = "$TEMP\video_sem_audio.mp4"
ffmpeg -y -f concat -safe 0 -i $concat_list `
    -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p `
    -r $FPS -an `
    $video_sem_audio 2>$null
Write-Host "  [ok] video_sem_audio.mp4"

$dur_str    = ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $video_sem_audio
$dur_video  = [double]($dur_str -replace "duration=","")
$fade_start = [math]::Max(0, $dur_video - 5)
$music_dur  = [math]::Ceiling($dur_video + 3)

Write-Host "  Duracao do video: $([math]::Round($dur_video, 1))s"

# ---------------------------------------------------------------
# MUSICA — trecho 2:10 (refrao principal)
# ---------------------------------------------------------------
Write-Host "Preparando musica..." -ForegroundColor Yellow

$musica_trim = "$TEMP\musica_trim.aac"
ffmpeg -y `
    -ss 130 `
    -i $MUSICA `
    -t $music_dur `
    -af "afade=t=in:st=0:d=3,afade=t=out:st=${fade_start}:d=5" `
    -c:a aac -b:a 192k `
    $musica_trim 2>$null
Write-Host "  [ok] musica_trim.aac"

# ---------------------------------------------------------------
# MIX FINAL
# ---------------------------------------------------------------
Write-Host "Mixando audio e video..." -ForegroundColor Yellow

$output_final = "$OUT\homenagem_marlene_stories_v01_1080x1920.mp4"
ffmpeg -y `
    -i $video_sem_audio `
    -i $musica_trim `
    -map 0:v -map 1:a `
    -c:v copy -c:a copy `
    -shortest `
    $output_final 2>$null

$dur_str2  = ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $output_final
$dur_final = [double]($dur_str2 -replace "duration=","")
$min = [math]::Floor($dur_final / 60)
$sec = [math]::Round($dur_final % 60)

Write-Host ""
Write-Host "=== CONCLUIDO ===" -ForegroundColor Green
Write-Host "Arquivo : $output_final" -ForegroundColor Green
Write-Host "Resolucao: 1080x1920 (9:16 Stories/Reels)" -ForegroundColor Green
Write-Host "Duracao : ${min}min ${sec}s" -ForegroundColor Green
Write-Host ""
Write-Host "Pronto para Instagram Stories ou Reels." -ForegroundColor Cyan
Write-Host ""
