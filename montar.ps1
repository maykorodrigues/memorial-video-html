# ============================================================
# montar.ps1 - Homenagem Marlene Rodrigues da Conceicao
# Versao 03 - Mayko filho do meio + fotos obrigatorias + zoom visivel
# ============================================================

$BASE    = "C:\Users\mayko\homenagem-mae"
$A       = "$BASE\assets"
$R       = "$BASE\revividas"
$MUSICA  = "$BASE\musica.mp3"
$OUT     = "$BASE\montagem"
$TEMP    = "$BASE\montagem\temp"

$W   = 1280
$H   = 720
$FPS = 25

New-Item -ItemType Directory -Force $OUT  | Out-Null
New-Item -ItemType Directory -Force $TEMP | Out-Null

Write-Host ""
Write-Host "=== Homenagem Marlene - Montagem v03 ===" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------
# FUNCOES
# ---------------------------------------------------------------

function Make-Photo {
    param($id, $foto, $dur, $kb_dir = "zoom_in")
    $out = "$TEMP\$id.mp4"
    if (Test-Path $out) { return $out }

    $frames = $dur * $FPS

    # PAD preserva rostos. Zoom mais perceptivel (0.0008)
    switch ($kb_dir) {
        "zoom_in"   { $zoom = "z='min(zoom+0.0008,1.2)'";  $xp = "x='iw/2-(iw/zoom/2)'";        $yp = "y='ih/2-(ih/zoom/2)'" }
        "zoom_out"  { $zoom = "z='if(lte(zoom,1.0),1.2,max(1.0,zoom-0.001))'"; $xp = "x='iw/2-(iw/zoom/2)'"; $yp = "y='ih/2-(ih/zoom/2)'" }
        "pan_right" { $zoom = "z='1.12'"; $xp = "x='if(gte(on,1),x+0.35,0)'";    $yp = "y='ih/2-(ih/zoom/2)'" }
        "pan_left"  { $zoom = "z='1.12'"; $xp = "x='if(gte(on,1),x-0.35,iw*0.12)'"; $yp = "y='ih/2-(ih/zoom/2)'" }
    }

    $vf = "scale=${W}:${H}:force_original_aspect_ratio=decrease,pad=${W}:${H}:(ow-iw)/2:(oh-ih)/2:black,zoompan=$zoom`:d=$frames`:$xp`:$yp`:s=${W}x${H},fps=$FPS,format=yuv420p"

    ffmpeg -y -loop 1 -i $foto -vf $vf -t $dur -an "$out" 2>$null
    Write-Host "  [ok] $id"
    return $out
}

