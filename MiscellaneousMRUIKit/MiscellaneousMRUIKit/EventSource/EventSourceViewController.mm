//
//  EventSourceViewController.mm
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/11/25.
//

#import "EventSourceViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

UIKIT_EXTERN NSString * _NSStringFromUIViewControllerAppearState(int state);
/*
 disappeared 0
 appearing 1
 appeared 2
 disappearing 3
 */

@interface EventSourceViewController ()
@property (retain, nonatomic, nullable, getter=_label, setter=_setLabel:) UILabel *label;
@end

@implementation EventSourceViewController

- (void)dealloc {
    id eventSource = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIRealityKitSimulationEventSource"), sel_registerName("sharedInstance"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(eventSource, sel_registerName("removeObserver:"), self);
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.3.horizontal"] style:UIBarButtonItemStylePlain target:self action:@selector(_didTriggerBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [barButtonItem release];
}

- (void)simulationEventSource:(id)eventSource didReceiveEntityEvent:(id)event {
    int _appearState = reinterpret_cast<int (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_appearState"));
    if (!((_appearState == 1) or (_appearState == 2))) return;
    
    NSUInteger type = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(event, sel_registerName("type"));
    void *entity = reinterpret_cast<void * (*)(id, SEL)>(objc_msgSend)(event, sel_registerName("entity"));
    id _entity = reinterpret_cast<id (*)(id, SEL, void *)>(objc_msgSend)([objc_lookUpClass("MRUIREEntity") alloc], sel_registerName("initWithREEntity:"), entity);
    NSUInteger localID = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(_entity, sel_registerName("localID"));
    [_entity release];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Event"
                                                                             message:[NSString stringWithFormat:@"type : %ld, localID : %ld", type, localID]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:doneAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_didTriggerBarButtonItem:(UIBarButtonItem *)sender {
    if (UILabel *_label = self.label) {
        [_label removeFromSuperview];
        
        id eventSource = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIRealityKitSimulationEventSource"), sel_registerName("sharedInstance"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(eventSource, sel_registerName("removeObserver:"), self);
        
        self.label = nil;
    } else {
        UILabel *label = [UILabel new];
        label.text = @"Label";
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:label];
        [NSLayoutConstraint activateConstraints:@[
            [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
            [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
        ]];
        
        reinterpret_cast<void (*)(id, SEL, NSInteger, id)>(objc_msgSend)(label, sel_registerName("_requestSeparatedState:withReason:"), 1, @"_UIViewSeparatedStateRequestReasonUnspecified");
        
        id eventSource = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("MRUIRealityKitSimulationEventSource"), sel_registerName("sharedInstance"));
        void *reEntity = reinterpret_cast<void * (*)(id, SEL)>(objc_msgSend)(label, sel_registerName("reEntity"));
        assert(reEntity != NULL);
        
        reinterpret_cast<void (*)(id, SEL, id, void *)>(objc_msgSend)(eventSource, sel_registerName("addObserver:forEntity:"), self, reEntity);
        
        self.label = label;
        [label release];
    }
}

@end
