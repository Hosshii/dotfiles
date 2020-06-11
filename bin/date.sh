echo "\033[2J"
while :
do
    echo "\033[H"
    DATETIME=`date +%Y%m%d_%H%M%S_%3N`
    echo $DATETIME
done
