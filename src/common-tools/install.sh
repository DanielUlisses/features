#!/bin/sh
set -e

echo "Installing required features"

INSTALL_ANTIBODY="${INSTALL_ANTIBODY:-true}"
INSTALL_FZF="${INSTALL_FZF:-true}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi


if [ "$INSTALL_ANTIBODY" = "true" ]; then
    echo "Installing Antibody"
    curl -sfL https://git.io/antibody | sh -s - -b /usr/local/bin
    # Creates a symbolic link to the powerlevel10k plugin
    mkdir -p ~/.local/share/zsh/plugins && ln -s /usr/share/zsh/plugins/powerlevel10k ~/.local/share/zsh/plugins/
fi



 local package_list=""
    if [ "${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
        package_list="${package_list} \
        gzip"

    if [ "$INSTALL_FZF" = "true" ]; then
        package_list="${package_list} fzf"

 echo "Packages to verify are installed: ${package_list}"
    rm -rf /var/lib/apt/lists/*
    apt-get update -y
    apt-get -y install --no-install-recommends ${package_list} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )
