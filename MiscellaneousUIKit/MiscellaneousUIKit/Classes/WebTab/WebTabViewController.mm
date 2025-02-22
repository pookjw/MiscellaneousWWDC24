//
//  WebTabViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 2/22/25.
//

#import "WebTabViewController.h"
#import <WebKit/WebKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface WebTabViewController () <WKWebExtensionControllerDelegate>
@property (retain, nonatomic, readonly, getter=_webView) WKWebView *webView;
@end

@implementation WebTabViewController
@synthesize webView = _webView;

- (void)dealloc {
    [_webView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = self.webView;
    [self.view addSubview:webView];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.view, sel_registerName("_addBoundsMatchingConstraintsForView:"), webView);
}

- (WKWebView *)_webView {
    if (auto webView = _webView) return webView;
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    
    WKWebExtensionControllerConfiguration *extensionConfiguration = [WKWebExtensionControllerConfiguration defaultConfiguration];
    WKWebExtensionController *webExtensionController = [[WKWebExtensionController alloc] initWithConfiguration:extensionConfiguration];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(webExtensionController, sel_registerName("_setTestingMode:"), YES);
    
    webExtensionController.delegate = self;
    
    {
        NSURL *url = [NSBundle.mainBundle URLForResource:@"web-extension-with-parent-directory" withExtension:UTTypeZIP.preferredFilenameExtension];
        assert(url != nil);
//        [WKWebExtension extensionWithResourceBaseURL:url completionHandler:^(WKWebExtension * _Nullable_result extension, NSError * _Nullable error) {
//            assert(error == nil);
//            WKWebExtensionContext *context = [WKWebExtensionContext contextForExtension:extension];
//            [webExtensionController loadExtensionContext:context error:&error];
//            assert(error == nil);
//            
//            
//        }];
        
        NSError * _Nullable error = nil;
        WKWebExtension *extension = reinterpret_cast<id (*)(id, SEL, id, id *)>(objc_msgSend)([WKWebExtension alloc], sel_registerName("_initWithResourceBaseURL:error:"), url, &error);
        assert(error == nil);
        WKWebExtensionContext *context = [WKWebExtensionContext contextForExtension:extension];
        
        for (WKWebExtensionPermission permission in extension.requestedPermissions) {
            [context setPermissionStatus:WKWebExtensionContextPermissionStatusGrantedExplicitly forPermission:permission];
        }
        
        [extension release];
        [webExtensionController loadExtensionContext:context error:&error];
        assert(error == nil);
        
        [context performActionForTab:nil];
    }
    
    configuration.webExtensionController = webExtensionController;
    [webExtensionController release];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectNull configuration:configuration];
    [configuration release];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
    [webView loadRequest:request];
    [request release];
    
    _webView = webView;
    return webView;
}

- (void)_webExtensionController:(WKWebExtensionController *)controller receivedTestMessage:(NSString *)message withArgument:(id)argument andSourceURL:(NSString *)sourceURL lineNumber:(unsigned)lineNumber {
    NSLog(@"%@", message);
}

- (void)webExtensionController:(WKWebExtensionController *)controller presentPopupForAction:(WKWebExtensionAction *)action forExtensionContext:(WKWebExtensionContext *)context completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    completionHandler(nil);
}

@end
