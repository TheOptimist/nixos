function aws() {
    local httpsHandler="x-scheme-handler/https"
    local currentHandler="$(xdg-mime query default $httpsHandler)"

    if [[ "$1 $2" == "sso login" ]]; then
        # temporarily set default https handler to edge
        xdg-mime default microsoft-edge.desktop $httpsHandler
    fi

    command aws $@

    if [[ "$(xdg-mime query default $httpsHandler)" != "$currentHandler" ]]; then
        echo "Restoring $httpsHandler to $defaultHandler"
        xdg-mime default "$currentHandler" "$httpsHandler"
    fi
}
