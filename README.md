# Memorial Video HTML

Template cinematográfico para vídeos de homenagem — apresentação HTML com slides sincronizados à música, Ken Burns, vídeos de IA e ornamentos botânicos em SVG.

Criado originalmente como homenagem ao 1º aniversário de falecimento de **Marlene Rodrigues da Conceição** (1955–2025).

---

## Demo

![Slide de abertura com tipografia Cinzel e ornamentos dourados](https://raw.githubusercontent.com/maykorodrigues/memorial-video-html/master/docs/preview.jpg)

Abre direto no navegador. Sem servidor, sem dependências npm.

---

## O que está incluído

| Arquivo | Descrição |
|---|---|
| `homenagem.html` | Apresentação HTML completa — o entregável principal |
| `montagem/gerar_ato*.ps1` | Scripts PowerShell para gerar segmentos de vídeo com FFmpeg |
| `montagem/montar_final.ps1` | Concatena segmentos e adiciona a trilha sonora |
| `montagem/gerar_slides_*.bat` | Gera slides com texto usando `drawtext` (FFmpeg + fonte local) |
| `STORYBOARD.md` | Roteiro visual — 4 atos, 31 slides, timestamps |
| `INVENTARIO.md` | Catálogo de fotos por período |
| `PROMPTS-VEO.md` | Prompts prontos para Google Veo 3.1 |
| `LETRA.md` | Letra da música sincronizada |
| `NARRATIVA-V03.md` | Especificação detalhada da versão de referência |
| `CLAUDE.md` | Contexto do projeto para Claude Code |

---

## Como usar para uma nova homenagem

### 1. Estrutura de pastas

```
seu-projeto/
  assets/          ← fotos originais (JPG/PNG)
  revividas/       ← vídeos de IA, ex: Google Veo 3.1 (~8s cada)
  musica.mp3       ← trilha sonora (copiar para a raiz)
  homenagem.html   ← editar este arquivo
```

### 2. Editar `homenagem.html`

O arquivo é autocontido. Edite o array `SLIDES` no `<script>`:

```javascript
const SLIDES = [
  // Slide preto com título do ato
  { start:0, end:3,
    content:`<div class="tl">
      <p class="t-chapter-ato appear">A T O &nbsp; I</p>
      <p class="t-chapter-title appear-2">A &nbsp; O r i g e m</p>
    </div>` },

  // Foto com Ken Burns e legenda
  { start:3, end:15,
    bg:'assets/foto.jpg', pos:'center 28%',
    bgClass:'kb', overlay:'bot',
    content:`<div class="tl-bot glass appear-2">
      <p class="t-narrativa"><em>"Narrativa aqui."</em></p>
    </div>`,
    ornBL:true },

  // Vídeo de IA como fundo
  { start:15, end:28,
    video:'revividas/v01.mp4',
    overlay:'full' },
];
```

### 3. Campos de cada slide

| Campo | Tipo | Descrição |
|---|---|---|
| `start` / `end` | número (segundos) | Janela de exibição do slide |
| `bg` | caminho | Foto de fundo |
| `pos` | string CSS | `background-position` — use `'center 20%'` para retratos |
| `bgClass` | string | `kb` `kb-face` `kb-hands` `kb-left` `kb-right` `grayscale` `blur-heavy` |
| `video` | caminho | Vídeo de IA — substitui `bg` |
| `overlay` | string | `soft` `med` `hard` `bot` `top` `full` `scene` |
| `content` | HTML | Textos, citações, títulos |
| `ornBL/BR/TL/TR` | boolean | Ornamento de ramo nos cantos |
| `ornT` | boolean | Moldura no topo |

### 4. Classes de texto disponíveis

| Classe | Uso |
|---|---|
| `.t-name` | Nome em destaque (grande, itálico) |
| `.t-sobrenome` | Sobrenome ou subtítulo |
| `.t-dates` | Datas em Cinzel dourado |
| `.t-narrativa` | Narração em itálico |
| `.t-quote` | Citação literária |
| `.t-attribution` | Autor da citação |
| `.t-frase` | Frase pessoal da homenageada (grande) |
| `.t-chapter-ato` | "ATO I" em Cinzel espaçado |
| `.t-chapter-title` | Subtítulo do ato |
| `.t-memoriam` | "In memoriam" |
| `.t-dedicatoria` | Texto de dedicatória |

Adicione `.appear`, `.appear-2`, `.appear-3` para animar em cascata.

### 5. Atalhos de teclado

| Tecla | Ação |
|---|---|
| `Espaço` | Pausar / retomar |
| `← →` | Recuar / avançar 10 segundos |
| `F` | Tela cheia |
| `1` `2` `3` `4` | Pular para o início de cada ato |

---

## Gerar o arquivo MP4 (opcional)

Requer **FFmpeg** instalado no Windows.

```powershell
# 1. Copiar a fonte Georgia para a pasta montagem
Copy-Item "C:\Windows\Fonts\Georgia.ttf" "montagem\Georgia.ttf"

# 2. Gerar os segmentos de cada ato
.\montagem\gerar_ato1.ps1
.\montagem\gerar_ato2.ps1
.\montagem\gerar_ato3.ps1
.\montagem\gerar_ato4.ps1

# 3. Montar o vídeo final com a música
.\montagem\montar_final.ps1
```

> **Atenção — Windows:** nunca usar `fontfile=C:/Windows/Fonts/...` no drawtext do FFmpeg 8.x.
> Copie a fonte para a pasta local e use `fontfile=Georgia.ttf` com `cd /d` no início do script `.bat`.

---

## Vídeos de IA com Google Veo 3.1

Acesse [Google AI Studio](https://aistudio.google.com) → VideoFX → Veo 3.1.

- Configuração: ~8 segundos, 16:9
- Salvar em `revividas/` com nome descritivo
- Usar nos slides de maior impacto emocional (clímax, momentos únicos)
- Parâmetro crítico nos prompts: *"Preserve original faces exactly"*

Prompts prontos para este projeto em `PROMPTS-VEO.md`.

---

## Estrutura dos 4 atos

| Ato | Nome | Tom |
|---|---|---|
| I | A Origem | Tela preta → foto jovem/casamento → títulos nome e datas |
| II | Quem ela foi | Fotos cronológicas com citações literárias, melodia crescente |
| III | O que ela deixou | Fotos recentes, vídeos Veo, clímax emocional |
| IV | Despedida e Legado | Frase pessoal, dedicatória, In memoriam, fade final |

---

## Tecnologias

- HTML5 + CSS3 + JavaScript vanilla — sem frameworks
- [Cormorant Garamond](https://fonts.google.com/specimen/Cormorant+Garamond) + [Cinzel](https://fonts.google.com/specimen/Cinzel) via Google Fonts
- FFmpeg para geração do MP4
- Google Veo 3.1 para micro-vídeos de IA

---

## Licença

MIT — use, adapte e compartilhe livremente.  
Se criar uma homenagem com este template, nenhuma atribuição necessária — mas seria bonito saber.
