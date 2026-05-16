# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O Projeto

Vídeo-homenagem ao 1º aniversário de falecimento de **Marlene Rodrigues da Conceição** (20/10/1955 – 22/06/2025), criado por **Mayko Rodrigues**. Duração-alvo: 5min14s (sincronizado com a música "Se Você Pudesse Me Ouvir" — David Rocha). Destino: culto/missa/encontro familiar + compartilhamento privado.

**Arquivo MP3:** `C:\Users\mayko\Downloads\Se voce pudesse me ouvir - Mae.mp3`  
*(nome sem acentos — PS5.1 e batch leem o caminho como ASCII)*

## Status do Projeto (iniciado 2026-05-15)

- [x] Fase 1 — Planejamento, storyboard, inventário
- [x] Fase 2 — Inventário e seleção de fotos (Mayko confirmou slots 11–14 e 21)
- [x] Fase 3 — Storyboard final (32 slides, 4 atos)
- [x] Fase 4 — Geração Veo 3.1 (4 vídeos gerados: v01–v04, 8s cada)
- [x] Fase 5 — Montagem com FFmpeg (v03 = versão de referência, 326s)
- [ ] Fase 6 — Revisão e ajustes finais
- [ ] Fase 7 — Entrega master

## Versões Renderizadas

| Arquivo | Duração | Data | Observação |
|---|---|---|---|
| `homenagem_marlene_v03_720p.mp4` | 326s | 15/05/2026 | **Referência atual** — melhor versão |
| `homenagem_marlene_v03_1080p.mp4` | — | 15/05/2026 | Versão 1080p |
| `homenagem_marlene_short_v01_720p.mp4` | — | 15/05/2026 | Versão curta 720p |
| `homenagem_marlene_short_v01_1080p.mp4` | — | 15/05/2026 | Versão curta 1080p |
| `homenagem_marlene_stories_v01_1080x1920.mp4` | — | 15/05/2026 | Formato Stories 9:16 |
| `homenagem_marlene_v04_720p.mp4` | 296s | 16/05/2026 | Com títulos Ato 1 e frases Ato 4 |

## Documentos de Referência

| Arquivo | Conteúdo |
|---|---|
| `PROJETO.md` | Decisões confirmadas, log de versões, próximos passos |
| `INVENTARIO.md` | Catálogo de todos os assets por período (2012–2025) |
| `STORYBOARD.md` | Roteiro visual por timestamps — 4 atos, 32 slides |
| `PROMPTS-VEO.md` | Prompts prontos para Google Veo 3.1 |
| `LETRA.md` | Letra completa de "Se Você Pudesse Me Ouvir" — David Rocha |

## Estrutura do Repositório

```
assets/              <- fotos + vídeos originais (fontes)
revividas/           <- Micro-vídeos Veo 3.1 (v01–v04, 8s cada)
montagem/
  Georgia.ttf        <- Fonte copiada de C:\Windows\Fonts\ (necessário para drawtext)
  temp/              <- Segmentos 720p versão completa (31 segmentos)
  temp_1080/         <- Segmentos 1080p versão completa
  temp_short/        <- Segmentos 720p versão curta
  temp_short_1080/   <- Segmentos 1080p versão curta
  temp_stories/      <- Segmentos Stories (9:16)
  gerar_ato1.ps1     <- Gera segmentos 01-07 (Ato 1)
  gerar_ato2.ps1     <- Gera segmentos 08-16 (Ato 2)
  gerar_ato3.ps1     <- Gera segmentos 17-25 (Ato 3)
  gerar_ato4.ps1     <- Gera segmentos 26-31 (Ato 4)
  montar_final.ps1   <- Concatena 31 segmentos e adiciona música
  *.mp4              <- Renders finais
```

## FFmpeg no Windows — Regras Críticas

### drawtext com fonte

**NÃO funciona** no FFmpeg 8.x no Windows:
```
fontfile=C\:/Windows/Fonts/Georgia.ttf   <- QUEBRA no parser de filtros
fontfile='C:/Windows/Fonts/Georgia.ttf'  <- TAMBEM QUEBRA
```

**Solução correta:** copiar a fonte para a pasta local e usar caminho relativo:
```batch
cd /d "C:\Users\mayko\homenagem-mae\montagem"
ffmpeg -vf "drawtext=fontfile=Georgia.ttf:text=MARLENE:..." ...
```
`Georgia.ttf` já está em `montagem/Georgia.ttf`.

Para slides com drawtext usar **arquivos .bat** (não .ps1), com `cd /d` no início. Isso evita todo o problema de escaping do PowerShell com caminhos de fonte.

### concat.txt — sem BOM

O arquivo `temp/concat.txt` deve ser gravado **sem BOM UTF-8**. Usar:
```powershell
[System.IO.File]::WriteAllLines($path, $linhas, [System.Text.UTF8Encoding]::new($false))
```
BOM UTF-8 faz o FFmpeg rejeitar a keyword `file` na linha 1 silenciosamente.

### Scripts PowerShell (.ps1) — apenas ASCII

PowerShell 5.1 lê arquivos UTF-8 como CP1252. Caracteres UTF-8 multi-byte dentro de strings causam erros de parse:
- Em dash `—` → bytes `\xE2\x80\x94` → CP1252 lê `\x94` = `"` → fecha a string prematuramente
- Usar `-` (hífen ASCII) em vez de `—` em todo código PS1

