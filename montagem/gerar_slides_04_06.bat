@echo off
cd /d "C:\Users\mayko\homenagem-mae\montagem"
set TEMP_DIR=temp

echo Gerando slide 04...
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 -vf "drawtext=fontfile=Georgia.ttf:text=MARLENE:fontcolor=#F0E0C0:fontsize=80:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=in:st=0:d=2" -t 6 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\04_titulo_marlene.mp4"

echo Gerando slide 05...
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 -vf "drawtext=fontfile=Georgia.ttf:text=Rodrigues da Conceicao:fontcolor=white:fontsize=48:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=in:st=0:d=2" -t 6 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\05_titulo_sobrenome.mp4"

echo Gerando slide 06...
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 -vf "drawtext=fontfile=Georgia.ttf:text=20 de outubro de 1955 - 22 de junho de 2025:fontcolor=white:fontsize=36:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=in:st=0:d=2" -t 8 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\06_titulo_datas.mp4"

echo.
echo Slides 04-06 concluidos.
