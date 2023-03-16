//
//  ViewController.h
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthYear;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthDay;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnRun;

@end

