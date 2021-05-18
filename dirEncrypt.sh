# scripts to easily run gpgtar to encrypt / decrypt directories 

# passfile
# a file containing **one-line** passphrase
# put this file at the working directory where you run the command

# openssl version - better performace tan gpg

# encrypt a specified directory to tar file and split into 2GB in size
sslen() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; tar -c $1 | openssl enc -aes-256-cbc -pass file:passfile | split -a3 -d -b 2G - $des/`basename $1`.part ; }
sslde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; cat $1* | openssl enc -aes-256-cbc -d -pass file:passfile | tar -xC $des ; }

# recursively encrypt / decrypt a directory 
diren() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -aes-256-cbc -pass file:passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }
dirde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && echo $f && openssl enc -d -aes-256-cbc -pass file:passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }

# incremental version of diren / dirde
diren() { [ "$2" = "" ] && des=encrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && [ ! -f "$des/$f" ] && echo $f && openssl enc -aes-256-cbc -pass file:passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }
dirde() { [ "$2" = "" ] && des=decrypted || des=$2 ; mkdir -p $des ; find ./$1/ | while read f ; do ([ -f "$f" ] && [ ! -f "$des/$f" ] && echo $f && openssl enc -d -aes-256-cbc -pass file:passfile -in "$f" > "$des/$f" 2>/dev/null ) || ([ -d "$f" ] && mkdir -p "$des/$f") ; done }

# gpg version - lower performance (not recommended, for refernece only)
gpgen() { mkdir encrypted ; tar -c $1 | gpg -c --passphrase-file=passfile --batch -o - | split -a3 -d -b 2G - encrypted/`basename $1`.part ; }
gpgde() { mkdir decrypted ; cat $1* | gpg -d --passphrase-file=passfile --batch -o - | tar -xC decrypted ; }

