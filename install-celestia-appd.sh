#!/bin/bash
#Autor: LowFeeValidation
echo " This is a script to install and configure a validator on Celestia-appd."

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/root/go/bin

echo "       -------------------------------------------------------------
       |            🖥  Hardware Requirements 🖥                     |
       |              -----------------------                      |
       |    The recommended hardware to run a Celestia-appd node.  |
       |                                                           |
       |     - CPU --------> 6+ Cores                              |
       |     - RAM --------> 8+ GB RAM                             |
       |     - Hard Disc --> 500GB+ SSD                            |
       -------------------------------------------------------------        
"       
r1=""


read -p " Continue? (y) or (n): " r1

until [ $r1 == n -o $r1 == y ]; do
        read -p " You have not entered the correct option, please enter (y) or (n). " r1
done


if [ $r1 == y ]; then
        echo ""
fi
        if [ $r1 == n ]; then
                exit
        fi
cd $HOME
echo " ------------------------------ "
echo " |⚙️  Instaling make and gcc ⚙️ | "
echo " ------------------------------ "
sudo apt update && sudo apt upgrade -y "/dev/null"
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y < "/dev/null"
echo ""


r2=""

read -p " Do you want to install Go 1.19.1? (y) or (n): " r2 

until [ $r2 == n -o $r2 == y ]; do
        read -p " You have not entered the correct option, please enter (y) or (n). " r2
done


        if [ $r2 == y ]; then
                echo " installing Go... "
                echo " Download and install Go... "
                wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz
                echo ""
                rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
                echo ""
                export PATH=$PATH:/usr/local/go/bin
                echo ""
                rm -r /root/go1.19.1.linux-amd64.tar.gz
                echo ""
                echo " Your version Go is: "
                echo ""
                go version
        fi

                if [ $r2 == n ]; then
                        echo " Continuing with the current version ... "
                fi
echo " --------------------------------------- "
echo " | Cloning repository Github for Celestia-appd | "
echo " --------------------------------------- "
cd $HOME
rm -rf celestia-app 
git clone https://github.com/celestiaorg/celestia-app.git
cd celestia-app/ 
APP_VERSION=v0.12.1 
git checkout tags/$APP_VERSION -b $APP_VERSION


echo "===================================================================================================="
echo " Compliling Celestia-appd "
make install
export PATH=$PATH:/root/go/bin

celestia-appd version  
echo ""
echo " ---------------------------------------------------- "
echo " |   >>>>> ✅ Celestia-appd compilation completed ✅ <<<<<  | "
echo " ---------------------------------------------------- "
echo ""
echo " ---------------------------------------------- "
echo " |      🔨 Configuration and Execution 🔨     | "
echo " ---------------------------------------------- "
echo "" 

moniker=""
#gasprice=""
#gasprice2=""
r4=""

if [ ! $moniker ]; then
read -p " Enter your node name : " moniker
echo 'export moniker='\"${moniker}\" >> $HOME/.bash_profile
fi

echo " ---------------------------------------------- "
echo " |      🔨 Setup the P2P networks 🔨          | "
echo " ---------------------------------------------- "

cd
cd $HOME
rm -rf networks
git clone https://github.com/celestiaorg/networks.git

# Configuration the genesis and peers.

celestia-appd init $moniker --chain-id blockspacerace-0
cp $HOME/networks/mocha/genesis.json $HOME/.celestia-app/config

SEEDS="some seeds"
PEERS="some peers"
sed -i -e 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.celestia-app/config/config.toml
sed -i -e "s/^seed_mode *=.*/seed_mode = \"$SEED_MODE\"/" $HOME/.celestia-app/config/config.toml


echo " -------------------------------------------------------------------------------------------------------- "
echo " |   >>>>>✅ Celestia genesis downloaded and peers aded in .celestia.appd/config/app.toml completed ✅<<<<<  | "
echo " -------------------------------------------------------------------------------------------------------- "
echo ""
echo "                             -------------------------------------------                              "
echo ""
echo " ---------------------------------------- "
echo " |      💰 Creating a new wallet 💰     | "
echo " ---------------------------------------- "

keyname=""
r5=""
cont=""

read -p " To create a new wallet press (1), to recover an existing one with the seed press (2): " r5


until [ $r5 -eq 1 -o $r5 -eq 2 ]; do
        read -p " You have not entered the correct option, please enter (1) or (2). " r5
done

        if [ $r5 == 1 ]; then
                read -p " Enter a name for your new wallet: " keyname 
                celestia-appd keys add $keyname 
                export $keyname
                echo 'export keyname='\"${keyname}\" >> $HOME/.bash_profile             
                echo " ------------------------------------------------------------------------------------------------------------- "
                echo " |     🚨🚨 ⚠️  ⚠️  ⚠️  ⚠️  ⚠️  ⚠️  ⚠️  ⚠️   keep your mnemonic in a safe place and ⚠️  ⚠️  ⚠️  ⚠️  ⚠️  ⚠️  ⚠️  ⚠️   🚨🚨    | "
                echo " ------------------------------------------------------------------------------------------------------------- "
                echo ""
        elif [ $cont == 1 ]; then
                read -p " Press a key to continue  " cont
        fi
                if [ $r5 == 2 ]; then
                        read  -p " Enter a name for the wallet: " keyname
                        celestia-appd keys add $keyname --recover 
                fi
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | \
    egrep -o ">blockspacerace.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - \
    -C ~/.celestia-app/data/
echo " ----------------------------------- "
echo " |  ✅ Installation completed. ✅  | "
echo " ----------------------------------- "
echo ""


r6=""

read -p " Do you want to start the network and synchronize? (y) or (n): "  r6

until [ $r6 == n -o $r6 == y ]; do
        read -p " You have not entered the correct option, please enter (y) or (n). " r6
done


        if [ $r6 == y ]; then

                echo "
[Unit]
Description=celestia-appd Cosmos daemon
After=network-online.target
[Service]
User=root
ExecStart=$HOME/go/bin/celestia-appd start --p2p.seed_mode=true
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/celestia-appd.service

                systemctl enable /etc/systemd/system/celestia-appd.service
                systemctl start celestia-appd.service
                journalctl -u celestia-appd.service -fo cat
                
                echo " -----------------------------------------------------"
                echo " |  🛠 🛠 🛠  Blockchain celestia-appd started. 🛠 🛠 🛠    | "
                echo " -----------------------------------------------------"
        fi

if [ $r6 == n ]; then
        systemctl enable /etc/systemd/system/celestia-appd.service
fi

fi

