{ pkgs, my, ... }:

with builtins;
let
  scriptPkgs = listToAttrs (map (n:
    {
      name = baseNameOf n;
      value = my.templateScriptBin (pkgs // my.pkgs) (baseNameOf n) n;
    }
  ) (my.filterFiles (n: v:
    v == "regular" &&
    match ".+\\.nix" n == null
  ) ./.));
in
{
  my.pkgs = scriptPkgs // { "xorg.xset" = pkgs.xorg.xset; }; # FIXME: ugly hack. should make the template code handle the general case
  my.scripts = my.mapAttrs (n: v: "${v}/bin/${n}") scriptPkgs;
}
