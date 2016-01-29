# Decrypt Visa Checkout Payload (visa_msg_decrypt)
## Simple function to decrypt Visa Checkout Payload

##Who should use it
If you intent to use Visa Checkout in your web app and you have a node.js server, you should use this library. Visa Checkout returns a payload that contains the consumer's information, which is encrypted. Before you decrypt the payload, you must move it (both its key, encKey, and the encrypted data, encPaymentData), to a secure server (in this case a secured node.js server). 

[http://developer.visacheckout.com](http://developer.visacheckout.com) is the primary website where you can find more information on Visa Checkout .


##Decryption Algorithm:

    First, decrypt the encKey -
	1. Base64-decode the encrypted dynamic key (encKey)
    2. Remove the first 32 bytes of the decoded value–this is the HMAC. Calculate a SHA-256 HMAC of the rest of the decoded data using your shared secret and compare it with the HMAC from the first 32 bytes.
    3. The next 16 bytes should be removed and used as the IV for the decryption algorithm
    4. Decrypt the remaining data using AES-256-CBC, the IV from Step 1c, and the SHA-256 hash of the shared secret.
    Now, decrypt the payment data payload (encPaymentData) using the decrypted dynamic key from Step 4
    5. Base64-decode the encrypted payment data
    6. Remove the first 32 bytes of the decoded value–this is the HMAC.  Calculate a SHA-256 HMAC of the rest of the decoded data using your decrypted dynamic key and compare it with the HMAC from the first 32 bytes.
    7. The next 16 bytes should be removed and used as the IV for the decryption algorithm.
    8. Decrypt the rest of the payload using AES-256-CBC, the IV from Step 2c, and the SHA-256 hash of the decrypted dynamic key.

    
##Example 


    var VisaPayloadDecrypt = require('visa_msg_decrypt');
    var Decrypt, decryptedJson;
    
    // constructor takes 2 parameters : 
    // - secret Key (string)
    // - enable logging (boolean)
    Decrypt = new VisaPayloadDecrypt(secretKey, true);
    decryptedJson = Decrypt.decrypt(jsonPayloadSentByVisaServer);
    
    // print decrypted Json
    console.log(decryptedJson);
    

---

Code Coverage : 100%    

Rajat Kumar, 2016    