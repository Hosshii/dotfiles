{ inputs }:
[
  (final: _: {
    macos-remote = inputs.op-broker.packages.${final.system}.client;
    macos-remote-server = inputs.op-broker.packages.${final.system}.server;
  })
]
