{ config, pkgs, ... }:

{
  services.xserver.enable = true;

  # Disable Caps Lock
  services.xserver.xkbOptions = "caps:none";

  # Use proprietary nvidia graphics driver
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable experimental nvidia_drm framebuffer console
  hardware.nvidia.modesetting.enable = true;
  boot.kernelParams = [ "nvidia-drm.fbdev=1" ];
  boot.initrd.availableKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_drm" "nvidia_uvm" ];

  # Hardware-accelerated video decoding
  hardware.opengl.extraPackages = builtins.attrValues {
    inherit (pkgs)
      vaapiVdpau
    ;
  };

  # 32-bit graphics libraries
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = builtins.attrValues {
    inherit (pkgs.pkgsi686Linux)
      vaapiVdpau
    ;
  };

  # workaround nixpkgs#169245
  environment.sessionVariables.LIBVA_DRIVER_NAME = "vdpau";
}
