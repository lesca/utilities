# encrypt a specified directory to tar file and split into 2GB in size
sslen() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -c $1 | openssl enc -aes-256-cbc -pass file:~/.passfile | split -a3 -d -b 2G - $des/`basename $1`.part ; }
sslde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; cat $1* | openssl enc -aes-256-cbc -d -pass file:~/.passfile | tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -xC $des ; }

# recursively encrypt / decrypt a directory
diren() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -aes-256-cbc -pass file:~/.passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }
dirde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -d -aes-256-cbc -pass file:~/.passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }

# tarcp src ip:dest/
tarcp() { [ "$2" = "" ] && echo tarcp src ip:dest && return || src=$1 && ip=$(echo $2 | cut -d: -f1) && dest=$(echo $2 | cut -d: -f2) ; echo $ip:$dest ; tar -cvSf - $src --totals=USR1 --checkpoint=100000 --checkpoint-action=echo="#%u: %T" | ssh -T -c aes128-gcm@openssh.com -o Compression=no -x $ip "(mkdir -p $dest ; tar -xf - -C $dest)" ; }

# nctar - receiver side
nctar() { [ "$1" = "" ] && port=9999 || port=$1 ; nc -dN -l $port | tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -xf - ; }

# ncssl name [dir]
ncssl() { [ "$1" = "" ] && name="base" ; [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; nc -dN -l 9999 | tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -xf - | openssl enc -aes-256-cbc -pass file:~/.passfile | split -a3 -d -b 2G - $des/$name.part ; }

# cpv - copy dir only
cpv() { [ "$2" = "" ] && des=cpv-$(date +%F-%H%M%S) || des=$2 ; mkdir -p $des ; tar -c $1 | pv | tar -x -C $des ; }

# genMp4 - for radioRec.py results
genMp4() { ffmpeg -i $1.wav -shortest -filter_complex "[0:a]showspectrum=s=800x500:mode=separate:color=intensity:slide=rscroll[v1];color=c=green:s=1920x1080[v2];[v2][v1]overlay=y=(H-h)/2:x=(W-w)/2,subtitles=$1.srt:force_style='Alignment=6'[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p -preset superfast -map 0:a -c:a aac ham.mp4 ; }
