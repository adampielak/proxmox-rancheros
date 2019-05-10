# Setup RancherOS over Proxmox

Change the Variables and IP according to the setup on variable.yml file and add_nfs.sh file.

1. Configuration for setting up NFS on **"add_nfs.sh"** file.
    
    -: Add IP address of the nfs server. 
    `server 192.168.x.x` put your NFS server IP.

    -: Add the path of the nfs 
    `export /path/to/nfs`

2. Configure for setting up VM on **"variable.yml"**

    Wirte **true / fasle**, True if you want to create baseostemplate everytime when the playbook is executed.
    `createBasetemplate: true`

    Write **true / false**, True if you want to create baseostemplate everytime when the playbook is executed. This need to mount only once in the cluster.
    `mountNfs: false`
    
    Enter unique ID for the Base Os Template.
    `baseosid: 100`

    Enter name for the Base Os Template
    `basetemplate: basetemplate`
    
    Enter list of VM with there ID and specify target node of the proxmox cluster. You can add as many as VM in the list.
    `vmid:`

      `- { id: '101' ,node: 'pve' }`
      `- { id: '102' ,node: 'pve1' }`
    
    Configure the RAM of the VM.
    `ram: 4096`
    
    Configure the Disk of the VM.
    `disksize: 32`
    
    Configure the Network of the VM.    
    `net: model=e1000,bridge=vmbr0,firewall=0`

3. Configure Ansible hosts file `/etc/ansible/hosts `to add the proxmox server IP as well as password less ssh between the host to run without promting
	`[proxmox]`
	`192.168.x.x` 

4. Run Playbook for the host.
	``` sh 
	ansible-playbook setup-vm.yml
	```

Some points to check before running.
1. Make sure you allow proxmox server and all nodes from the NFS server's `/etc/export` and `exportfs -a` has been executed before.
2. Correct user is used while using executing Ansible Playbook.