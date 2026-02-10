{ config, pkgs, lib, ... }:

let
  java8 = pkgs.openjdk8;  
  java21 = pkgs.openjdk21;
  java25 = pkgs.openjdk25;
in
{
  home.username = "josue";
  home.homeDirectory = "/Users/josue";

  home.packages = [
    pkgs.pyenv
    pkgs.curl
    pkgs.wget
    pkgs.gawk
    pkgs.coreutils
    pkgs.gnutar
    pkgs.xz
    pkgs.nodejs_22
    (pkgs.callPackage ./pkgs/nvm.nix {})  # nvm
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
    };
    initContent = ''
      # PYENV Setup
      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

      pyenv install 3.14
      pyenv global 3.14

      # JENV Setup
      if command -v jenv >/dev/null; then
        export PATH="$HOME/.jenv/bin:$PATH"
        eval "$(jenv init -)"
      fi

      # NVM Setup
      export NVM_DIR="$HOME/.nvm"
      [ -s "${pkgs.callPackage ./pkgs/nvm.nix { }}/nvm.sh" ] && \. "${pkgs.callPackage ./pkgs/nvm.nix { }}/nvm.sh" --no-use

      # Use starship prompt last
      eval "$(starship init zsh)"

      # Setup global npm bin
      export PATH="$HOME/.npm-global/bin:$PATH"
    '';

    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship.enable = true;
  programs.bat.enable = true;
  programs.fzf.enable = true;
  # Configuration per project
  programs.direnv.enable = true;
  programs.git.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  home.stateVersion = "25.11"; # match your system or nixpkgs version

  # Copy ghostty configs
  home.file = {
    "Library/Application Support/com.mitchellh.ghostty/config".source = ./ghostty/config;
    "Library/Application Support/com.mitchellh.ghostty/inside-the-matrix.glsl".source = ./ghostty/inside-the-matrix.glsl;
  };

  # Automatically configure jenv JAVA
  home.activation = {

    env-setup = lib.hm.dag.entryAfter [ "installPackages" ] ''
      echo "Setting up jenv Java versions..."

      # Ensure Homebrew is in PATH
      export PATH="/opt/homebrew/bin:$PATH"
      
      # Check if jenv is available
      if ! command -v jenv >/dev/null 2>&1; then
        echo "Warning: jenv not found. Please ensure 'brew install jenv' was successful." >&2
        exit 0
      fi
      
      # Initialize jenv properly
      export JENV_ROOT="$HOME/.jenv"
      export PATH="$JENV_ROOT/bin:$PATH"
      
      # Temporarily disable problematic export plugin during activation
      EXPORT_HOOK_FILE="$JENV_ROOT/plugins/export/etc/jenv.d/init/export_jenv_hook.zsh"
      if [ -f "$EXPORT_HOOK_FILE" ]; then
        mv "$EXPORT_HOOK_FILE" "$EXPORT_HOOK_FILE.bak" 2>/dev/null || true
      fi
      
      eval "$(jenv init -)" || echo "jenv init failed, continuing..."
      
      # Restore the export hook file
      if [ -f "$EXPORT_HOOK_FILE.bak" ]; then
        mv "$EXPORT_HOOK_FILE.bak" "$EXPORT_HOOK_FILE" 2>/dev/null || true
      fi


      # Function to safely add Java version
      add_java_version() {
        local java_path="$1"
        local java_name="$2"
        
        if [ -d "$java_path" ]; then
          echo "Adding $java_name from $java_path"
          jenv add "$java_path" || echo "Failed to add $java_name, might already exist"
        else
          echo "Warning: $java_name not found at $java_path"
        fi
      }
      
      # Add Nix JDKs
      add_java_version "${java8}" "Java 8"      
      add_java_version "${java21}" "Java 21"
      add_java_version "${java25}" "Java 25"
      
      # Set Java 21 as global default
      echo "Setting Java 21 as global default..."
      jenv global 21 || jenv global 21.0 || echo "Could not set Java 21 as global"
      
      # Enable export plugin
      jenv enable-plugin export || echo "Export plugin already enabled or failed to enable"
      jenv rehash
      
      echo "jenv setup complete. Available versions:"
      jenv versions || echo "Failed to list jenv versions"
    '';

    # Automatically configure nvm NODEJS
    nvm-setup = lib.hm.dag.entryAfter [ "installPackages" ] ''
      echo "Setting up NVM..."
      
      # Clean up existing NVM if needed
      [ -d "$HOME/.nvm" ] && rm -rf "$HOME/.nvm"
      mkdir "$HOME/.nvm"  

      # Copy nvm installation
      cp -R "${pkgs.callPackage ./pkgs/nvm.nix { }}"/* "$HOME/.nvm/"

      # Make nvm.sh executable
      chmod +x "$HOME/.nvm/nvm.sh"
      
      # Source nvm
      export NVM_DIR="$HOME/.nvm"
      source "$NVM_DIR/nvm.sh"
      
      # Ensure required tools are available in PATH
      export PATH="\
      ${pkgs.curl}/bin:\
      ${pkgs.wget}/bin:\
      ${pkgs.gawk}/bin:\
      ${pkgs.coreutils}/bin:\
      ${pkgs.gnutar}/bin:\
      ${pkgs.xz}/bin:\
      $PATH"
      
      # Verify all required tools
      for tool in curl wget awk tar xz; do
        if ! command -v $tool >/dev/null; then
          echo "Error: Missing required tool: $tool"
          exit 1
        fi
      done

      echo "Installing Node.js ${pkgs.nodejs_22.version}"
      mkdir -p $NVM_DIR/versions/node
      ln -s ${pkgs.nodejs_22} $NVM_DIR/versions/node/v${pkgs.nodejs_22.version}
      nvm alias default ${pkgs.nodejs_22.version}      
      nvm use --delete-prefix default
      npm set prefix ~/.npm-global      

      echo "NVM setup complete"
    '';
  };
}
