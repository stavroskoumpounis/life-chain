import { ethers } from "ethers";
import { publicKeyConvert } from 'secp256k1';

export const getPublicKey = async (transactionResponse: any) => {


    const signature = ethers.utils.joinSignature({
      r: transactionResponse.r,
      s: transactionResponse.s,
      v: transactionResponse.v
    });
  
    // console.log('signature', signature);
  
    const txData = {
      gasLimit: transactionResponse.gasLimit,
      value: transactionResponse.value,
      nonce: transactionResponse.nonce,
      data: transactionResponse.data,
      chainId: transactionResponse.chainId,
      to: transactionResponse.to,
      type: 2,
      maxFeePerGas: transactionResponse.maxFeePerGas,
      maxPriorityFeePerGas: transactionResponse.maxPriorityFeePerGas
    };
  
    const transaction = await ethers.utils.resolveProperties(txData);
    const rawTransaction = ethers.utils.serializeTransaction(transaction);
    const hashedTransaction = ethers.utils.keccak256(rawTransaction);
    const hashedTransactionBytes = ethers.utils.arrayify(hashedTransaction);
  
    //console.log('hashedTransactionBytes', hashedTransactionBytes);
  
    const publicKey = ethers.utils.recoverPublicKey(hashedTransactionBytes, signature)
  
   console.log('publicKey', publicKey);
  
    //const originalAddress = ethers.utils.recoverAddress(hashedTransactionBytes, signature);
  
    //console.log('originalAddress', originalAddress);
  
    return publicKey;
  }




//based on https://github.com/pubkey/eth-crypto/

export function compressPublicKey(startsWith04:any) {

  // // add trailing 04 if not done before
  // const testBuffer = Buffer.from(startsWith04, 'hex');
  // if (testBuffer.length === 64) startsWith04 = '04' + startsWith04;

  return ethers.utils.hexlify(publicKeyConvert(
    ethers.utils.arrayify('0x' + startsWith04),
    true
  ));
}
export function decompressPublicKey(startsWith02Or03:any) {

  // // if already decompressed doesn't have trailing 04
  // const testBuffer = Buffer.from(startsWith02Or03, 'hex');
  // if (testBuffer.length === 64) startsWith02Or03 = '04' + startsWith02Or03;

  let decompressed = ethers.utils.hexlify(publicKeyConvert(
    ethers.utils.arrayify('0x' + startsWith02Or03),
    false
  ));
  return decompressed;
}
