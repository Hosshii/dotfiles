#!/bin/bash -eu

if [ $# -eq 0 ];then
    CONVERT=$(file ./* |grep "Non-ISO extended-ASCII text" |grep -ve ".*orig$"| awk '{print $1}'|sed -e "s/:\$//")
    echo $CONVERT
else
    CONVERT=$@
fi

echo "converting files..."
for f in $CONVERT;do
    mv $f tmp
    touch $f
    iconv -f SHIFT_JIS -t UTF-8 tmp > $f
    echo "$f converted to $f"
    rm tmp
done

echo "done."
