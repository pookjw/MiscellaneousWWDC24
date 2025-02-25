//
//  ObjCImageCreatorViewController.m
//  MyApp
//
//  Created by Jinwoo Kim on 2/25/25.
//

#import "ObjCImageCreatorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "MyApp-Swift.h"

// -[NSXPCConnection _sendSelector:withProxy:arg1:arg2:arg3:arg4:]

/*
 (lldb) po [NSObject _fd__protocolDescriptionForProtocol:(Protocol *)NSProtocolFromString(@"ImagePlayground.GPNonUIExtension")]
 <ImagePlayground.GPNonUIExtension: 0x1f86e1c60> :
 in ImagePlayground.GPNonUIExtension:
     Instance Methods:
         - (void) releaseAssertion;
         - (void) acquireAssertion;
         - (void) stopGeneration:(id)arg1;
         - (void) fetchAvailableStylesWithCompletion:(^block)arg1;
         - (void) startGenerationWithStyle:(id)arg1 promptElements:(id)arg2 replyHandler:(^block)arg3 batchID:(id)arg4;
 */

@interface ObjCImageCreatorViewController ()
@property (retain, nonatomic, readonly, getter=_connection) NSXPCConnection *connection;
@property (retain, nonatomic, readonly, getter=_barButtonItem) UIBarButtonItem *barButtonItem;
@property (retain, nonatomic, readonly, getter=_promptElements) NSMutableArray *promptElements;
@property (assign, nonatomic, getter=_requestCount, setter=_setRequestCount:) NSUInteger requestCount;
@property (copy, nonatomic, nullable, getter=_style, setter=_setStyle:) NSString *style;
@property (retain, nonatomic, readonly, getter=_resultImages) NSMutableArray<UIImage *> *resultImages;
@property (retain, nonatomic, readonly, getter=_cellRegistration) UICollectionViewCellRegistration *cellRegistration;
@property (retain, nonatomic, readonly, getter=_activityIndicatorView) UIActivityIndicatorView *activityIndicatorView;
@property (copy, nonatomic, nullable, getter=_batchID, setter=_setBatchID:) NSUUID *batchID;
@property (copy, nonatomic, nullable, getter=_allStyles, setter=_setAllStyles:) NSArray<NSString *> *allStyles;
@end

@implementation ObjCImageCreatorViewController
@synthesize barButtonItem = _barButtonItem;
@synthesize cellRegistration = _cellRegistration;
@synthesize activityIndicatorView = _activityIndicatorView;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        [self _commonInit_ObjCImageCreatorViewController];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionViewCompositionalLayoutConfiguration *configuration = [UICollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
        NSUInteger quotient = floor(layoutEnvironment.container.contentSize.width / 200.);
        NSUInteger count = MAX(quotient, 2);
        
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1. / count]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        item.contentInsets = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1. / count]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize repeatingSubitem:item count:count];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        section.contentInsets = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
        
        return section;
    }
                                                                                                                       configuration:configuration];
    [configuration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        [self _commonInit_ObjCImageCreatorViewController];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit_ObjCImageCreatorViewController];
    }
    
    return self;
}

- (void)dealloc {
    if (NSUUID *batchID = self.batchID) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_connection.remoteObjectProxy, sel_registerName("stopGeneration:"), batchID);
    }
    
    [_connection invalidate];
    [_connection release];
    [_barButtonItem release];
    [_promptElements release];
    [_resultImages release];
    [_activityIndicatorView release];
    [_style release];
    [_batchID release];
    [_allStyles release];
    [super dealloc];
}

- (void)_commonInit_ObjCImageCreatorViewController {
    id query = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_EXQuery") alloc], sel_registerName("initWithExtensionPointIdentifier:"), @"com.apple.ImagePlayground.NonUIExtension");
    NSArray *identities = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("_EXQuery"), sel_registerName("executeQuery:"), query);
    [query release];
    
    NSError * _Nullable error = nil;
    NSXPCConnection *connection = reinterpret_cast<id (*)(id, SEL, id *)>(objc_msgSend)(identities[0], sel_registerName("makeXPCConnectionWithError:"), &error);
    assert(error == nil);
    
    connection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"ImagePlayground.GPNonUIExtension")];
    [connection resume];
    
    assert(connection.remoteObjectProxy != nil);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(connection.remoteObjectProxy, sel_registerName("fetchAvailableStylesWithCompletion:"), ^(NSArray<NSString *> *allStyles) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allStyles = allStyles;
            self.style = allStyles.firstObject;
        });
    });
    
    _connection = [connection retain];
    _promptElements = [NSMutableArray new];
    
    id promptElement = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("GPPromptElement") alloc], sel_registerName("initWithText:"), @"Cat");
    [_promptElements addObject:promptElement];
    [promptElement release];
    
    _resultImages = [NSMutableArray new];
    _requestCount = 4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _cellRegistration];
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    parent.navigationItem.rightBarButtonItem = self.barButtonItem;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resultImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:self.resultImages[indexPath.item]];
}

- (UICollectionViewCellRegistration *)_cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class] configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, UIImage * _Nonnull image) {
        UIImageView *imageView = nil;
        for (UIImageView *subview in cell.contentView.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                imageView = subview;
                break;
            }
        }
        
        if (imageView == nil) {
            imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:imageView];
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(cell.contentView, sel_registerName("_addBoundsMatchingConstraintsForView:"), imageView);
        }
        
        imageView.image = image;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (UIBarButtonItem *)_barButtonItem {
    if (auto barButtonItem = _barButtonItem) return barButtonItem;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"apple.intelligence"] menu:[self _makeMenu]];
    
    _barButtonItem = barButtonItem;
    return barButtonItem;
}


