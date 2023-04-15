// NEED TO HAVE "package.json" file with "type": "module" set for import syntax.
import { ethers } from 'ethers'
import Safe, { EthersAdapter } from '@safe-global/protocol-kit'
import { SafeFactory } from '@safe-global/protocol-kit'
import SafeApiKit from '@safe-global/api-kit'
import { SafeAccountConfig } from '@safe-global/protocol-kit'
import { SafeTransactionDataPartial } from '@safe-global/safe-core-sdk-types'
    
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
                
    const destination = '0x9F4Fc2673c4542F0cC4C5ebeEB24ebB19F8BE29f'
    const amount = ethers.utils.parseUnits('0.001', 'ether').toString()

    const safeTransactionData: SafeTransactionDataPartial = {
        to: destination,
        data: '0x',
        value: amount
    }
    const safeSdkOwner1 = await Safe.create({
        ethAdapter: ethAdapterOwner1,
        safeAddress
    })
    // Create a Safe transaction with the provided parameters
    const safeTransaction = await safeSdkOwner1.createTransaction({ safeTransactionData })
    console.log(safeTransaction)
    
    // Deterministic hash based on transaction parameters
    const safeTxHash = await safeSdkOwner1.getTransactionHash(safeTransaction)
    
    // Sign transaction to verify that the transaction is coming from owner 1
    const senderSignature = await safeSdkOwner1.signTransactionHash(safeTxHash)
    
    const newTransactionInQueue = await safeService.proposeTransaction({
        safeAddress,
        safeTransactionData: safeTransaction.data,
        safeTxHash,
        senderAddress: await owner1Signer.getAddress(),
        senderSignature: senderSignature.data,
    })
    console.log("New transaction added to the transaction queue in the Safe Dashboard.")
}
