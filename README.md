![nasSetup logo](https://github.com/bhdicaire/nasSetup/raw/master/doc/logo.png)

You’ve been there too — setting up a new file server can be an ad-hoc, manual, and time-consuming process.

I wasn't happy with any of the automated setup that I came across. They were either missing features or not maintained.

My objective is to fully automate an Ubuntu installation and configuration using Ansible, ZFS and containers. Lots of stuff in here you probably don't need, and some that needs personalization for your system ... So feel free to fork, and customize.

## What problem does it solve and why is it useful?

Setup a network attached storage [NAS](https://en.wikipedia.org/wiki/Network-attached_storage)) with everything configured properly with easy-to-understand instructions that automate the installation and configuration from the [bare metal](https://github.com/bhdicaire/macSetup/blob/master/doc/bareMetal.md).

nasSetup targets the current Ubuntu LTS release (e.g., Ubuntu
Server 20.04 LTS) to run my MacPro 5,1 24/7. You’ll have the full control of the platform and the services.

It’s probably easier to buy a [consumer NAS box](https://en.wikipedia.org/wiki/List_of_NAS_manufacturers) with several hard drives. Building your own box with a specialized operating system such as [Free NAS] or [Unraid] is also a good alternative if you don’t mind the complexity and lacks of control.

### Modules
I have currently implemented the following modules.


<details>
<summary>Software installation</summary>

 This is being accomplish with the use of [homebrew](https://github.com/Homebrew/homebrew), [homebrew-cask](https://github.com/caskroom/homebrew-cask), and the Mac Apple Store CLI [(MAS)](https://github.com/mas-cli/mas).

</details>

<details>
<summary>ZFS Configuration & Files Sharing</summary>
Any files and folders that are to be copied or symlinked, including app settings, licenses and dotfiles.

Ansible NAS doesn't set up your disk partitions, primarily because getting it wrong can be incredibly destructive.
That aside, configuring partitions is usually a one-time (or very infrequent) event, so there's not much to be
gained by automating it. Check out the [docs](https://davestephens.github.io/ansible-nas) for recommended setups.

# NFS Exports

Ansible-NAS uses the awesome [geerlingguy.nfs](https://github.com/geerlingguy/ansible-role-nfs) Ansible role to configure NFS exports.

More info on configuring NFS exports can be found [here](https://help.ubuntu.com/community/SettingUpNFSHowTo#Shares).

## NFS Examples

Ansible-NAS shares are defined in the `nfs_exports` section within `group_vars/all.yml`. The example provided will allow anyone to read the data in `{{ nfs_shares_root }}/public` on your Ansible-NAS box.

## Permissions

NFS "exports" (an equivalent of a Samba share) are permissioned differently to Samba shares. Samba shares are permissioned with users and groups, and NFS exports are permissioned by the host wanting to access them, and then usual Linux permissions are applied to the files and directories within there. As mentioned above, the example will allow any computer on your network to read and write to the export.

</details>

<details>
<summary>Dashboard</summary>
An awesome dashboard to your home server (Heimdall) supported by Glances for stats.

The first thing to do is to configure [Heimdall](https://heimdall.site/) as the
dashboard of your new NAS, because most of the applications included come with a
web interface. Heimdall lets you create "apps" for them which appear as little
icons on the screen.

To add applications to Heimdall, you'll need the IP address of your NAS.  If you
don't know it for some reason, you will have to look up using the console with
`ip a`. The entry "link/ether", usually the second one after the loopback
device, will show the address. Another alternative is to make sure
[Avahi](https://www.avahi.org/) is installed for zero-configuration networking
(mDNS). This will allow you to `ssh` into your NAS and with the extension
`.local` to your machines name, such as `ssh tardis.local`. Then you can use the
`ip a` command again.

Next, you need the application's port, which you can look up in the [list of
ports](configuration/application_ports.md). You can test the combination of address and port
in your browser by typing them joined by a colon. For instance, for Glances on a
machine with the IPv4 address 192.168.1.2, the full address would be
`http://192.168.1.2:61208`. Once you are sure it works, use this address and
port combination when creating the Heimdall icon.

[Glances](https://nicolargo.github.io/glances/) and
[Portainer](https://www.portainer.io/) are probably the two applications you
want to add to Heimdall first, so you can see what is happening on the NAS.
Note that Portainer will ask for your admin password. After that, it depends on
what you have installed - see the listing for individual applications for more
information.
</details>

<details>
<summary>Media Management</summary>
* [Plex](https://www.plex.tv/) - Plex Media Server
* [Portainer](https://portainer.io/) - for managing Docker and running custom images
* [Syncthing](https://syncthing.net/) - sync directories with another device
* [Tautulli](http://tautulli.com/) - Monitor Your Plex Media Server

Media streaming via Plex
 Any number of Samba shares or NFS exports for you to store your stuff
 * eBook management with Calibre-web
 * [Calibre-web](https://github.com/janeczku/calibre-web) - Provides a clean interface for browsing, reading and downloading eBooks using an existing Calibre database.

 # Calibre-web

Homepage: [https://github.com/janeczku/calibre-web](https://github.com/janeczku/calibre-web)


Calibre-Web is a web app providing a clean interface for browsing, reading and downloading eBooks using an existing Calibre database.

## Usage

Set `calibre_enabled: true` in your `inventories/<your_inventory>/nas.yml` file.

## Specific Configuration

Requires Calibre ebook management program. Available for download [here](https://calibre-ebook.com/download).

### Admin login

**Default admin login:** Username: admin Password: admin123

### eBook Conversion

If you do not need eBook conversion you can disable it to save resources by setting the `calibre_ebook_conversion` variable in `group_vars/all.yml` file to be empty.

 - Conversion enabled: `calibre_ebook_conversion: "linuxserver/calibre-web:calibre"`

 - Conversion disabled: `calibre_ebook_conversion: ""`

You can target just Calibre by appending `-t calibre` to your `ansible-playbook` command.
</details>

<details>
<summary>Infrastructure management</summary>
* [Cloud Commander](https://cloudcmd.io/) - A dual panel file manager with integrated web console and text editor
* [Cloudflare DDNS](https://hub.docker.com/r/joshuaavalon/cloudflare-ddns/) - automatically update Cloudflare with your IP address
* [Duplicacy](https://duplicacy.com/) - A web UI for the Duplicacy cloud backup program, which provides lock-free deduplication backups to multiple providers
* [Duplicati](https://www.duplicati.com/) - for backing up your stuff
* [Gitea](https://gitea.io/en-us/) - Simple self-hosted GitHub clone
* [Glances](https://nicolargo.github.io/glances/) - for seeing the state of your system via a web browser
* [Krusader](https://krusader.org/) - Twin panel file management for your desktop
* [netboot.xyz](https://netboot.xyz/) - a PXE boot server
* [Netdata](https://my-netdata.io/) - An extremely comprehensive system monitoring solution
* [TimeMachine](https://github.com/awlx/samba-timemachine) - Samba-based mac backup server
* [Traefik](https://traefik.io/) - Web proxy and SSL certificate manager
* [Watchtower](https://github.com/v2tec/watchtower) - Monitor your Docker containers and update them if a new version is available

## Using Portainer

Ensure that you have `portainer_enabled: true` in your `group_vars/all.yml` file, and have run the playbook so that Portainer is up and running.

Hit Portainer on http://ansible_nas_host_or_ip:9000. You can now deploy an 'App Template' or head to 'Containers' and manually enter container configuration.
* SSL secured external access to applications via Traefik
* A Docker host with Portainer for image and container management
* An automatic dynamic DNS updater if you use Cloudflare to host your domain DNS
* A backup tool - allows scheduled backups to Amazon S3, OneDrive, Dropbox etc
* A dual panel local file manager
* A PXE server to boot OS images over the network
Ubiquity
</details>

## Installation

1. Install Golang with Homebrew: `brew update; brew install golang`
2. Validate GO version and location (DNSControl can be built with Go version 1.7 or higher): `which go;go version`
3. Ensure the environment variables are adequate (DNSControl will be installed in $GOPATH/bin):
```
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
```
4. Create your GO workspace: `mkdir -p $GOPATH $GOPATH/src $GOPATH/pkg $GOPATH/b`
5. Download the source, compile it, and install DNSControl: `go get github.com/StackExchange/dnscontrol`
6. Create your dnsControl repository: `mkdir -p ~/Code/dnsConfiguration`
6. Clone my repository: `git clone https://github.com/bhdicaire/dnsConfiguration ~/Code/dnsConfiguration`
7. Create your initial `creds.json` with your own credential, you can use `samples/creds.json` to accelerate your setup
8. Modify the `dnsconfig.js` with your provider and DNS zones settings:

## Workflow

1. configure the inventory to your needs

https://github.com/sebschlicht/ansible-nas#:~:text=configure%20the%20inventory

Run the playbook

1. Modify the configuration file with your favorite text editor
2. Identify the next step with `make help`:
```
test		Read configuration and identify changes to be made, without applying them
debug		Run test above and check configuration
build		Deploy configuration to DNS servers
push		Build above and commit changes to Git, you may use msg=abc or ticket=123
archive		Build above, copy configuration to archive subfolder, and commit to Git
clean		Delete dnsConfig.json and archive subfolder
help		This information
5. Review `group_vars/all.yml` for general settings and `roles/[application]/defaults/main.yml` for individual applications. Change settings by overriding them in `inventories/my-ansible-nas/group_vars/nas.yml`.

6. Update `inventories/my-ansible-nas/inventory`.

7. Install the dependent roles: `ansible-galaxy install -r requirements.yml` (you might need `sudo` to install Ansible roles).

8. Run the playbook - something like `ansible-playbook -i inventories/my-ansible-nas/inventory nas.yml -b -K` should do you nicely.
```
3. Test your changes with `make test` or use `make debug` if you're stuck
4. Fix all all warnings/ errors with your favorite text editor
5. Deploy the compiled configuration to your dns servers with `make build`
6. When everything is *perfect*, deploy the change one more time and commit the change to Git:
	* `make push` or `make push msg="Updated nasSetup"`

## Licence

**nasSetup** is [Copyright 2022 Benoît H. Dicaire and licensed under the MIT licence](https://github.com/bhdicaire/nasSetup/blob//master/LICENCE).
