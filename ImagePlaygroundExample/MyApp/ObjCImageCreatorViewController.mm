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

@interface _ObjCImageFormat : NSObject <NSSecureCoding> {
    @package size_t _width;
    @package size_t _height;
    @package size_t _bitsPerComponent;
    @package size_t _bitsPerPixel;
    @package size_t _bytesPerRow;
    @package CGBitmapInfo _bitmapInfo;
    @package CGColorSpaceRef _colorSpace;
}
@end

@implementation _ObjCImageFormat

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _width = [coder decodeIntegerForKey:@"w"];
        _height = [coder decodeIntegerForKey:@"h"];
        _bitsPerComponent = [coder decodeIntegerForKey:@"bpc"];
        _bitsPerPixel = [coder decodeIntegerForKey:@"bpp"];
        _bytesPerRow = [coder decodeIntegerForKey:@"bpr"];
        
        NSNumber *iNumber = [coder decodeObjectOfClass:[NSNumber class] forKey:@"i"];
        _bitmapInfo = static_cast<CGBitmapInfo>(iNumber.integerValue);
        assert(coder.error == nil);
        
        NSString *cs = [coder decodeObjectOfClass:[NSString class] forKey:@"cs"];
        _colorSpace = CGColorSpaceCreateWithName((CFStringRef)cs);
        assert(coder.error == nil);
    }
    
    return self;
}

- (void)dealloc {
    CGColorSpaceRelease(_colorSpace);
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_width forKey:@"w"];
    [coder encodeInteger:_height forKey:@"h"];
    [coder encodeInteger:_bitsPerComponent forKey:@"bpc"];
    [coder encodeInteger:_bitsPerPixel forKey:@"bpp"];
    [coder encodeInteger:_bytesPerRow forKey:@"bpr"];
    [coder encodeInteger:_bitmapInfo forKey:@"i"];
    [coder encodeObject:(NSString *)CGColorSpaceGetName(_colorSpace) forKey:@"cs"];
}

@end

@interface _ObjcImageResult : NSObject <NSSecureCoding> {
    @package _ObjCImageFormat *_format;
    @package NSData *_data;
    @package CGImagePropertyOrientation _orientation;
}
@end

@implementation _ObjcImageResult

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _format = [[coder decodeObjectOfClass:objc_lookUpClass("_ObjCImageFormat") forKey:@"format"] retain];
        _data = [[coder decodeObjectOfClass:[NSData class] forKey:@"data"] retain];
        _orientation = static_cast<CGImagePropertyOrientation>([coder decodeIntegerForKey:@"orientation"]);
    }
    
    return self;
}

- (void)dealloc {
    [_format release];
    [_data release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_format forKey:@"format"];
    [coder encodeObject:_data forKey:@"data"];
    [coder encodeInteger:_orientation forKey:@"orientation"];
}

@end

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
    UIImage *image;
    
    if ([result isKindOfClass:objc_lookUpClass("GPImageAndFormat")]) {
        // iOS 18.4 beta 1
        
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
        [result encodeWithCoder:archiver];
        [archiver finishEncoding];
        NSData *data = archiver.encodedData;
        [archiver release];
        
        NSError * _Nullable error = nil;
        NSPropertyListFormat format;
        NSMutableDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&error];
        assert(format == NSPropertyListBinaryFormat_v1_0);
        assert(error == nil);
        
        /*
         Data 구조는 아래와 같다.
         
         GPImageAndFormat
         -> orientation : CGImagePropertyOrientation
         -> data : NSData
         -> format ImagePlayground.ImageFormat
         -> i : CGBitmapInfo
         -> ...
         
         이를 나는 아래처럼 변환하기 하기 위해
         
         _ObjcImageResult
         -> orientation : CGImagePropertyOrientation
         -> data : NSData
         -> format _ObjCImageFormat
         -> i : CGBitmapInfo
         -> ...
         
         NSKeyedArchiver, NSKeyedUnarchiver로 Encode-Decode를 해줘야 하는데
         1. 우선 _ObjcImageResult을 Encode
         2. 1에서 Encode한 Data를 `-[_ObjcImageResult initWithCoder:]`로 Decode
         3. 2에서 내부적으로 ImagePlayground.ImageFormat이 Decode 될 것
         4. 원래라면 `-[_ObjcImageResult initWithCoder:]`에서 ImagePlayground.ImageFormat를 Decode한 다음, 걔를 다시 Encode-Decode해서 _ObjcImageResult로 변환해야 한다. 하지만 ImagePlayground.ImageFormat이 1번에서 Encode 될 때 i를 NSNumber로 Encode하고, Decode 할 때 Int64로 하는 프레임워크 버그가 있어 type mismatch error 발생
         -> ImagePlayground.ImageFormat은 Decode가 불가능하다고 봐야함
         
         따라서 Data (Plist)의 값을 직접 바꿔서 ImagePlayground.ImageFormat의 Class 정의를 _ObjcImageResult로 바꿔줘야 한다.
         */
        NSMutableArray *objects = dictionary[@"$objects"];
        [objects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = static_cast<NSDictionary *>(obj);
                NSString *classname = dictionary[@"$classname"];
                if ([classname isEqual:@"ImagePlayground.ImageFormat"]) {
                    objects[idx] = @{
                        @"$classname": NSStringFromClass([_ObjCImageFormat class]),
                        @"$classes": @[
                            NSStringFromClass([_ObjCImageFormat class]),
                            NSStringFromClass([NSObject class])
                        ]
                    };
                    *stop = YES;
                }
            }
        }];
        dictionary[@"$objects"] = objects;
        
        NSData *patchedData = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
        [dictionary release];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:patchedData error:&error];
        assert(error == nil);
        
        _ObjcImageResult *decoded = [[_ObjcImageResult alloc] initWithCoder:unarchiver];
        CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)decoded->_data);
        
        CGImageRef cgImage = CGImageCreate(decoded->_format->_width,
                                           decoded->_format->_height,
                                           decoded->_format->_bitsPerComponent,
                                           decoded->_format->_bitsPerPixel,
                                           decoded->_format->_bytesPerRow,
                                           decoded->_format->_colorSpace,
                                           decoded->_format->_bitmapInfo,
                                           dataProvider,
                                           NULL,
                                           false,
                                           kCGRenderingIntentDefault);
        CGDataProviderRelease(dataProvider);
        [decoded release];
        
        //    CGImageRef cgImage = MyApp::getCGImageFromGPImageAndFormat(result);
        
        image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
    } else if ([result isKindOfClass:objc_lookUpClass("GPImageXPCWrapper")]) {
        // iOS 18.4 beta 2+
        CVPixelBufferRef pixelBuffer = reinterpret_cast<CVPixelBufferRef (*)(id, SEL)>(objc_msgSend)(result, sel_registerName("pixelBuffer"));
        CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer];
        image = [UIImage imageWithCIImage:ciImage];
        [ciImage release];
    } else {
        abort();
    }
    
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
