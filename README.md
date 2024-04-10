# Roulette-dApp

## Docker

Docker Project: https://github.com/chen-qr/SoliditySmartContractDocker

## 项目命令

### 编译和测试

```shell
npx hardhat clean && npx hardhat compile && npx hardhat test
```

### 部署合约

#### 本地网络

```shell
npx hardhat run --network localhost scripts/deployLightlink.js
```

#### 测试网络 

```shell
npx hardhat run --network pegasus scripts/deployLightlink.js
```