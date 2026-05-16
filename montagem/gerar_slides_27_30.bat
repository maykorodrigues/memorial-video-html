@echo off
cd /d "C:\Users\mayko\homenagem-mae\montagem"
set TEMP_DIR=temp
set ASSETS=..\assets

echo Gerando slide 27...
ffmpeg -y -loop 1 -i "%ASSETS%\IMG_20241027_144232221_HDR_PORTRAIT.jpg" -vf "scale=1280x720,gblur=sigma=8,fade=t=in:st=0:d=2,drawtext=fontfile=Georgia.ttf:text=Vai dar certo\, seu fresco!!!:fontcolor=white:fontsize=50:x=(w-text_w)/2:y=(h-text_h)/2" -t 13 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\27_frase_vai.mp4"

echo Gerando slide 28...
ffmpeg -y -loop 1 -i "%ASSETS%\IMG_20241027_144232221_HDR_PORTRAIT.jpg" -vf "scale=1280x720,gblur=sigma=4,fade=t=out:st=1:d=7,drawtext=fontfile=Georgia.ttf:text=Honrar a mae e honrar a origem.:fontcolor=white:fontsize=42:x=(w-text_w)/2:y=(h-text_h)/2" -t 10 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\28_frase_origem.mp4"

echo Gerando slide 29...
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 -vf "drawtext=fontfile=Georgia.ttf:text=Com amor eterno - Mayko e os seus filhos:fontcolor=white:fontsize=38:x=(w-text_w)/2:y=(h-text_h)/2" -t 7 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\29_dedicatoria.mp4"

echo Gerando slide 30...
ffmpeg -y -f lavfi -i color=black:s=1280x720:r=30 -vf "drawtext=fontfile=Georgia.ttf:text=In memoriam - Marlene Rodrigues da Conceicao:fontcolor=white:fontsize=36:x=(w-text_w)/2:y=(h-text_h)/2,fade=t=out:st=8:d=2" -t 10 -c:v libx264 -pix_fmt yuv420p "%TEMP_DIR%\30_in_memoriam.mp4"

echo.
echo Slides 27-30 concluidos.
