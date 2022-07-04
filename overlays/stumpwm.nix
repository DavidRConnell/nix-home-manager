final: prev: {
  lispPackages = prev.lispPackages.overrideScope' (lfinal: lprev: {
    stumpwm = lprev.stumpwm.overrideAttrs (old: {
      propagatedBuildInputs = (with lprev; [ clx-truetype slynk ])
        ++ (old.propagatedBuildInputs or [ ]);
    });
  });
}
