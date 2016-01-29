###
  Algo:
    1. Base64-decode the encrypted dynamic key
    2. Remove the first 32 bytes of the decoded value–this is the HMAC. Calculate a SHA-256 HMAC of the rest of the decoded data using your shared secret and compare it with the HMAC from the first 32 bytes.
    3. The next 16 bytes should be removed and used as the IV for the decryption algorithm
    4. Decrypt the remaining data using AES-256-CBC, the IV from Step 1c, and the SHA-256 hash of the shared secret.

    Now, Decrypt the payment data payload (encPaymentData) using the decrypted dynamic key from Step 4
    5. Base64-decode the encrypted payment data
    6. Remove the first 32 bytes of the decoded value–this is the HMAC.  Calculate a SHA-256 HMAC of the rest of the decoded data using your decrypted dynamic key and compare it with the HMAC from the first 32 bytes.
    7. The next 16 bytes should be removed and used as the IV for the decryption algorithm.
    8. Decrypt the rest of the payload using AES-256-CBC, the IV from Step 2c, and the SHA-256 hash of the decrypted dynamic key.

  Author: Rajat Kumar
###

fs = require('fs')
crypto = require('crypto')

class VisaPayloadDecrypt
  constructor:(@secret, @enableLogs) ->
    @enableLogs = @enableLogs || false

  decrypt: (jsonPayload) ->
    if @secret is undefined then throw new Error('Invalid secret key.')
    if jsonPayload?.encKey
      dynamicSecretKey = @_decryptData(@secret, jsonPayload.encKey)
      if (jsonPayload?.encPaymentData)
        paymentData = @_decryptData(dynamicSecretKey, jsonPayload.encPaymentData)
        return JSON.parse paymentData
      else
        throw new Error('Payload does not contain encPaymentData.')
    else
      throw new Error('Payload does not contain encKey.')

  _decryptData: (key, payload) ->
    buf = new Buffer(payload, 'base64')
    hmac = buf.slice(0, 32)
    iv = buf.slice(32, 48)
    data = buf.slice(48)
    iv_data = buf.slice(32)
    shaKey = crypto.createHash('sha256').update(key).digest()
    calcHmac = crypto.createHmac('sha256', key).update(iv_data).digest('base64')
    if @enableLogs then console.log 'HMAC:' + hmac.toString('base64')
    if @enableLogs then console.log 'Generated HMAC:' + calcHmac
    if hmac.toString('base64') == calcHmac
      if @enableLogs then console.log 'HMAC verification successfull'
      decryptor = crypto.createDecipheriv('aes-256-cbc', shaKey, iv)
      decryptedText = decryptor.update(data, 'binary', 'binary') + decryptor.final('binary')
      return decryptedText
    else
      throw new Error('Invalid payload or key. HMAC verification failed.')


module.exports = VisaPayloadDecrypt

