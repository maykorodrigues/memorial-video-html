# montar_final.ps1
# Homenagem Marlene — Concatenacao final + adicionar musica
# Salvar este arquivo em UTF-8 antes de executar.

$temp   = "$PSScriptRoot\temp"
$concat = "$temp\concat.txt"
$sem_audio = "$temp\video_sem_audio.mp4"
$musica = "C:\Users\mayko\Downloads\Se voce pudesse me ouvir - Mae.mp3"
$master = "$PSScriptRoot\homenagem_marlene_v01_720p.mp4"

# --- verificar segmentos ---

$segmentos = @(
    "01_preto","02_casamento_pb","03_casamento_kenbur",
    "04_titulo_marlene","05_titulo_sobrenome","06_titulo_datas","07_fade_preto",
    "08_casamento_color","09_2013_a","10_2013_b_kb",
    "11_2015","12_2016_a","13_2016_b","14_2016_c",
    "15_2018_natal","16_2019_2020",
    "17_chapeuvermelho","18_chapeuvermelho_kb","19_aniv_davi",
    "20_familia","21_familia_b","22_climax","23_climax_kb",
    "24_2025_b","25_fechamento_ato3",
    "26_chapeuvermelho_final","27_frase_vai","28_frase_origem",
    "29_dedicatoria","30_in_memoriam","31_preto_final"
)

$faltando = @()
foreach ($s in $segmentos) {
    if (-not (Test-Path "$temp\$s.mp4")) { $faltando += "$s.mp4" }
}

if ($faltando.Count -gt 0) {
    Write-Warning "Segmentos ausentes ($($faltando.Count)):"
    $faltando | ForEach-Object { Write-Warning "  $_" }
    Write-Error "Abortando - gerar os segmentos faltantes antes de montar."
    exit 1
}

# --- verificar musica ---

if (-not (Test-Path $musica)) {
    Write-Error "Musica nao encontrada: $musica"
    Write-Error "Verificar caminho em Downloads ou atualizar variavel `$musica neste script."
    exit 1
}

# --- passo 1: concatenar ---

Write-Host "`nPasso 1/2 — Concatenando $($segmentos.Count) segmentos..."
ffmpeg -y -f concat -safe 0 -i $concat -c copy $sem_audio

if (-not (Test-Path $sem_audio)) {
    Write-Error "Falha na concatenacao. Verificar erros acima."
    exit 1
}

# duracao do video sem audio
$duracao = & ffprobe -v error -show_entries format=duration -of csv=p=0 $sem_audio
Write-Host "Duracao sem audio: $([math]::Round([double]$duracao, 1))s (esperado: 314s)"

# --- passo 2: adicionar musica ---

Write-Host "`nPasso 2/2 — Adicionando musica e gerando master..."
ffmpeg -y -i $sem_audio -i $musica -c:v copy -c:a aac -b:a 192k -shortest $master

if (Test-Path $master) {
    $dur_final = & ffprobe -v error -show_entries format=duration -of csv=p=0 $master
    Write-Host ""
    Write-Host "Master gerado: $master"
    Write-Host "Duracao final: $([math]::Round([double]$dur_final, 1))s"
} else {
    Write-Error "Falha ao gerar master."
    exit 1
}
