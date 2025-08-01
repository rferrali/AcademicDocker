# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Add labels for better metadata
LABEL org.opencontainers.image.title="Academic Docker"
LABEL org.opencontainers.image.description="A Docker image for academic research with R, Quarto, and TinyTeX"
LABEL org.opencontainers.image.source="https://github.com/rferrali/AcademicDocker"
LABEL org.opencontainers.image.vendor="rferrali"
LABEL org.opencontainers.image.licenses="MIT"

ARG TARGETARCH
ENV PATH="/home/vscode/.local/bin:${PATH}" \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    RENV_CONFIG_PAK_ENABLED=TRUE \
    RENV_PATHS_CACHE=/renv/cache
# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    build-essential \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    software-properties-common \
    wget \
    perl \
    libfontconfig1 \
    libc6 \
    libgcc1 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    libicu[0-9][0-9] \
    liblttng-ust[0-9] \
    libstdc++6 \
    zlib1g \
    locales \
    sudo && \
    # Create a non-root user with sudo privileges
    groupadd -g 1001 vscode && \
    useradd -m -u 1001 -g vscode vscode && \
    usermod -aG sudo vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    # Clean up apt cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Production stuff -----------------------------------
# AS ROOT
# Install rig
RUN curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg && \
    sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list' && \
    apt-get update && apt-get install -y r-rig && \ 
    # Install Quarto
    curl -LO https://quarto.org/download/latest/quarto-linux-$TARGETARCH.deb && \
    apt-get install -y ./quarto-linux-$TARGETARCH.deb && \
    rm quarto-linux-$TARGETARCH.deb && \
    # create directory for Renv cache and set permissions
    mkdir -p /renv/cache && \
    chown -R vscode:vscode /renv && \
    chmod -R 755 /renv && \
    # Clean up apt cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# AS USER VSCODE
# Install TinyTeX
USER vscode
RUN mkdir -p ~/.local/bin && \
    curl -fsSL "https://yihui.org/tinytex/install-unx.sh" | sh && \
    # Install R and R packages
    rig add release && \
    R -e "pak::pkg_install(c('renv', 'rmarkdown'))"
# Development stuff -----------------------------------
USER root
# AS ROOT
# Copy the startup scripts
COPY startup_scripts /
# Install system dev dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    gnupg2 \
    dirmngr \
    iproute2 \
    procps \
    lsof \
    tree \
    ca-certificates \
    git \
    htop \
    pipx \
    nano \
    net-tools \
    psmisc \
    rsync \
    unzip \
    bzip2 \
    xz-utils \
    zip \
    less \
    jq \
    lsb-release \
    apt-transport-https \
    dialog \
    man-db \
    manpages \
    manpages-dev \
    init-system-helpers \
    cpanminus \
    zsh && \
    # Make zsh the default shell
    chsh -s $(which zsh) && \
    # Install perl modules required by Latexindent
    cpanm --notest YAML::Tiny File::HomeDir && \
    # give to vscode user access to the startup scripts directory
    chown -R vscode:vscode /startup_scripts && \
    chmod -R 755 /startup_scripts && \
    # Clean up apt cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# AS USER
USER vscode
# Install R dev dependencies
RUN pipx install radian && \
    R -e "pak::pkg_install(c('languageserver', 'ManuelHentschel/vscDebugger', 'nx10/httpgd'))" && \
    # Install terminal tools
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc && \
    # Install latexindent
    ~/.TinyTeX/bin/*/tlmgr install latexindent && \
    ln -s ~/.TinyTeX/bin/*/latexindent ~/bin/latexindent

# Set working directory
WORKDIR /workspaces

# Set the default command
CMD ["/bin/zsh"]