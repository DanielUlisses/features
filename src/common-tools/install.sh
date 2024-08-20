#!/bin/sh
set -e

echo "Installing required features"

INSTALL_ANTIBODY="${INSTALL_ANTIBODY:-true}"
INSTALL_FZF="${INSTALL_FZF:-true}"
INSTALL_GUM="${INSTALL_GUM:-true}"
USERNAME="vscode"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

if [ "$INSTALL_GUM" = "true" ]; then
    echo "Installing GUM"
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
fi


if [ "$INSTALL_ANTIBODY" = "true" ]; then
    echo "Installing Antibody"
    curl -sfL https://git.io/antibody | sh -s - -b /usr/local/bin
    # Creates a symbolic link to the powerlevel10k plugin
    mkdir -p ~/.local/share/zsh/plugins && ln -s /usr/share/zsh/plugins/powerlevel10k ~/.local/share/zsh/plugins/
fi


install_debian_packages() {
    local package_list=""
        if [ "${PACKAGES_ALREADY_INSTALLED}" != "true" ]; then
            package_list="${package_list} \
            gzip"

        if [ "$INSTALL_FZF" = "true" ]; then
            package_list="${package_list} fzf"
        fi

        if [ "$INSTALL_GUM" = "true" ]; then
            package_list="${package_list} software-properties-common gum"

    fi

    echo "Packages to verify are installed: ${package_list}"
        rm -rf /var/lib/apt/lists/*
        apt-get update -y
        apt-get -y install --no-install-recommends ${package_list} && PACKAGES_ALREADY_INSTALLED="true"
}

# Bring in ID, ID_LIKE, VERSION_ID, VERSION_CODENAME
. /etc/os-release
# Get an adjusted ID independent of distro variants
if [ "${ID}" = "debian" ] || [ "${ID_LIKE}" = "debian" ]; then
    ADJUSTED_ID="debian"
elif [[ "${ID}" = "rhel" || "${ID}" = "fedora" || "${ID}" = "mariner" || "${ID_LIKE}" = *"rhel"* || "${ID_LIKE}" = *"fedora"* || "${ID_LIKE}" = *"mariner"* ]]; then
    ADJUSTED_ID="rhel"
elif [ "${ID}" = "alpine" ]; then
    ADJUSTED_ID="alpine"
else
    echo "Linux distro ${ID} not supported."
    exit 1
fi

# Install packages for appropriate OS
case "${ADJUSTED_ID}" in
    "debian")
        install_debian_packages
        ;;
    "rhel")
        echo "Not yet implemented"
        ;;
    "alpine")
        echo "Not yet implemented"
        ;;
esac

if [ ! -f "/etc/pam.d/chsh" ] || ! grep -Eq '^auth(.*)pam_rootok\.so$' /etc/pam.d/chsh; then
        echo "auth sufficient pam_rootok.so" >> /etc/pam.d/chsh
    elif [[ -n "$(awk '/^auth(.*)pam_rootok\.so$/ && !/^auth[[:blank:]]+sufficient[[:blank:]]+pam_rootok\.so$/' /etc/pam.d/chsh)" ]]; then
        awk '/^auth(.*)pam_rootok\.so$/ { $2 = "sufficient" } { print }' /etc/pam.d/chsh > /tmp/chsh.tmp && mv /tmp/chsh.tmp /etc/pam.d/chsh
    fi

chsh --shell /bin/zsh ${USERNAME}
