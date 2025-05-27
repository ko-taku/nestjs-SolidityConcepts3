import { ethers } from 'hardhat';
import { makeAbi } from './abiGenerator';

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`Deploying contracts with the account: ${deployer.address}`);

  // Todo: deploy script를 구현하여 주세요.

  const Mathlibrary = await ethers.getContractFactory('MathLibrary');
  const mathlibrary = await Mathlibrary.deploy();
  mathlibrary.waitForDeployment();

  const Contract = await ethers.getContractFactory('Calculator', {
    libraries: {
      'contracts/MathLibrary.sol:MathLibrary': mathlibrary.target,
      //solc의 요구 사항이며, ethers.js도 그 규칙을 따르게 되어 있다
      //경로:라이브러리 이름 형식으로 사용
      //라이브러리를 public이나 external로 사용하면 라이브러리를 먼저 배포한다음 사용할 수 있다
    },
  });
  const contract = await Contract.deploy();
  contract.waitForDeployment();

  console.log(`Calculator contract deployed at: ${contract.target}`);
  await makeAbi('Calculator', contract.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
