function _cdd_search_link() {
    find "$CDD_DIR" -type l -name '*' -printf '%f '
}