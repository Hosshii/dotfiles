{ inputs }:
[
  (final: _: {
    localtools = inputs.op-broker.packages.${final.stdenv.hostPlatform.system}.localtools;
  })
]