### Sempre usar `-y`

Adicionar `-y` em todos os comandos ffmpeg para evitar prompt interativo de sobrescrever arquivo.

## FFmpeg — Comandos Principais

**Foto estática com Ken Burns (zoom in) — 720p:**
```powershell
ffmpeg -y -loop 1 -i "assets\foto.jpg" -vf "scale=1920:1080,zoompan=z='zoom+0.001':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=300:s=1280x720" -t 10 -c:v libx264 -pix_fmt yuv420p "montagem\temp\XX_nome.mp4"
```

**Tela preta com texto (usar .bat, cd para montagem primeiro):**
```batch
cd /d "C:\Users\mayko\homenagem-mae\montagem"
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 -vf "drawtext=fontfile=Georgia.ttf:text=MARLENE:fontcolor=white:fontsize=72:x=(w-text_w)/2:y=(h-text_h)/2" -t 6 -c:v libx264 -pix_fmt yuv420p "temp\XX_nome.mp4"
```

**Texto sobre foto desfocada (igual — usar .bat):**
```batch
ffmpeg -y -loop 1 -i "..\assets\foto.jpg" -vf "scale=1280x720,gblur=sigma=8,drawtext=fontfile=Georgia.ttf:text=Frase aqui:fontcolor=white:fontsize=50:x=(w-text_w)/2:y=(h-text_h)/2" -t 13 -c:v libx264 -pix_fmt yuv420p "temp\XX_nome.mp4"
```

**Concatenar segmentos:**
```powershell
# Gravar concat.txt SEM BOM antes:
[System.IO.File]::WriteAllLines("montagem\temp\concat.txt", $linhas, [System.Text.UTF8Encoding]::new($false))
# Concatenar:
ffmpeg -y -f concat -safe 0 -i "montagem\temp\concat.txt" -c copy "montagem\temp\video_sem_audio.mp4"
```

**Adicionar música:**
```powershell
ffmpeg -y -i "montagem\temp\video_sem_audio.mp4" -i "C:\Users\mayko\Downloads\Se voce pudesse me ouvir - Mae.mp3" -c:v copy -c:a aac -b:a 192k -shortest "montagem\homenagem_marlene_vXX_720p.mp4"
```

**Verificar duração de todos os segmentos antes de montar:**
```powershell
Get-ChildItem "montagem\temp\*.mp4" | ForEach-Object {
    $d = & ffprobe -v error -show_entries format=duration -of csv=p=0 $_.FullName 2>$null
    "$($_.Name): $([math]::Round([double]$d))s"
}
```

## Veo 3.1 — Micro-vídeos "Revividos"

Acesse: https://aistudio.google.com → VideoFX → Veo 3.1  
Configuração padrão: **~8 segundos reais** (apesar de pedir 5s, os vídeos saem com ~8s), **16:9**  
Salvar resultado em: `revividas/`  
Prompts completos em `PROMPTS-VEO.md`.

Vídeos disponíveis: `v01_casamento.mp4`, `v02_marlene-davi-bolo.mp4`, `v03_chapeuvermelho-julia.mp4`, `v04_aniversario-davi.mp4` — todos com ~8s.

Os scripts `gerar_ato*.ps1` detectam automaticamente se o arquivo Veo existe em `revividas/` e usam ele; caso contrário, usam Ken Burns estático.

## Storyboard — 4 Atos

| Ato | Nome | Tempo | Tom |
|---|---|---|---|
| 1 | A Origem | 0:00–0:47 | Tela preta → foto casamento → títulos |
| 2 | Quem ela foi | 0:47–2:21 | Fotos 2013–2020, melodia crescente |
| 3 | O que ela deixou | 2:21–4:11 | Fotos 2024–2025, clímax emocional |
| 4 | Despedida e Legado | 4:11–5:14 | Frases, dedicatória, fade final |

**Foto-âncora do clímax (slide 22):** `IMG_20250201_172114541_HDR.jpg` (Marlene e Davi com bolo)  
**Foto de encerramento (slide 26):** `IMG_20241027_144232221_HDR_PORTRAIT.jpg` (chapéu vermelho com Julia)  
**Frase dela no slide 27:** *"Vai dar certo, seu fresco!!!"*

Slots confirmados por Mayko (sessão 16/05/2026):
- Slide 11: `IMG-20180524-WA0000.jpg` (Marlene de chapéu e óculos)
- Slide 13: `IMG-20181224-WA0008.jpg` (evento Casados para Sempre, dez/2018)
- Slide 14: `IMG-20180402-WA0012.jpg` (casal no parque)
- Slide 21: `IMG-20200726-WA0018.jpg` (aniversário Claudio, jul/2020 — substituta, 171117252 está rotacionado 90°)
- `assets/casamento-marlene-pai.jpg` — CONFIRMADO presente (Mayko enviou foto)

## Regras de Produção

- Letra da música **nunca aparece** na tela — apenas trilha sonora
- Máximo **6 micro-vídeos Veo** — aprovação prévia de Mayko obrigatória antes de gerar
- Preservar rostos originais exatamente (parâmetro crítico nos prompts Veo: *"Preserve original faces exactly"*)
- Sempre incrementar versão do render final (v04, v05…) — nunca sobrescrever versão anterior
- Ao revisar vídeo, abrir sempre pelo nome exato novo para evitar cache do player
