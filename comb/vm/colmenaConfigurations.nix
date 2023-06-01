{
  vagrant = {
    networking.hostName = "vagrant";
    deployment = {
      # allowLocalDeployment = true;
      targetHost = "192.168.123.195";
      targetPort = 22;
    };
    imports = [cell.nixosConfigurations.vagrant];
  };
}
