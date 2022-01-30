# External Access

There are a number of steps required to enable external access to the applications running on your NAS:

- Enable Traefik
- Domain name and DNS configuration
- Router configuration
- Enable specific applications for external access

## :skull: :skull: :skull: Warning! :skull: :skull: :skull:

Enabling access to applications externally **does not** automatically secure them. If you can access an application from within your own network without a username and password, this will also be the case externally.

It is your responsibility to ensure that applications you enable external access to are secured appropriately!

## Enable Traefik

Traefik routes traffic from ports 80 (HTTP) and 443 (HTTPS) on your Ansible-NAS box to the relevant application, based on hostname.

Simply set `traefik_enabled: true` in your `all.yml`. By default it listens on ports 80 and 443, but doesn't route any traffic.

## Domain Name and DNS Configuration

Set `ansible_nas_domain` to the domain name you want to use for your Ansible-NAS. You'll need somewhere to host the DNS for that domain - Cloudflare is a good free solution. Once you have an account and Cloudflare is hosting the DNS for your domain, create a wildcard DNS entry (`*.myawesomedomain.com`) and set it to your current IP address.

You then need to enable the Cloudflare Dynamic DNS container (`cloudflare_ddns_enabled: true`) so the wildcard DNS entry for your
domain name is updated if/when your ISP issues you a new IP address.

## Router Configuration

You need to map ports 80 and 443 from your router to your Ansible-NAS box.

How to do this is entirely dependent on your router (and out of scope of these docs), but if you're using Ansible-NAS then this should be within your skillset. :)

## Enable Specific Applications

Every application has a `<application_name>_available_externally` setting in the Advanced Settings section of `all.yml`. Setting this to `true` will configure Traefik to route `<application>.yourdomain.com` to the application, making it available externally.


## Application Ports

By default, applications can be found on the ports listed below.

| Application     | Port    | Mode    | Notes          |
|-----------------|---------|---------|----------------|
| Airsonic        | 4040    | Bridge  | HTTP           |
| Bazarr          | 6767    | Bridge  | HTTP           |
| Bitwarden "hub" | 3012    | Bridge  | Web Not.       |
| Bitwarden       | 19080   | Bridge  | HTTP           |
| Booksonic       | 4041    | Bridge  | HTTP           |
| Calibre-web     | 8084    | Bridge  | HTTP           |
| Cloud Commander | 7373    | Bridge  | HTTP           |
| Couchpotato     | 5050    | Bridge  | HTTP           |
| DokuWiki        | 8085    | Bridge  | HTTP           |
| Duplicacy       | 3875    | Bridge  | HTTP           |
| Duplicati       | 8200    | Bridge  | HTTP           |
| Emby            | 8096    | Bridge  | HTTP           |
| Emby            | 8096    | Bridge  | HTTP           |
| Emby            | 8920    | Bridge  | HTTPS          |
| Firefly III     | 8066    | Bridge  | HTTP           |
| get_iplayer     | 8182    | Bridge  | HTTP           |
| Gitea           | 3001    | Bridge  | HTTP           |
| Gitea           | 222     | Bridge  | SSH            |
| GitLab          | 4080    | Bridge  | HTTP           |
| GitLab          | 4443    | Bridge  | HTTPS          |
| GitLab          | 422     | Bridge  | SSH            |
| Glances         | 61208   | Bridge  | HTTP           |
| Gotify          | 2346    | Bridge  | HTTP           |
| Grafana         | 3000    | Bridge  | HTTP           |
| Guacamole       | 8090    | Bridge  | HTTP           |
| Heimdall        | 10080   | Bridge  | HTTP           |
| Heimdall        | 10443   | Bridge  | HTTPS          |
| Home Assistant  | 8123    | Host    | HTTP           |
| Homebridge      | 8087    | Host    | HTTP           |
| InfluxDB        | 8086    | Bridge  | HTTP           |
| Jackett         | 9117    | Bridge  | HTTP           |
| Jellyfin        | 8896    | Bridge  | HTTP           |
| Jellyfin        | 8928    | Bridge  | HTTPS          |
| Krusader        | 5800    | Bridge  | HTTP           |
| Krusader        | 5900    | Bridge  | VNC            |
| Lidarr          | 8686    | Bridge  | HTTP           |
| MiniDLNA        | 8201    | Host    | HTTP           |
| Miniflux        | 8070    | Bridge  | HTTP           |
| Mosquitto       | 1883    | Bridge  | Websocket      |
| Mosquitto       | 9001    | Bridge  | HTTP           |
| Mylar           | 8585    | Bridge  | HTTP           |
| MyMediaForAlexa | 52051   | Host    | HTTP           |
| n8n             | 5678    | Bridge  | HTTP           |
| Netdata         | 19999   | Bridge  | HTTP           |
| Nextcloud       | 8080    | Bridge  | HTTP           |
| netbootxyz      | 3002    | Bridge  | HTTP           |
| netbootxyz      | 5803    | Bridge  | HTTP           |
| netbootxyz      | 69      | Bridge  | TFTP           |
| NZBGet          | 6789    | Bridge  | HTTP           |
| Ombi            | 3579    | Bridge  | HTTP           |
| openHAB         | 7777    | Host    | HTTP           |
| openHAB         | 7778    | Host    | HTTPS          |
| Organizr        | 10081   | Bridge  | HTTP           |
| Organizr        | 10444   | Bridge  | HTTPS          |
| Piwigo          | 16923   | Bridge  | HTTP           |
| Plex            | 32400   | Bridge  | HTTP           |
| Portainer       | 9000    | Bridge  | HTTP           |
| Prowlarr        | 9696    | Bridge  | HTTP           |
| pyload          | 8000    | Bridge  | HTTP           |
| PyTivo          | 9032    | Bridge  | HTTP           |
| PyTivo          | 2190    | Bridge  | UDP            |
| Radarr          | 7878    | Bridge  | HTTP           |
| Sickchill       | 8081    | Bridge  | HTTP           |
| Sonarr          | 8989    | Bridge  | HTTP           |
| Syncthing admin | 8384    | Host    | HTTP           |
| Syncthing P2P   | 22000   | Host    |                |
| Tautulli        | 8185    | Bridge  | HTTP           |
| The Lounge      | 9000    | Bridge  | HTTP           |
| Time Machine    | 10445   | Bridge  | SMB            |
| Traefik         | 8083    | Host    | HTTP Admin     |
| Transmission    | 9091    | Bridge  | HTTP w/VPN     |
| Transmission    | 3128    | Bridge  | HTTP Proxy     |
| Transmission    | 9092    | Bridge  | HTTP Internal  |
| Ubooquity       | 2202    | Bridge  | HTTP Internal  |
| Ubooquity       | 2203    | Bridge  | HTTP Admin     |
| uTorrent        | 8111    | Bridge  | HTTP           |
| uTorrent        | 6881    | Bridge  | BT             |
| uTorrent        | 6881    | Bridge  | UDP            |
| Wallabag        | 7780    | Bridge  | HTTP           |
| YouTubeDL-Mater | 8998    | Bridge  | HTTP           |
| ZNC             | 6677    | Bridge  |                |
| UniFi           | 3478    | Custom  | STUN           |
| UniFi           | 6789    | Custom  | Speedtest      |
| UniFi           | 8080    | Custom  | Device comm    |
| UniFi           | 8443    | Custom  | HTTPS GUI      |
| UniFi           | 8880    | Custom  | HTTP Portal    |
| UniFi           | 8843    | Custom  | HTTPS Portal   |
| UniFi           | 10001   | Custom  | AP discovery   |
