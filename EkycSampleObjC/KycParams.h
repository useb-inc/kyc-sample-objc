//
//  KycParams.h
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KycParams : NSObject

// 고객사에서 사용자 필수정보를 관리 안함
+ (NSDictionary *)ocr;
+ (NSDictionary *)ocr_face;
+ (NSDictionary *)ocr_face_liveness;
+ (NSDictionary *)all;
+ (NSDictionary *)account;
+ (NSDictionary *)ocr_account;
+ (NSDictionary *)ocr_face_account;

// 고객사에서 사용자 필수정보를 관리 중
+ (NSDictionary *)db_ocr;
+ (NSDictionary *)db_ocr_face;
+ (NSDictionary *)db_ocr_face_liveness;
+ (NSDictionary *)db_all;
+ (NSDictionary *)db_account;
+ (NSDictionary *)db_ocr_account;
+ (NSDictionary *)db_ocr_face_account;

+ (NSDictionary *)dictionary:(int)index;

@end

NS_ASSUME_NONNULL_END
