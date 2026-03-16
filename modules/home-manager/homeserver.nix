{
  services = {
    podman = {
      enable = true;
      enableTypeChecks = true;
      autoUpdate = {
        enable = true;
        onCalendar = "*-*-* 00:00:00";
      };
      settings.containers = {
        dns_servers = ["9.9.9.9" "1.1.1.1"];
      };
    };
  };
}
