echo "Creating Directory"
mkdir -p /mnt/pve/nfs

if (( ! cat /etc/pve/storage.cfg | grep 'nfs'  )); then
	cat <<-EOT >> /etc/pve/storage.cfg
	nfs: nfs 
	     path /mnt/pve/nfs 
	     server 192.168.1.240
	     export /var/nfsproxmox
	     options vers=3,soft
	     content snippets,images,vztmpl,rootdir,iso
	EOT

fi

