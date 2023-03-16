//
//  KycResponse.h
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import <Foundation/Foundation.h>

#ifndef KycResponse_h
#define KycResponse_h

@interface Module: NSObject
@property (nonatomic, assign) BOOL id_card_ocr;
@property (nonatomic, assign) BOOL id_card_verification;
@property (nonatomic, assign) BOOL face_authentication;
@property (nonatomic, assign) BOOL account_verification;
@property (nonatomic, assign) BOOL liveness;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface Id_card: NSObject
@property (nonatomic, assign) BOOL modified;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, strong) NSData *id_card_image;
@property (nonatomic, strong) NSData *id_card_origin;
@property (nonatomic, strong) NSData *id_crop_image;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface Face_check: NSObject
@property (nonatomic, assign) BOOL is_same_person;
@property (nonatomic, assign) BOOL is_live;
@property (nonatomic, strong) NSData *selfie_image;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface Account: NSObject
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, copy) NSString *account_holder;
@property (nonatomic, copy) NSString *finance_company;
@property (nonatomic, copy) NSString *finance_code;
@property (nonatomic, copy) NSString *account_number;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface Review_result: NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, strong) Module *module;
@property (nonatomic, strong) Id_card *id_card;
@property (nonatomic, strong) Face_check *face_check;
@property (nonatomic, strong) Account *account;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface KycResponse: NSObject
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) Review_result *review_result;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (KycResponse *)parsingJson:(NSString *)jsonString;
@end

#endif /* KycResponse_h */