- (UIActivityIndicatorView *)_activityIndicatorView {
    if (auto activityIndicatorView = _activityIndicatorView) return activityIndicatorView;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    
    _activityIndicatorView = activityIndicatorView;
    return activityIndicatorView;
}

- (UIMenu *)_makeMenu {
    NSMutableArray *promptElements = self.promptElements;
    __weak auto unretainedSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            NSMutableArray<UIAction *> *textActions = [[NSMutableArray alloc] initWithCapacity:promptElements.count];
            for (id promptElement in promptElements) {
                NSString *text = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(promptElement, sel_registerName("text"));
                UIAction *action = [UIAction actionWithTitle:text image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [promptElements removeObject:promptElement];
                }];
                action.subtitle = @"Remove";
                action.attributes = UIMenuOptionsDestructive;
                [textActions addObject:action];
            }
            
            UIMenu *textsMenu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:textActions];
            [textActions release];
            
            UIAction *addTextAction = [UIAction actionWithTitle:@"Add Text" image:[UIImage systemImageNamed:@"plus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [unretainedSelf _presentAddingTextAlertController];
            }];
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Text" children:@[textsMenu, addTextAction]];
            [results addObject:menu];
        }
        
        {
            NSUInteger requestCount = unretainedSelf.requestCount;
            
            __kindof UIMenuElement *stepperElement = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UILabel *label = [UILabel new];
                label.text = @(requestCount).stringValue;
                
                UIStepper *stepper = [UIStepper new];
                stepper.minimumValue = 1.;
                stepper.maximumValue = 10.;
                stepper.value = requestCount;
                stepper.continuous = YES;
                stepper.autorepeat = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    auto stepper = static_cast<UIStepper *>(action.sender);
                    unretainedSelf.requestCount = stepper.value;
                    label.text = @(static_cast<NSUInteger>(stepper.value)).stringValue;
                }];
                
                [stepper addAction:action forControlEvents:UIControlEventValueChanged];
                
                UIStackView *stackView = [UIStackView new];
                [stackView addArrangedSubview:label];
                [label release];
                [stackView addArrangedSubview:stepper];
                [stepper release];
                stackView.axis = UILayoutConstraintAxisVertical;
                stackView.distribution = UIStackViewDistributionFill;
                stackView.alignment = UIStackViewAlignmentFill;
                
                return [stackView autorelease];
            });
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Request Count" children:@[stepperElement]];
            [results addObject:menu];
        }
        
        if (unretainedSelf.allStyles == nil) {
            UIAction *action = [UIAction actionWithTitle:@"Retrieving Styles..." image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                
            }];
            action.attributes = UIMenuElementAttributesDisabled;
            [results addObject:action];
        } else {
            {
                NSArray<NSString *> *allStyles = unretainedSelf.allStyles;
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:allStyles.count];
                NSString *selectedStyle = unretainedSelf.style;
                
                for (NSString *style in allStyles) {
                    UIAction *action = [UIAction actionWithTitle:style image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        unretainedSelf.style = style;
                    }];
                    
                    action.state = ([style isEqualToString:selectedStyle]) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [actions addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Style" children:actions];
                [actions release];
                menu.subtitle = selectedStyle;
                [results addObject:menu];
            }
            
            {
                if (promptElements.count > 0) {
                    UIAction *performAcion = [UIAction actionWithTitle:@"Perform" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        [unretainedSelf _requestWithBatchID:[NSUUID UUID] startingFromIndex:0];
                    }];
                    
                    [results addObject:performAcion];
                }
            }
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)_requestWithBatchID:(NSUUID *)batchID startingFromIndex:(NSInteger)index {
    if (self.requestCount <= index) {
        self.batchID = nil;
        [self.activityIndicatorView stopAnimating];
        self.barButtonItem.customView = nil;
        self.barButtonItem.menu = [self _makeMenu];
        return;
    }
    
    if (index == 0) {
        self.batchID = batchID;
        self.barButtonItem.menu = nil;
        self.barButtonItem.customView = self.activityIndicatorView;
        [self.activityIndicatorView startAnimating];
    }
    
    __weak auto unretainedSelf = self;
    
    reinterpret_cast<void (*)(id, SEL, id, id, id, id)>(objc_msgSend)(self.connection.remoteObjectProxy, sel_registerName("startGenerationWithStyle:promptElements:replyHandler:batchID:"), self.style, self.promptElements, ^(id result, NSError *error){
        assert(error == nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            [unretainedSelf _didReceiveResult:result];
            [unretainedSelf _requestWithBatchID:batchID startingFromIndex:index + 1];
        });
    }, batchID);
}

- (void)_presentAddingTextAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Text" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    NSMutableArray *promptElements = self.promptElements;
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertController = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(action, sel_registerName("_alertController"));
        UITextField *textField = alertController.textFields[0];
        NSString *text = textField.text;
        if ((text == nil) or (text.length == 0)) return;
        
        id promptElement = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("GPPromptElement") alloc], sel_registerName("initWithText:"), text);
        [promptElements addObject:promptElement];
        [promptElement release];
    }];
    [alertController addAction:doneAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_didReceiveResult:(id)result {
    CGImageRef cgImage = MyApp::getCGImageFromGPImageAndFormat(result);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    [self.resultImages insertObject:image atIndex:0];
    
    UICollectionView *collectionView = self.collectionView;
    [collectionView performBatchUpdates:^{
        [collectionView insertItemsAtIndexPaths:@[
            [NSIndexPath indexPathForItem:0 inSection:0]
        ]];
    }
                             completion:^(BOOL finished) {
        
    }];
}

@end
