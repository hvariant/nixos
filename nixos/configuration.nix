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

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      i3status
      grim
      libnotify
    ];
  };

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

  services.logind.lidSwitch = "ignore";

  users.users.spss = {
    isNormalUser = true;
    extraGroups = [ "wheel" "mlocate" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  system.stateVersion = "21.11";
}

