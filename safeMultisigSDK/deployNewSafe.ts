// NEED TO HAVE "package.json" file with "type": "module" set for import syntax.
import { ethers } from 'ethers'
import { EthersAdapter } from '@safe-global/protocol-kit'
import { SafeFactory } from '@safe-global/protocol-kit'
import SafeApiKit from '@safe-global/api-kit'
import { SafeAccountConfig } from '@safe-global/protocol-kit'
    
const RPC_URL='https://eth-goerli.public.blastapi.io'

const safeAddress = '0x9F4Fc2673c4542F0cC4C5ebeEB24ebB19F8BE29f';
const provider = new ethers.providers.JsonRpcProvider(RPC_URL)

const privateKey = "0x" + process.env.devTestnetPrivateKey
const owner1Signer = new ethers.Wallet(privateKey, provider)
      
const ethAdapterOwner1 = new EthersAdapter({
  ethers,
  signerOrProvider: owner1Signer
});

const txServiceUrl = 'https://safe-transaction-goerli.safe.global'
const safeService = new SafeApiKit({ txServiceUrl, ethAdapter: ethAdapterOwner1 })

test()

async function test() {
        
    const safeFactory = await SafeFactory.create({ ethAdapter: ethAdapterOwner1 })
    
    const safeAccountConfig: SafeAccountConfig = {
    owners: [
        await owner1Signer.getAddress(),
    ],
    threshold: 1,
    }
    
    /* This Safe is tied to owner 1 because the factory was initialized with
    an adapter that had owner 1 as the signer. */
    const safeSdkOwner1 = await safeFactory.deploySafe({ safeAccountConfig })
    
    const safeAddress = safeSdkOwner1.getAddress()
    
    console.log('Your Safe has been deployed:')
    console.log(`https://goerli.etherscan.io/address/${safeAddress}`)
    console.log(`https://app.safe.global/gor:${safeAddress}`)
    
}
