//
//  ViewController.m
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnRun.layer.cornerRadius = 20;
    self.txtName.delegate = self;
    self.txtBirthYear.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

/* WebView 실행 */
- (IBAction)runButtonPressed:(UIButton *)sender {
    WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    if (webVC == nil) return;
    
    NSString *name = self.txtName.text;
    NSString *year = self.txtBirthYear.text;
    NSString *month = self.txtBirthMonth.text;
    NSString *day = self.txtBirthDay.text;
    NSString *phoneNumber = self.txtPhoneNumber.text;
    NSString *email = self.txtEmail.text;
    
    if (name.length > 0 && year.length > 0 && month.length > 0 && day.length > 0 && phoneNumber.length > 0 && email.length > 0) {
        NSDictionary *customerData = @{@"name": name,
                                       @"birthday": [NSString stringWithFormat:@"%@-%@-%@", year, month, day],
                                       @"phone_number": phoneNumber,
                                       @"email": email
        };
        webVC.customerData = customerData;
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

/* 키보드 생성 시 화면 이동 */
- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.view.frame.origin.y == 0) {
        CGRect frame = self.view.frame;
        frame.origin.y -= 150;
        [self.view setFrame:frame];
    }
}

/* 키보드 제거 시 화면 원복 */
- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [self.view setFrame:frame];
}

/* 화면 클릭 시 키보드 내림 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/* 키보드의 Return 버튼 클릭 시 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [self.view endEditing:YES];
}

@end
