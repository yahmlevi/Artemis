FROM node:lts

WORKDIR /usr

RUN npm install --save-dev @nomiclabs/hardhat-etherscan @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai \
 && npm install dotenv



# TO SETUP REPO
# npm init -y
# npm install --save-dev hardhat
# npx hardhat -> Create an empty hardhat.config.js

# AUTOMATION
# npx hardhat test
# npx hardhat compile

# npx hardhat run <file-path> — network <network-name>
# npx hardhat run deployments/deployToken.js --network rinkeby

# hardhat verify — network <networkName> <contractAddress> <ConstructorArguments>
# npx hardhat verify --network rinkeby CONTRACT_ADDRESS "100000000000000000000000"



