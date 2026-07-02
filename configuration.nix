# SPDX-FileCopyrightText: 2026 Kris Lamoureux <kris@lamoureux.io>
# SPDX-License-Identifier: 0BSD

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  ###############
  ### Imports ###
  ###############

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ###############
  ### Nixpkgs ###
  ###############

  # Need nonfree for nvidia software and gaming.
  nixpkgs.config.allowUnfree = true;

  ############
  ### Boot ###
  ############

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ##################
  ### Networking ###
  ##################

  # Machine name.
  networking.hostName = "nix-gaming";

  # Add NetworkManager profile with static IP.
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles = {
    "ens18-static" = {
      connection = {
        id = "Ethernet";
        type = "ethernet";
        interface-name = "ens18";
      };
      ipv4 = {
        method = "manual";
        address1 = "192.168.95.12/24,192.168.95.1";
        dns = "192.168.95.1;";
      };
      ipv6 = {
        method = "disabled";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ############
  ### Time ###
  ############

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  ################
  ### Hardware ###
  ################

  # Enable passthrough NVIDIA GPU.
  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;

  # Some Proton games may need 32-bit graphics support.
  hardware.graphics.enable32Bit = true;

  # Bluetooth.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  ################
  ### Services ###
  ################

  # Enable KDE Plasma + Wayland.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  #############
  ### Users ###
  #############

  users.users.kris = {
    isNormalUser = true;
    description = "Kris";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
    home = "/home/kris";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVsGWibChfJE8/ANAAd/ceQpbIm6o/5micL24km4hRj kris@klein"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIItaV0DsusX/PVZAC48E63o39L4IjCXGnNm6jWnZLI9k kris@pike"
    ];
  };

  ###############
  ## Programs ###
  ###############

  # Drop once dotfiles move to Home Manager.
  programs.bash.interactiveShellInit = ''
    [[ -f ~/.bashrc ]] && source ~/.bashrc
  '';

  programs.git = {
    enable = true;
    config = {
      user.name = "Kris Lamoureux";
      user.email = "kris@lamoureux.io";
    };
  };

  # Add Valve's Steam for games.
  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #################
  ## Environment ##
  #################

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    chromium
    gnupg
    kdePackages.bluedevil
    kdePackages.bluez-qt
    ncdu
    pciutils
    stow
    terminator
    tmux
    tree
    usbutils
    vim
    vscodium
    wget
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
