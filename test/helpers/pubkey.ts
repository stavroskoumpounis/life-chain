import { ethers } from "ethers";

export const getPublicKeyAndAddress = async (tx: any) => {
  const expandedSig = {
    r: tx.r,
    s: tx.s,
    v: tx.v,
  };

  const signature = ethers.utils.joinSignature(expandedSig);
  const txData = {
    gasPrice: tx.gasPrice,
    gasLimit: tx.gasLimit,
    value: tx.value,
    nonce: tx.nonce,
    data: tx.data,
    chainId: tx.chainId,
    to: tx.to, // you might need to include this if it's a regular tx and not simply a contract deployment
  };

  const rsTx = await ethers.utils.resolveProperties(txData);
  const raw = ethers.utils.serializeTransaction(rsTx); // returns RLP encoded tx
  const msgHash = ethers.utils.keccak256(raw); // as specified by ECDSA
  const msgBytes = ethers.utils.arrayify(msgHash); // create binary hash
  const recoveredPubKey = ethers.utils.recoverPublicKey(msgBytes, signature);
  const recoveredAddress = ethers.utils.recoverAddress(msgBytes, signature);

  return {
    address: recoveredAddress,
    publicKey: recoveredPubKey,
  };
};

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
  
   // console.log('publicKey', publicKey);
  
    //const originalAddress = ethers.utils.recoverAddress(hashedTransactionBytes, signature);
  
    //console.log('originalAddress', originalAddress);
  
    return publicKey;
  }
