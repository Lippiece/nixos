{
  services = {
    podman = {
      enable = true;
      enableTypeChecks = true;
      autoUpdate = {
        enable = true;
        onCalendar = "*-*-* 00:00:00";
      };
    };
  };
}
