users:
{ pkgs, ... }:

let
  mkaccount = user: {
    name = user.name;
    value = {
      isNormalUser = true;
      extraGroups = user.groups;
      openssh.authorizedKeys.keys = user.authorizedKeysFiles;
      shell = pkgs.zsh;
      initialPassword = "password";
    };
  };
  useraccounts = builtins.listToAttrs (map mkaccount users);
in {
  nix.settings.trusted-users = map (user: user.name) users;
  users.users = useraccounts;
}
