# encrypt the directory ($1) to tar file in copy mode with the splited size of 2GB 
sslen() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -c $1 | openssl enc -aes-256-cbc -pass file:$HOME/.passfile | split -a3 -d -b 2G - $des/`basename $1`.part ; }
sslde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; cat $1* | openssl enc -aes-256-cbc -d -pass file:$HOME/.passfile | tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -xC $des ; }

# recursively encrypt / decrypt the directory ($1) in copy mode
diren() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -aes-256-cbc -pass file:$HOME/.passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }
dirde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -d -aes-256-cbc -pass file:$HOME/.passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }

# tarncr - receiver side
# usage: tarncr [port]
# to send: tar -c . | nc ip 9999
tarncr() { [ "$1" = "" ] && port=9999 || port=$1 ; nc -dN -l $port | tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -xf - ; }

# genMp4 - for radioRec.py results
genMp4() { ffmpeg -i $1.wav -shortest -filter_complex "[0:a]showspectrum=s=800x500:mode=separate:color=intensity:slide=rscroll[v1];color=c=green:s=1920x1080[v2];[v2][v1]overlay=y=(H-h)/2:x=(W-w)/2,subtitles=$1.srt:force_style='Alignment=6'[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p -preset superfast -map 0:a -c:a aac ham.mp4 ; }
