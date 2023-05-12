
# .passfile
# a file containing **one-line** passphrase
# put this file at the $HOME directory 

# encrypt a specified directory to tar file and split into 2GB in size
sslen() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -c $1 | openssl enc -aes-256-cbc -pass file:$HOME/.passfile | split -a4 -d -b 1073741824 - $des/`basename $1`.part ; }
sslde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; cat $1* | openssl enc -aes-256-cbc -d -pass file:$HOME/.passfile | tar --checkpoint=100000 --checkpoint-action=echo="#%u: %T" -xC $des ; }

# recursively encrypt / decrypt a directory
diren() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -aes-256-cbc -pass file:$HOME/.passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }
dirde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -d -aes-256-cbc -pass file:$HOME/.passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }
