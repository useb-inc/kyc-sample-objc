//
//  KycResponse.m
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import "KycResponse.h"

@implementation Module

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary isKindOfClass:NSDictionary.class]) {
            self.id_card_ocr = [dictionary objectForKey:@"id_card_ocr"];
            self.id_card_verification = [dictionary objectForKey:@"id_card_verification"];
            self.face_authentication = [dictionary objectForKey:@"face_authentication"];
            self.account_verification = [dictionary objectForKey:@"account_verification"];
            self.liveness = [dictionary objectForKey:@"liveness"];
        }
    }
    return self;
}
@end

@implementation Id_card
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary isKindOfClass:NSDictionary.class]) {
            self.modified = [dictionary objectForKey:@"modified"];
            self.verified = [dictionary objectForKey:@"verified"];
            
            NSString *image_card_image_string = [dictionary objectForKey:@"id_card_image"];
            if ([image_card_image_string isKindOfClass:NSString.class]) {
                self.id_card_image = [[NSData alloc] initWithBase64EncodedString:image_card_image_string options:kNilOptions];
            }
            
            NSString *id_card_origin_string = [dictionary objectForKey:@"id_card_origin"];
            if ([id_card_origin_string isKindOfClass:NSString.class]) {
                self.id_card_origin = [[NSData alloc] initWithBase64EncodedString:id_card_origin_string options:kNilOptions];
            }
            
            NSString *id_crop_image_string = [dictionary objectForKey:@"id_crop_image"];
            if ([id_crop_image_string isKindOfClass:NSString.class]) {
                self.id_crop_image = [[NSData alloc] initWithBase64EncodedString:id_crop_image_string options:kNilOptions];
            }
        }
    }
    return self;
}
@end

@implementation Face_check
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary isKindOfClass:NSDictionary.class]) {
            self.is_same_person = [dictionary objectForKey:@"is_same_person"];
            self.is_live = [dictionary objectForKey:@"is_live"];
            
            NSString *selfie_image_string = [dictionary objectForKey:@"selfie_image"];
            if ([selfie_image_string isKindOfClass:NSString.class]) {
                self.selfie_image = [[NSData alloc] initWithBase64EncodedString:selfie_image_string options:kNilOptions];
            }
        }
    }
    return self;
}
@end

@implementation Account
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary isKindOfClass:NSDictionary.class]) {
            self.verified = [dictionary objectForKey:@"verified"];
            self.account_holder = [dictionary objectForKey:@"account_holder"];
            self.finance_company = [dictionary objectForKey:@"finance_company"];
            self.finance_code = [dictionary objectForKey:@"finance_code"];
            self.account_number = [dictionary objectForKey:@"account_number"];
        }
    }
    return self;
}
@end

@implementation Review_result
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary isKindOfClass:NSDictionary.class]) {
            self.name = [dictionary objectForKey:@"name"];
            self.phone_number = [dictionary objectForKey:@"phone_number"];
            self.birthday = [dictionary objectForKey:@"birthday"];
            self.module = [[Module alloc] initWithDictionary:[dictionary objectForKey:@"module"]];
            self.id_card = [[Id_card alloc] initWithDictionary:[dictionary objectForKey:@"id_card"]];
            self.face_check = [[Face_check alloc] initWithDictionary:[dictionary objectForKey:@"face_check"]];
            self.account = [[Account alloc] initWithDictionary:[dictionary objectForKey:@"account"]];
        }
    }
    return self;
}
@end

@implementation KycResponse
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if ([dictionary isKindOfClass:NSDictionary.class]) {
            self.result = [dictionary objectForKey:@"result"];
            self.review_result = [[Review_result alloc] initWithDictionary:[dictionary objectForKey:@"review_result"]];
        }
    }
    return self;
}

/* Json을 KycResponse로 변환합니다. */
+ (nullable KycResponse *)parsingJson:(NSString *)jsonString {
    NSData *uriDecodedData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    if (uriDecodedData != nil) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:uriDecodedData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            KycResponse *response = [[KycResponse alloc] initWithDictionary:jsonDictionary];
            return response;
        } else {
            NSLog(@"KYC 결과 정보 분석중 오류가 발생했습니다. Error: %@", error.localizedDescription);
        }
    }
    
    return nil;
}
@end
