# celestia
install celestia-appd
-----------------
guide to install
-----------------

Open your terminal and navigate to the directory where you want to download the script.

Clone the repository by running the following command:


`git clone https://github.com/bonsfi/install-celestia-appd`

Navigate to the "install-celestia-appd" directory by running the following command:

`cd install-celestia-appd`

Assign execute permissions to the "celestia.sh" script by running the following command:

`chmod a+x install-celestia-appd.sh`

Now, you can run the "install-celestia-appd.sh" script by typing the following command:


`./install-celestia-appd`

--------------------------
launch script
---------------------------
Recommended Requirements:
Before proceeding, the script will check if the recommended requirements are met. If they are, you will be prompted to press "yes" to continue. Otherwise, you will be advised to update your system to meet the requirements before continuing.

<img width="511" alt="image" src="https://user-images.githubusercontent.com/12712595/231446639-3b16536d-8cc8-4fad-9232-50e8b957aeee.png">

Installing "make" and "gcc": 
Next, the script will automatically begin installing "make" and "gcc".

<img width="242" alt="image" src="https://user-images.githubusercontent.com/12712595/231446767-11a73703-ad00-46a8-86d1-2a691c396119.png">


Installing Go:
The script will ask if you want to install version 1.19.1 of Go. If you want to install it, select "yes" to continue. If you do not want to install it, select "no".

<img width="363" alt="image" src="https://user-images.githubusercontent.com/12712595/231446848-6959fcc8-d170-438b-b0b6-b0bae05266b0.png">


Assigning a Name to the Node:
You will then be prompted to enter the name you want to assign to your node.

<img width="189" alt="image" src="https://user-images.githubusercontent.com/12712595/231447000-4ec25cac-9aa0-4ffe-900d-ffd560b060f7.png">


Creating a Wallet:
The script will ask if you want to create a new wallet or use an existing one. If you want to create a new wallet, press "1". If you want to use an existing wallet, press "2".

<img width="645" alt="image" src="https://user-images.githubusercontent.com/12712595/231447107-6903dc9a-0e7b-4a40-bec0-4fcaa649b8e9.png">

Assigning a Name to the Wallet or Entering Seeds:
If you have chosen to create a new wallet, you will be prompted to enter the name you want to assign to the wallet. If you have chosen to use an existing wallet, you will be prompted to enter the seeds for that wallet.

------------------------------------------------------------------------------------------
Important: Please make sure to write down the seeds provided when creating a new wallet!"
------------------------------------------------------------------------------------------

<img width="1101" alt="image" src="https://user-images.githubusercontent.com/12712595/231447370-0a162630-1be5-494c-82d9-0bc4904ebcd1.png">


Installing Snapshot:
The script will begin installing the snapshot to synchronize quickly.

Starting the Synchronization:
Finally, the script will ask if you want to start the synchronization or not. If you want to start it, press "yes". If you do not want to start it at this time, press "no".

<img width="466" alt="image" src="https://user-images.githubusercontent.com/12712595/231447266-a172f15a-65a3-45fe-a86d-e736a568755a.png">

Finally, the script will ask if you want to start the synchronization or not. If you want to start it, press "yes". If you do not want to start it at this time, press "no".


-----------------
Create validator
-----------------
Once everything is installed, you will need to create your validator in order to appear on the explorer.

MONIKER="your_moniker"
VALIDATOR_WALLET="validator"

celestia-appd tx staking create-validator \
    --amount=1000000utia \
    --pubkey=$(celestia-appd tendermint show-validator) \
    --moniker=$MONIKER \
    --chain-id=blockspacerace-0 \
    --commission-rate=0.1 \
    --commission-max-rate=0.2 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1000000 \
    --from=$VALIDATOR_WALLET \
    --evm-address=$EVM_ADDRESS \
    --keyring-backend=test
    
   You will be prompted to confirm the transaction: [y/N]: y

