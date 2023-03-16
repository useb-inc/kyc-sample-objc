//
//  WebViewController.m
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import "WebViewController.h"
#import "ReportViewController.h"

@interface WebViewController ()

@property NSString *responseName;
@property NSString *result;
@property NSString *responseJson;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"eKYC";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkCameraPermission];
    [self.navigationController setNavigationBarHidden:NO];
}

/* View 불러오기 */
- (void)loadView {
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    [webConfiguration setAllowsInlineMediaPlayback:YES];
    
    // 고객 정보를 담은 postMessage 설정
    NSString *requestData = [self encodedPostMessage];
    if (requestData != nil) {
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[NSString stringWithFormat:@"postMessage('%@')", requestData]
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                       forMainFrameOnly:YES];
        [webConfiguration.userContentController addUserScript:userScript];
        webConfiguration.preferences.javaScriptEnabled = YES;
    }
    // 메시지 수신할 핸들러 등록
    self.responseName = @"alcherakyc";
    [webConfiguration.userContentController addScriptMessageHandler:self name:self.responseName];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfiguration];
    [self.webView setUIDelegate:self];
    self.view = self.webView;
}


/* WebView 불러오기 */
- (void)loadWebView {
    NSURL *url = [NSURL URLWithString:@"https://kyc.useb.co.kr/auth"];
    if (url == nil) return;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

/* KYC 결과 창으로 이동 */
- (void)loadReportView {
    ReportViewController *reportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"reportView"];
    if (reportVC == nil) return;
    
    reportVC.result = self.result;
    reportVC.responseJson = self.responseJson;
    [self.navigationController pushViewController:reportVC animated:YES];
}

/* webView Javascript Alert 처리 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

/* WebView 메시지 핸들러 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (message.name != self.responseName || message.body == nil) return;
    
    NSString *decodedMessage = [self decodedPostMessage:message.body];
    if (decodedMessage == nil) {
        NSLog(@"KYC 응답 메시지 분석에 실패했습니다.");
        return;
    }
    KycResponse *kycResponse = [KycResponse parsingJson:decodedMessage];
    if (kycResponse == nil) {
        NSLog(@"KYC 응답 메시지 변환에 실패했습니다.");
        return;
    }
    
    self.result = kycResponse.result;
    if ([kycResponse.result isEqualToString:@"success"]) {
        NSLog(@"KYC 작업이 성공했습니다.");
        self.responseJson = decodedMessage;
    } else if ([kycResponse.result isEqualToString:@"failed"]) {
        NSLog(@"KYC가 작업이 실패했습니다.");
        self.responseJson = decodedMessage;
    } else if ([kycResponse.result isEqualToString:@"complete"]) {
        NSLog(@"KYC가 완료되었습니다.");
        if (self.responseJson == nil) self.responseJson = decodedMessage;
        [self loadReportView];
    } else if ([kycResponse.result isEqualToString:@"close"]) {
        NSLog(@"KYC가 완료되지 않았습니다.");
        if (self.responseJson == nil) self.responseJson = decodedMessage;
        [self loadReportView];
    } else {
        self.result = nil;
        self.responseJson = nil;
    }
}

/* Camera 권한 체크 */
- (void)checkCameraPermission {
    AVAuthorizationStatus permission = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (permission) {
        case AVAuthorizationStatusAuthorized: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadWebView];
            });
            break;
        }
        case AVAuthorizationStatusDenied: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"카메라 권한 필요"
                                                                           message:@"설정 > 개인 정보 보호 > 카메라에서 권한을 변경하실 수 있습니다."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:NO completion:nil];
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            // 권한 요청
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadWebView];
                    });
                } else {
                    NSLog(@"권한이 거부되었습니다.");
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            break;
        }
        default:
            NSLog(@"Permission = %ld", permission);
            break;
    }
}

/* PostMessage로 보낼 고객 정보를 생성합니다. */
- (nullable NSString *)encodedPostMessage {
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithDictionary:KycParams.all];
    if (self.customerData != nil) {
        jsonDictionary = [NSMutableDictionary dictionaryWithDictionary:KycParams.db_all];
        for (NSString *key in self.customerData) {
            jsonDictionary[key] = self.customerData[key];
        }
    }
    
    // JSON -> encodeURIComponent -> Base64Encoding
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        NSLog(@"고객 정보 생성에 실패했습니다. Error: %@", error.localizedDescription);
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (jsonString != nil) {
        NSString *uriEncoded = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return [[uriEncoded dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    
    return nil;
}

/* KYC 수행 결과를 분석합니다. */
- (nullable NSString *)decodedPostMessage:(nonnull NSString *)encodedMessage {
    // Base64Decoding -> decodeURIComponent -> JSON
    NSData *base64DecodedData = [[NSData alloc] initWithBase64EncodedString:encodedMessage options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (base64DecodedData != nil) {
        NSString *base64DecodedString = [[NSString alloc] initWithData:base64DecodedData encoding:NSUTF8StringEncoding];
        if (base64DecodedData != nil) {
            NSString *jsonString = [base64DecodedString stringByRemovingPercentEncoding];
            return jsonString;
        }
    }
    
    return nil;
}

@end
