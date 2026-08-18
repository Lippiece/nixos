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
        env = [
          "HTTP_PROXY=socks5://127.0.0.1:2334"
          "HTTPS_PROXY=socks5://127.0.0.1:2334"
          "NO_PROXY=localhost,127.0.0.1,.lippiece.ru,.ydns.eu"
        ];
        log_size_max = 10485760;
      };
    };
  };
  systemd.user.services = {
    podman-auto-update = {
      Service = {
        Environment = "HTTPS_PROXY=socks5://127.0.0.1:2334";
      };
    };
  };
}
