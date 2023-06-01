{
  lavinox = {
    networking.hostName = "lavinox";
    deployment = {
      allowLocalDeployment = false;
      targetHost = "192.168.123.195";
      targetPort = 22;
    };
    imports = [cell.nixosConfigurations.lavinox];
  };
}
