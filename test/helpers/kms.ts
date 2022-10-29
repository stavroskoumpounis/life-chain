import {
    KMSClient,
    EncryptCommand,
    DecryptCommand
} from '@aws-sdk/client-kms';
  
  
  /**
   * Encrypt blob using an aws KMS 256-bit AES-GCM encryption key
   * @param {*} blobToEncrypt 
   * @param {*} awsClient 
   * @param {*} cognitoUserId - links apropriate key for encryption
   * @returns kms response obj
   */
  export const encryptSymmetric = async (blobToEncrypt: any, cognitoUserId: string) => {
    
    if (!(blobToEncrypt instanceof String)){
      blobToEncrypt = JSON.stringify(blobToEncrypt);
    }

    const client = initiateKMSClient();
    
    const context = {
      stage: 'dev',
      purpose: 'lifechain symmetric',
      origin: 'eu-west-2',
    };

    const base64encodedBlob = new TextEncoder().encode(blobToEncrypt);
  
    const input = {
      EncryptionContext: context,
      KeyId: 'alias/' + cognitoUserId.substring(10),
      Plaintext: base64encodedBlob
    };
    
    const command = new EncryptCommand(input);
    const response = await client.send(command);
  
    return response;
  };
  
  /**
   *  Decrypt blob using the aws encryption key that was used to encrypt it
   * @param {*} blobToDecrypt 
   * @param {*} awsClient 
   * @param {*} cognitoUserId 
   * @returns kms response obj
   */
  export const decryptSymmetric = async (blobToDecrypt: any, cognitoUserId: string) => {
    const client = initiateKMSClient();
  
    const context = {
      stage: 'dev',
      purpose: 'lifechain symmetric',
      origin: 'eu-west-2',
    };
  
    const input = {
      CiphertextBlob: blobToDecrypt,
      EncryptionContext: context,
      KeyId: 'alias/' + cognitoUserId.substring(10),
    };
  
    const command = new DecryptCommand(input);
    const response = await client.send(command);
    
    response.DecodedPlainTxt = new TextDecoder().decode(response.Plaintext);
    
    return response;
  };
  
  /**
   * Initiates aws KMS client for API calls
   * @param awsClient 
   * @returns KMSClient
   */
  const initiateKMSClient = () => {
    return new KMSClient({
      credentials: {
        accessKeyId: process.env.ACCESS_KEY_ID as string,
        secretAccessKey: process.env.SEC_KEY as string,
        sessionToken: process.env.SESS_TOKEN as string
      },
      region: 'eu-west-2'
    });
  };