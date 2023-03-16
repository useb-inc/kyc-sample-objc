//
//  WebViewController.h
//  EkycSampleObjC
//
//  Created by Alchera on 2023/03/14.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>
#import "KycResponse.h"
#import "KycParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController <WKUIDelegate, WKScriptMessageHandler>

@property WKWebView *webView;
@property NSDictionary *customerData;

@end

NS_ASSUME_NONNULL_END
