//
//  ReportViewController.h
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportViewController : UIViewController

@property NSString *result;
@property NSString *responseJson;

@property (weak, nonatomic) IBOutlet UITextView *txtEvent;
@property (weak, nonatomic) IBOutlet UITextView *txtDetail;

@property (weak, nonatomic) IBOutlet UIStackView *idVerification;
@property (weak, nonatomic) IBOutlet UILabel *lblIdVerified;
@property (weak, nonatomic) IBOutlet UIImageView *imgIdMasking;
@property (weak, nonatomic) IBOutlet UIImageView *imgIdOrigin;

@property (weak, nonatomic) IBOutlet UIStackView *faceAuthentication;
@property (weak, nonatomic) IBOutlet UILabel *lblSimilarity;
@property (weak, nonatomic) IBOutlet UIImageView *imgIdCrop;
@property (weak, nonatomic) IBOutlet UIImageView *imgSelfie;

@property (weak, nonatomic) IBOutlet UIStackView *liveness;
@property (weak, nonatomic) IBOutlet UILabel *lblLive;

@property (weak, nonatomic) IBOutlet UIStackView *accountVerification;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountVerification;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountUser;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountFinance;
@property (weak, nonatomic) IBOutlet UILabel *lblFinanceCode;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountNumber;

@end

NS_ASSUME_NONNULL_END
