//
//  ReportViewController.m
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import "ReportViewController.h"
#import "KycResponse.h"

@interface ReportViewController ()

@property NSString *NOTAVAILABLE;
@property UIColor *alcheraColor;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"KYC Report";
    self.NOTAVAILABLE = @"N/A";
    self.alcheraColor = [UIColor colorNamed:@"alcheraColor"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLayoutSubviews {
    [self.idVerification setHidden:YES];
    [self.faceAuthentication setHidden:YES];
    [self.liveness setHidden:YES];
    [self.accountVerification setHidden:YES];
    
    self.txtEvent.layer.borderWidth = 1;
    self.txtEvent.layer.borderColor = [self.alcheraColor CGColor];
    self.txtEvent.text = [NSString stringWithFormat:@"result: %@", self.result];
    
    if (self.responseJson != nil) {
        self.txtDetail.text = [self prettyPrintedJson:self.responseJson];
        self.txtDetail.layer.borderWidth = 1;
        self.txtDetail.layer.borderColor = [self.alcheraColor CGColor];
    }
    
    [self drawResponse];
}

/* 완료 버튼 클릭 */
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

/* KYC 응답 Message 결과에 따라 표시 */
- (void)drawResponse {
    if (self.responseJson == nil) return;
    KycResponse *response = [KycResponse parsingJson:self.responseJson];
    if (response == nil) return;
    Review_result *detail = response.review_result;
    if (detail == nil) return;
    
    // 신분증 진위 확인
    if (detail.module.id_card_ocr && detail.module.id_card_verification) {
        [self.idVerification setHidden:NO];
        Id_card *id_card = detail.id_card;
        
        if (id_card != nil) {
            self.lblIdVerified.text = id_card.verified ? @"성공" : @"실패";
            self.lblIdVerified.textColor = id_card.verified ? self.alcheraColor : UIColor.redColor;
            self.imgIdMasking.image = [UIImage imageWithData:id_card.id_card_image];
            self.imgIdOrigin.image = [UIImage imageWithData:id_card.id_card_origin];
        } else {
            self.lblIdVerified.text = self.NOTAVAILABLE;
        }
    }
    
    // 신분증 vs 셀피 유사도
    if (detail.module.face_authentication) {
        [self.faceAuthentication setHidden:NO];
        Face_check *face_check = detail.face_check;
        
        if (face_check != nil) {
            self.lblSimilarity.text = face_check.is_same_person ? @"높음" : @"낮음";
            self.lblSimilarity.textColor = face_check.is_same_person ? self.alcheraColor : UIColor.redColor;
            self.imgIdCrop.image = [UIImage imageWithData:detail.id_card.id_crop_image];
            self.imgSelfie.image = [UIImage imageWithData:face_check.selfie_image];
        } else {
            self.lblSimilarity.text = self.NOTAVAILABLE;
        }
    }
    
    // 얼굴 사진 진위 확인
    if (detail.module.liveness) {
        [self.liveness setHidden:NO];
        Face_check *face_check = detail.face_check;
        if (face_check != nil) {
            self.lblLive.text = face_check.is_live ? @"성공" : @"실패";
            self.lblLive.textColor = face_check.is_live ? self.alcheraColor : UIColor.redColor;
        } else {
            self.lblLive.text = self.NOTAVAILABLE;
        }
    }
    
    // 1원 계좌 인증
    if (detail.module.account_verification) {
        [self.accountVerification setHidden:NO];
        Account *account = detail.account;
        if (account != nil) {
            self.lblAccountVerification.text = account.verified ? @"성공" : @"실패";
            self.lblAccountVerification.textColor = account.verified ? self.alcheraColor : UIColor.redColor;
            self.lblAccountUser.text = account.account_holder != nil ? account.account_holder : self.NOTAVAILABLE;
            self.lblAccountFinance.text = account.finance_company != nil ? account.finance_company : self.NOTAVAILABLE;
            self.lblFinanceCode.text = account.finance_code != nil ? account.finance_code : self.NOTAVAILABLE;
            self.lblAccountNumber.text = account.account_number != nil ? account.account_number : self.NOTAVAILABLE;
        } else {
            self.lblAccountVerification.text = self.NOTAVAILABLE;
        }
    }
}

/* 줄간격 적용된 JSON */
- (NSString *)prettyPrintedJson:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    if (jsonData != nil) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error == nil) {
            NSData *prettyData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
            if (error == nil) {
                NSString *prettyString = [[NSString alloc] initWithData:prettyData encoding:NSUTF8StringEncoding];
                return prettyString;
            } else {
                NSLog(@"Json 데이터 변환에 실패했습니다. Error: %@", error.localizedDescription);
            }
        } else {
            NSLog(@"Json 데이터 변환에 실패했습니다. Error: %@", error.localizedDescription);
        }
    }
    
    return jsonString;
}

@end