function Make-Text {
    param($id, $linha1, $linha2 = "", $dur = 6, $cor = "white", $tam1 = 72, $tam2 = 48)
    $out = "$TEMP\$id.mp4"
    if (Test-Path $out) { return $out }

    $fonte  = "C\:/Windows/Fonts/arialbd.ttf"
    $source = "color=c=0x111111:s=${W}x${H}:r=$FPS"

    if ($linha2 -ne "") {
        $yc = [int]($H / 2)
        $vf = "drawtext=fontfile='$fonte':text='$linha1':fontcolor=${cor}:fontsize=${tam1}:x=(w-text_w)/2:y=$($yc-50),drawtext=fontfile='$fonte':text='$linha2':fontcolor=0xE8D5A3:fontsize=${tam2}:x=(w-text_w)/2:y=$($yc+20),format=yuv420p"
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
    $vf = "scale=${W}:${H}:force_original_aspect_ratio=decrease,pad=${W}:${H}:(ow-iw)/2:(oh-ih)/2:black,format=yuv420p"
    ffmpeg -y -i $src -vf $vf -an "$out" 2>$null
    Write-Host "  [ok] $id"
    return $out
}

# ---------------------------------------------------------------
# ATO 1 - A ORIGEM (0:00 - 0:45)
# Casamento, nome, datas
# ---------------------------------------------------------------
Write-Host "ATO 1 - A Origem..." -ForegroundColor Yellow

$segs = @()
$segs += Make-Black  "01_preto_inicial"                                                    3
$segs += Scale-Video "02_casamento_veo"             "$R\v01_casamento.mp4"
$segs += Make-Photo  "03_casamento_foto"            "$A\casamento-marlene-pai.jpg"         10  "zoom_in"
$segs += Make-Text   "04_nome"                      "MARLENE"                           "" 5   "white"   90
$segs += Make-Text   "05_sobrenome"                 "Rodrigues da Conceicao"            "" 5   "#E8D5A3" 54
$segs += Make-Text   "06_datas"                     "20 outubro 1955 - 22 junho 2025"   "" 7   "#AAAAAA" 36
$segs += Make-Black  "07_fade_ato1"                                                        3

# ---------------------------------------------------------------
# ATO 2 - QUEM ELA FOI (0:45 - 2:40)
# Cronologico: dos filhos pequenos ate 2020
# FOCO: Mayko com ela, irmaos, pai, familia
# ---------------------------------------------------------------
Write-Host "ATO 2 - Quem ela foi..." -ForegroundColor Yellow

# Marlene mais jovem / era dos filhos pequenos
$segs += Make-Photo  "08_marlene_jovem_cozinha"     "$A\IMG-20160511-WA0094.jpg"           7   "zoom_in"
$segs += Make-Photo  "09_familia_antiga_anos90"     "$A\IMG-20160102-WA0003.jpg"           8   "pan_right"
$segs += Make-Photo  "10_em_casa_2012"              "$A\2012-09-29 21.40.15(1).jpg"        7   "zoom_out"

# 2013-2014 - os netos chegando
$segs += Make-Photo  "11_2013_mall1"                "$A\20130907_205253.jpg"               7   "zoom_in"
$segs += Make-Photo  "12_2013_mall2"                "$A\20130907_205255.jpg"               7   "pan_left"
$segs += Make-Photo  "13_2014_filhos_sofa"          "$A\20140511_190446-SMILE.jpg"         7   "zoom_in"
$segs += Make-Photo  "14_2014_mayko_irmaos"         "$A\20140511_190451(1).jpg"            8   "pan_right"

# 2015 - cotidiano
$segs += Make-Photo  "15_2015_sofa_neta"            "$A\IMG-20150509-WA0004.jpg"           7   "zoom_in"
$segs += Make-Photo  "16_2015_familia"              "$A\IMG-20150705-WA0002.jpg"           7   "zoom_out"
$segs += Make-Photo  "17_2015_mcdonalds"            "$A\IMG-20151030-WA0052.jpg"           8   "pan_left"

# 2016 - momentos com Mayko (DESTAQUE)
$segs += Make-Photo  "18_2016_shopping_chapeu"      "$A\IMG-20160408-WA0021.jpg"           7   "zoom_in"
$segs += Make-Photo  "19_2016_mayko_mae_pai_GUITARRA" "$A\IMG-20161022-WA0016.jpg"         9   "zoom_in"
$segs += Make-Photo  "20_2016_mayko_mae_bebe"       "$A\IMG-20160825-WA0001.jpg"           9   "zoom_out"
$segs += Make-Photo  "21_2016_festa_familia"        "$A\IMG-20161022-WA0007.jpg"           8   "pan_right"
$segs += Make-Photo  "22_2016_cozinha_jantar"       "$A\IMG-20160726-WA0088.jpg"           7   "zoom_in"
$segs += Make-Photo  "23_2016_casa_cotidiano"       "$A\IMG-20161022-WA0001.jpg"           7   "pan_left"

# 2018-2020
$segs += Make-Photo  "24_2018_casal_evento"         "$A\20181201_105825.jpg"               8   "zoom_in"
$segs += Make-Photo  "25_2019_familia"              "$A\IMG-20190120-WA0015.jpg"           7   "pan_right"
$segs += Make-Photo  "26_2019_sofa_neto"            "$A\IMG-20191228-WA0009.jpg"           7   "zoom_out"
$segs += Make-Photo  "27_2020_aniversario"          "$A\IMG-20200726-WA0010.jpg"           7   "zoom_in"
$segs += Make-Black  "28_fade_ato2"                                                        2

# ---------------------------------------------------------------
# ATO 3 - O QUE ELA DEIXOU (2:40 - 4:15)
# 2024-2025: legado vivo
# ---------------------------------------------------------------
Write-Host "ATO 3 - O que ela deixou..." -ForegroundColor Yellow

$segs += Make-Photo  "29_chapeu_foto1"              "$A\IMG_20241027_144232221_HDR_PORTRAIT.jpg" 9  "zoom_in"
$segs += Scale-Video "30_chapeu_veo"                "$R\v03_chapeuvermelho-julia.mp4"
$segs += Make-Photo  "31_chapeu_foto2"              "$A\IMG_20241027_144232221_HDR_PORTRAIT.jpg" 6  "zoom_out"

$segs += Make-Photo  "32_aniversario_grupo"         "$A\IMG_20250201_171120224.jpg"               8  "pan_left"
$segs += Scale-Video "33_aniversario_veo"           "$R\v04_aniversario-davi.mp4"
$segs += Make-Photo  "34_aniversario_2"             "$A\IMG_20250201_171115049_HDR.jpg"           7  "zoom_in"
$segs += Make-Photo  "35_aniversario_3"             "$A\IMG_20250201_171117252_HDR.jpg"           7  "pan_right"
$segs += Make-Photo  "36_aniversario_4"             "$A\IMG_20250201_171118673_HDR.jpg"           7  "zoom_out"

# CLIMAX - ela e o Davi, o ultimo encontro
$segs += Make-Photo  "37_climax_foto1"              "$A\IMG_20250201_172114541_HDR.jpg"          13  "zoom_in"
$segs += Scale-Video "38_climax_veo"                "$R\v02_marlene-davi-bolo.mp4"
$segs += Make-Photo  "39_climax_foto2"              "$A\IMG_20250201_172114541_HDR.jpg"           9  "zoom_out"
$segs += Make-Photo  "40_ultimo_momento"            "$A\IMG_20250201_172115623_HDR.jpg"           8  "pan_left"
$segs += Make-Black  "41_fade_ato3"                                                               2

# ---------------------------------------------------------------
# ATO 4 - DESPEDIDA E LEGADO (4:15 - 5:14)
# ---------------------------------------------------------------
Write-Host "ATO 4 - Despedida e Legado..." -ForegroundColor Yellow

$segs += Make-Photo  "42_encerramento_foto"         "$A\IMG_20241027_144232221_HDR_PORTRAIT.jpg" 9  "zoom_in"
$segs += Scale-Video "43_encerramento_veo"          "$R\v03_chapeuvermelho-julia.mp4"
$segs += Make-Text   "44_frase1"                    "Vai dar certo,"                          "" 4  "white"   64
$segs += Make-Text   "45_frase2"                    "seu fresco!!!"                           "" 5  "#E8D5A3" 72
$segs += Make-Text   "46_legado"                    "Honrar a mae e honrar a origem."         "" 7  "#AAAAAA" 42
$segs += Make-Text   "47_dedicatoria"               "Com amor eterno -" "Mayko e seus filhos"    7  "white"   46  38
$segs += Make-Text   "48_in_memoriam"               "In memoriam" "Marlene Rodrigues da Conceicao" 9 "#E8D5A3" 50 34
$segs += Make-Black  "49_preto_final"                                                             6

# ---------------------------------------------------------------
# CONCATENAR
# ---------------------------------------------------------------
Write-Host ""
Write-Host "Concatenando..." -ForegroundColor Yellow

$concat_list = "$TEMP\concat.txt"
($segs | ForEach-Object { "file '$_'" }) | Out-File -Encoding ascii $concat_list

$video_sem_audio = "$TEMP\video_sem_audio.mp4"
ffmpeg -y -f concat -safe 0 -i $concat_list `
    -c:v libx264 -preset fast -crf 22 -pix_fmt yuv420p `
    -r $FPS -an `
    $video_sem_audio 2>$null
Write-Host "  [ok] video_sem_audio.mp4"

# Duracao real
$dur_str = ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $video_sem_audio
$dur_video = [double]($dur_str -replace "duration=","")
$fade_start = [math]::Max(0, $dur_video - 6)

# ---------------------------------------------------------------
# ADICIONAR MUSICA
# ---------------------------------------------------------------
Write-Host "Adicionando musica..." -ForegroundColor Yellow

$output_final = "$OUT\homenagem_marlene_v03_720p.mp4"
ffmpeg -y `
    -i $video_sem_audio `
    -i $MUSICA `
    -map 0:v -map 1:a `
    -c:v copy -c:a aac -b:a 192k `
    -af "afade=t=out:st=${fade_start}:d=6" `
    -shortest `
    $output_final 2>$null

$dur_str2 = ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 $output_final
$dur_final = [double]($dur_str2 -replace "duration=","")
$min = [math]::Floor($dur_final / 60)
$sec = [math]::Round($dur_final % 60)

Write-Host ""
Write-Host "=== CONCLUIDO ===" -ForegroundColor Green
Write-Host "Arquivo : $output_final" -ForegroundColor Green
Write-Host "Duracao : ${min}min ${sec}s" -ForegroundColor Green
Write-Host ""
Write-Host "Assista com fones, sozinho, com calma."
Write-Host ""
