// NEED TO HAVE "package.json" file with "type": "module" set for import syntax.
import { ethers } from 'ethers'
import { EthersAdapter } from '@safe-global/protocol-kit'

const RPC_URL='https://eth-goerli.public.blastapi.io'

const safeAddress = '0x9F4Fc2673c4542F0cC4C5ebeEB24ebB19F8BE29f';
const provider = new ethers.providers.JsonRpcProvider(RPC_URL)

const owner1Signer = new ethers.Wallet(process.env.devTestnetPrivateKey, provider)
      
const ethAdapterOwner1 = new EthersAdapter({
  ethers,
  signerOrProvider: owner1Signer
});


