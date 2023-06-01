{
  vagrant = {
    networking.hostName = "vagrant";
    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.123.195";
      targetPort = 22;
    };
    imports = [cell.nixosConfigurations.vagrant];
  };
}
