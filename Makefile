CCRED=\033[0;31m
CCEND=\033[0m

.PHONY: build backup restore clean chezmoi help

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build/ Update NAS setup
	ansible-playbook -i inventories/nas/inventory nas.yml -b -K

test: ## Syntax Checking to ensure nothing is broken
	ansible-playbook --syntax-check -i inventories/nas/inventory nas.yml

backup: ## Backup MEDIAZ Configuration
	@mkdir -p ~/ansible-nas-config/inventories
	cp Makefile ~/ansible-nas-config
	cp -R inventories/nas/ ~/ansible-nas-config/inventories
	cp nas.yml ~/ansible-nas-config
	cp requirements.yml ~/ansible-nas-config

restore: ## Restore MEDIAZ Configuration
	cp -R ~/ansible-nas-config .

clean:
	rm -rf /tmp ## Delete temporary files

ssh: ## Adding key to the ssh-agent
	eval "$(ssh-agent -s)"
	ssh-add -K ~/.ssh/githubCom

setup: ## Initial Ubuntu Setup
	sudo apt update && sudo apt upgrade -y
	sudo apt install make
	sudo apt install net-tools
	echo "Install Ansible"
	sudo apt-add-repository —yes —update ppa:ansible/ansible
	sudo apt install ansible
	ansible-galaxy install -r requirements.yml
	echo "**********************************************"
	echo "Intial Ubuntu Setup Completed"
	echo "**********************************************"
	sudo reboot

update: ## Update Ubuntu packages & ansible-nas
	sudo apt update && sudo apt upgrade -y
	git pull

samba: ## Setup Samba
	sudo vi /etc/samba/smb.conf
	sudo service smbd restart
	sudo service nmbd restart
	sudo smbpasswd -a bhdicaire
	sudo smbpasswd -e bhdicaire
