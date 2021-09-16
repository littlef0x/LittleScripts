# LittleScripts

Some simple shell scripts, for my own use, and for fun!

⚠ Most scripts here only work on Ubuntu 18.04+.

⚠ Bugs everywhere. Use them at your own risk.



### aria2

##### aria2.conf

Aria2 config file based on Toyo's config.

##### aria2.service

Systemd service for aria2.

##### aria2_install.sh

Install aria2 via apt.

##### dht.dat

Aria2 dht cache file from Toyo.



### Caddy

⚠ Caddy v1 has reached EOL. Use Caddy 2 if possible.

##### caddy_linux_amd64

Backup of Caddy 1.0.5 compiled by Teddysun.

##### caddy_uninstall.sh

Uninstall caddy v1 (default directory only).

##### caddy_v1.0.4_linux_amd64.tar.gz

Backup of Caddy 1.0.4.

##### caddyv1.service

Systemd service for Caddy v1.

##### caddyv1_install.sh

Install Caddy v1.

##### caddyv2.service

Systemd service for Caddy 2.

⚠ Deprecated: Use the official way instead.

##### caddyv2_install.sh

Install Caddy 2.

⚠ Deprecated: Use the official way instead.



### Filebrowser

##### filebrowser.service

Systemd service for filebrowser.

##### filebrowser_install.sh

Install filebrowser.



### frp

##### frpc_install.sh

Install frp client.

##### frps_install.sh

Install frp server.



### backup & sync

##### nextcloud_autobackup.sh

Backup nextcloud data automatically.

##### seafile_autobackup.sh

Backup seafile files and databases automatically in a single zip file.

##### seafile_autosync.sh

Sync the backup file of seafile automatically to external storage, e.g. Onedrive.

##### rclone_uninstall.sh

Remove rclone.



### server probe

##### serverstatus.service

Systemd service for ServerStatus client.

##### serverstatus_client.sh

Install ServerStatus client. Domain name support added.

##### serverstatus_uninstall.sh

Remove ServerStatus client.



### server maintenance

##### lastlog.sh

Analysis failed logins attempts.

##### remove_unused_kernel.sh

Removed kernels except the latest one and used one.

⚠ Bug Warning: Unexpected behavior in certain environment. Fix needed.

##### ubuntu_init.sh

Some basic setups for new ubuntu server, including:

- Upgrade packages.
- Remove silly vim-tiny & install vim, wget, curl, lrzsz, and screen.
- Set time zone to Asia/Shanghai.
- Add pub key authentication & disable password authentication.
- Create user 'ubuntu' with the same key.
- Activate TCP-BBR.
- Install and enable UFW & add SSH rule (with custom port support).

⚠ You need to add rules manually to make other ports accessible.

- Add some custom aliases.
