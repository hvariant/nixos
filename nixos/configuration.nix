{ config, pkgs, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      /etc/nixos/boot.nix
      /etc/nixos/network.nix
      /etc/nixos/packages.nix
    ];

  console.keyMap = "us";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    inputMethod.enabled = "ibus";
    inputMethod.ibus.engines = with pkgs.ibus-engines; [
      libpinyin
    ];
  };

  time.timeZone = "Australia/Sydney";

  programs.zsh = {
    enable = true;

    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
  };

  # https://www.reddit.com/r/NixOS/comments/atqlf0/how_to_get_mlocate_working_a_guide_for_the_future/
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "ctrl:nocaps";

    # enable touchpad
    libinput.enable = true;

    displayManager.defaultSession = "none+i3";
    desktopManager.xterm.enable = false;

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        i3status
      ];
    };
  };

  services.logind.lidSwitch = "ignore";

  users.users.spss = {
    isNormalUser = true;
    extraGroups = [ "wheel" "mlocate" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  system.stateVersion = "21.11";
}

