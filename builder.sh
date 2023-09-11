export PATH="$coreutils/bin:$fennel/bin"

cd $src

fennel -c $entrypoint > $out
