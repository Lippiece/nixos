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
        dns_servers = ["127.0.0.1" "1.1.1.1"];
        log_size_max = 10485760;
      };
    };
  };
}
