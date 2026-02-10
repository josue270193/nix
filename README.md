# Nix Configuration

Personal Nix configuration using flakes and home-manager for macOS.

## 📋 What This Does

This repository contains my complete development environment setup managed by Nix. It includes:
- Development tools and packages
- Application configurations (Ghostty terminal, etc.)
- Dotfiles and shell configurations
- Custom modules and packages

## 🚀 Fresh Installation (Clean macOS)

### 1. Install Nix

Choose one of the following methods:

**Option A: Determinate Systems Installer (Recommended for macOS)**
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**Option B: Official Nix Installer**
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

If you used Option B, enable flakes:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 2. Clone This Repository

```bash
git clone https://github.com/josue270193/nix.git ~/.config/nix-config
cd ~/.config/nix-config
```

### 3. Build and Activate Configuration

```bash
# First time setup - installs home-manager and all packages
nix run home-manager/master -- switch --flake .

# If your flake has a specific configuration name:
# nix run home-manager/master -- switch --flake .#your-config-name
```

### 4. Verify Installation

After the build completes, all your tools and configurations should be available. You may need to:
- Restart your terminal
- Log out and log back in

## 🔄 Updating Configuration

After making changes to your configuration files:

```bash
cd ~/.config/nix-config
home-manager switch --flake .
```

## 📝 Common Tasks

### Update Flake Inputs
```bash
nix flake update
home-manager switch --flake .
```

### Check What Will Change (Dry Run)
```bash
home-manager switch --flake . --dry-run
```

### Rollback to Previous Generation
```bash
home-manager generations
home-manager switch --switch-generation <generation-number>
```

### List Installed Packages
```bash
home-manager packages
```

## 🛠️ Customization

### Updating Your Configuration

1. Edit the relevant files in `modules/` or `home.nix`
2. Run `home-manager switch --flake .`
3. Commit and push your changes

### Adding New Packages

Add packages to your `home.nix` file in the `home.packages` section:
```nix
home.packages = with pkgs; [
  # your packages here
  neovim
  git
];
```

## 📂 Repository Structure

```
.
├── flake.nix           # Flake configuration and outputs
├── flake.lock          # Locked flake inputs
├── home.nix            # Main home-manager configuration
├── modules/            # Custom modules
├── pkgs/               # Custom package definitions
└── ghostty/            # Ghostty terminal configuration
```

## ⚠️ Important Notes

- **Hostname**: If your flake configuration is tied to a specific hostname, you may need to update it after resetting your Mac. Check your hostname with `hostname` and adjust `flake.nix` if necessary.

- **SSH Keys**: Remember to restore your SSH keys from backup to `~/.ssh/` before cloning private repositories.

- **Secrets**: This repository doesn't include secrets or private data. Make sure to restore any API keys, credentials, or private configuration files separately.

## 🐛 Troubleshooting

### "error: getting status of '/nix/store/...': No such file or directory"
Try rebuilding:
```bash
nix-collect-garbage -d
home-manager switch --flake .
```

### Configuration doesn't apply
Make sure you're in the repository directory and using the correct flake reference:
```bash
cd ~/.config/nix-config
home-manager switch --flake .
```

### Need to start fresh
```bash
rm -rf ~/.config/home-manager
home-manager switch --flake ~/.config/nix-config
```

## 📚 Resources

- [Nix Documentation](https://nixos.org/manual/nix/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

## 📄 License

Personal configuration - feel free to use as reference.
