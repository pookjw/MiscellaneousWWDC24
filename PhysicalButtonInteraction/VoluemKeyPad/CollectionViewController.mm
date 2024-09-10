//
//  CollectionViewController.mm
//  VoluemKeyPad
//
//  Created by Jinwoo Kim on 7/6/24.
//

#import "CollectionViewController.h"
#import "UIScrollView+VolumeControl.h"
#import <AVFoundation/AVFoundation.h>

@interface CollectionViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation CollectionViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [_captureSession release];
    [_previewLayer release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cellRegistration];
    
    [self.collectionView vc_setVerticalScrollWithVolumeButtonsEnabled:YES];
//    self.collectionView.allowsKeyboardScrolling = YES;
    
    UIBarButtonItem *startSessionBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(didTriggerStartSessionBarButtonItem:)];
    self.navigationItem.rightBarButtonItem = startSessionBarButtonItem;
    [startSessionBarButtonItem release];
}

- (void)didTriggerStartSessionBarButtonItem:(UIBarButtonItem *)sender {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    assert(error == nil);
    
    [session addInput:input];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    self.previewLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:self.previewLayer];
    
    [session startRunning];
    self.captureSession = session;
    [session release];
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        contentConfiguration.text = indexPath.description;
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1000;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

@end
