//
//  CRMDesCodeManage.m
//  crm_ios
//
//  Created by HansonYang on 16/3/24.
//  Copyright © 2016年 pingan. All rights reserved.
//
#import <CommonCrypto/CommonCryptor.h>

#import "CRMDesCodeManage.h"

@implementation CRMDesCodeManage

//  数据库 加密；
+ (NSString *) encryptUseDESLocalData:(NSString *)plainText key:(NSString *)key
{
    
    NSString *Code = [[self class] TripleDES:plainText MyKey:key encryptOrDecrypt:kCCEncrypt];
    
    return Code;
    
}

+ (NSString *) decryptUseDESLocalData:(NSString*)cipherText key:(NSString*)key
{
  
    NSString *enCodeText = [[self class] TripleDES:cipherText MyKey:key encryptOrDecrypt:kCCDecrypt];
    
    return enCodeText;
}

//  非数据库 加密；
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    
    NSString *Code = [[self class] TripleDES:plainText MyKey:key encryptOrDecrypt:kCCEncrypt];

//    
//    result = result.replaceAll("[+]", "%2B");
//    result = result.replaceAll("[/]", "%2F");
//    result = result.replaceAll("[=]", "%3D");
//    result = result.replaceAll("[ ]", "%20");
    
    Code = [Code stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    Code = [Code stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    Code = [Code stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    Code = [Code stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    
    return Code;
    
}


//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    
    NSString *enCodeText = [[self class] TripleDES:cipherText MyKey:key encryptOrDecrypt:kCCDecrypt];
 
    return enCodeText;
}

+(NSString*)TripleDES:(NSString*)plainText   MyKey:(NSString*)key   encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[key UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    free(bufferPtr);
    return result;
}



@end
