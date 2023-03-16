//
//  KycParams.m
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import "KycParams.h"

@implementation KycParams

// 고객사에서 사용자 필수정보를 관리 안함
+ (NSDictionary *)ocr { return [KycParams dictionary:2]; }
+ (NSDictionary *)ocr_face { return [KycParams dictionary:3]; }
+ (NSDictionary *)ocr_face_liveness { return [KycParams dictionary:4]; }
+ (NSDictionary *)all { return [KycParams dictionary:5]; }
+ (NSDictionary *)account { return [KycParams dictionary:6]; }
+ (NSDictionary *)ocr_account { return [KycParams dictionary:7]; }
+ (NSDictionary *)ocr_face_account { return [KycParams dictionary:8]; }

// 고객사에서 사용자 필수정보를 관리 중
+ (NSDictionary *)db_ocr { return [KycParams dictionary:9]; }
+ (NSDictionary *)db_ocr_face { return [KycParams dictionary:10]; }
+ (NSDictionary *)db_ocr_face_liveness { return [KycParams dictionary:11]; }
+ (NSDictionary *)db_all { return [KycParams dictionary:12]; }
+ (NSDictionary *)db_account { return [KycParams dictionary:13]; }
+ (NSDictionary *)db_ocr_account { return [KycParams dictionary:14]; }
+ (NSDictionary *)db_ocr_face_account { return [KycParams dictionary:15]; }

+ (NSDictionary *)dictionary:(int)index {
    return @{@"customer_id": [NSString stringWithFormat:@"%d", index],
             @"id": @"demoUser",
             @"key": @"demoUser0000!"};
}

@end
