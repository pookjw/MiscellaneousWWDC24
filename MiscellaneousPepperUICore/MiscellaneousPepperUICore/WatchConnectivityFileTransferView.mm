//
//  WatchConnectivityFileTransferView.m
//  MiscellaneousPepperUICore
//
//  Created by Jinwoo Kim on 12/13/24.
//

#import "WatchConnectivityFileTransferView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface WatchConnectivityFileTransferView ()
@property (retain, nonatomic, readonly) UIStackView *_stackView;
@property (retain, nonatomic, readonly) UIProgressView *_progressView;
@property (retain, nonatomic, readonly) UIButton *_cancelButton;
@end

@implementation WatchConnectivityFileTransferView
@synthesize _stackView = __stackView;
@synthesize _progressView = __progressView;
@synthesize _cancelButton = __cancelButton;

- (instancetype)initWithFileTransfer:(WCSessionFileTransfer *)fileTransfer {
    if (self = [super initWithFrame:CGRectNull]) {
        _fileTransfer = [fileTransfer retain];
        
        UIStackView *stackView = self._stackView;
        [self addSubview:stackView];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_addBoundsMatchingConstraintsForView:"), stackView);
    }
    
    return self;
}

- (void)dealloc {
    [_fileTransfer release];
    [__stackView release];
    [__progressView release];
    [__cancelButton release];
    [super dealloc];
}

- (UIStackView *)_stackView {
    if (auto stackView = __stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self._progressView,
        self._cancelButton
    ]];
    
    stackView.spacing = UIStackViewSpacingUseSystem;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFill;
    
    __stackView = [stackView retain];
    return [stackView autorelease];
}

- (UIProgressView *)_progressView {
    if (auto progressView = __progressView) return progressView;
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    
    progressView.observedProgress = self.fileTransfer.progress;
    
    __progressView = [progressView retain];
    return [progressView autorelease];
}

- (UIButton *)_cancelButton {
    if (auto cancelButton = __cancelButton) return cancelButton;
    
    UIButton *cancelButton = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration filledButtonConfiguration];
    configuration.image = [UIImage systemImageNamed:@"xmark"];
    configuration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
    
    cancelButton.configuration = configuration;
    
    [cancelButton addTarget:self action:@selector(_didTriggerCancelButton:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    __cancelButton = [cancelButton retain];
    return [cancelButton autorelease];
}

- (void)_didTriggerCancelButton:(UIButton *)sender {
    [self.fileTransfer cancel];
}

@end
