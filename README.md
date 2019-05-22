# Setup RancherOS over Proxmox
There are two files which need to be configured before running playbook.

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

    Add Public SSH key
    `ssh_key: your ssh key`

3. Configure Ansible hosts file `hosts `to add the proxmox server IP as well as password less ssh between the host to run without promting

    `[proxmox]`

    `192.168.x.x` 
4. Create Base Os template using `create-baseostemplate`
- Run Playbook `install-rancheros.yml` This will generate a file `ansible-cloud-init.yml`,This file will be used to configure RancherOs while installing.

- Login into the newly created VM which will be later used as base os template and copy `ansible-cloud-init.yml` on it. Make sure you update all the Variables accordingly especially the ssh key which will be used to access the VM later after installation.
- Run this commannd to install Rancher OS on Hard Disk and follow the steps with `Yes`
    ```sh
    sudo ros install -c /path/to/ansible-cloud-init.yml -d /dev/sda
    ```
- After installation is complete Make sure you reboot the machine agian and login into it using the ssh key and check whether python is available.
- Now convert the VM into template from Proxmox Web UI.

5. Run Playbook on the localhost to clone new VM from Template.
    ``` sh 
    ansible-playbook setup-vm.yml
    ```
6. After all the VMs are started, run `setup-rancher-cluster.yml` playbook from your localhost.

Some points to check before running.
1. Make sure you allow proxmox server and all nodes from the NFS server's `/etc/export` and execute `exportfs -a` before running playbook.
2. Correct user is used while using executing Ansible Playbook.