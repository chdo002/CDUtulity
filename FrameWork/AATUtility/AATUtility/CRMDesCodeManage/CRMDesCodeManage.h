//
//  CRMDesCodeManage.h
//  crm_ios
//
//  Created by HansonYang on 16/3/24.
//  Copyright © 2016年 pingan. All rights reserved.
//

#import "GTMBase64.h"
#import <Foundation/Foundation.h>

@interface CRMDesCodeManage : NSObject

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;


// 数据库 内容 加密；

+ (NSString *) encryptUseDESLocalData:(NSString *)plainText key:(NSString *)key;

+ (NSString *) decryptUseDESLocalData:(NSString*)cipherText key:(NSString*)key;

 
@end
