
function ssh_change_profile() {
    set -euo pipefail

    # Ctrl-C
    trap 'echo -ne "\033]1337;SetProfile=Default\a"; exit;' INT

    # 接続先とプロファイル
    PROFILE="ssh-default"

    # CONFIG=(
    # arch,ssh-default
    # )

    # for i in "${CONFIG[@]}";do
    #     [[ "${*}" =~ ${i%%,*} ]] && PROFILE="${i//*,}"
    # done

    # set profile
    echo -ne "\033]1337;SetProfile=${PROFILE}\a"

    # ssh login
    /usr/bin/ssh "$@"

    # set profile(default)
    echo -ne "\033]1337;SetProfile=Default\a"
}
