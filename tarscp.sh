# Usage:
# tarcp src ip:dest/
tarcp() { [ "$2" = "" ] && echo tarcp src ip:dest && return || src=$1 && ip=$(echo $2 | cut -d: -f1) && dest=$(echo $2 | cut -d: -f2) ; echo $ip:$dest ; tar -cvSf - $src --totals=USR1 --checkpoint=100000 --checkpoint-action=echo="#%u: %T" | ssh -T -c aes128-gcm@openssh.com -o Compression=no -x $ip "(mkdir -p $dest ; tar -xf - -C $dest)" ; }


