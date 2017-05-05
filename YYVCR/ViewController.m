//
//  ViewController.m
//  视频demo
//
//  Created by Heisenbean on 2017/4/24.
//  Copyright © 2017年 Heisenbean. All rights reserved.
//

#import "ViewController.h"
#import "SCRecorder.h"
#import "UIView+LayoutMethods.h"
#import "UIImage+Utils.h"
#import "VideoEditViewController.h"
#define kMaxRecorderLength 15
#define kMinRecorderLength 3
@interface ViewController () <SCRecorderDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (strong,nonatomic) SCRecorder *recorder;
@property (strong,nonatomic) SCRecordSession *recordSession;
@property (weak, nonatomic) IBOutlet UIButton *minTimeTip;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *timeRecordedLabel;
@property (weak, nonatomic) IBOutlet UIView *bigProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *middleImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UIView *albumButton;
@property (nonatomic,assign) BOOL isDelete;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Create the recorder
    SCRecorder *recorder = [SCRecorder recorder]; // You can also use +[SCRecorder sharedRecorder]
    
    // Start running the flow of buffers
    if (![recorder startRunning]) {
        NSLog(@"Something wrong there: %@", recorder.error);
    }
    UIBarButtonItem *flashes = [[UIBarButtonItem alloc]initWithTitle:@"⚡️" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedFlashedButton)];
    UIBarButtonItem *reverseCamera = [[UIBarButtonItem alloc]initWithTitle:@"📷" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedReverseButton)];
    self.navigationItem.rightBarButtonItems = @[flashes,reverseCamera];
    // Create a new session and set it to the recorder
    recorder.session = [SCRecordSession recordSession];
//    recorder.maxRecordDuration = CMTimeMake(10, 2);
    recorder.delegate = self;
    
    recorder.previewView = self.previewView;
    
    
    self.recordSession = [SCRecordSession recordSession];
    self.recordSession.fileType = AVFileTypeQuickTimeMovie;
    
    recorder.session = self.recordSession;
    self.recorder = recorder;
    
    [self updateTimeRecordedLabel];

    UIImage *placeholderImage = [UIImage placeholderImageWithSize:self.topImage.size];
    _topImage.image = placeholderImage;
    _middleImage.image = placeholderImage;
    _bottomImage.image = placeholderImage;
    [UIImage getThumbInailFromAssetsLibrary:^(NSArray<UIImage *> *images) {
        self.topImage.image = images.firstObject;
        if (images.count>2) {
            self.bottomImage.image = images[1];
            self.middleImage.image = images[2];
        }
    }];

}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.recorder previewViewFrameChanged];
}

- (void)didClickedFlashedButton{
    NSString *flashModeString = nil;
    if ([_recorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"Flash : Light";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Auto";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    
}

- (void)didClickedReverseButton{
    [self.recorder switchCaptureDevices];
}

- (void)updateTimeRecordedLabel {
    CMTime currentTime = kCMTimeZero;
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    self.timeRecordedLabel.text = [NSString stringWithFormat:@"%.2f sec", CMTimeGetSeconds(currentTime)];
}

- (UIView *)returnProgressView{
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"ProgressLine" owner:nil options:nil].lastObject;
    view.frame  = CGRectMake(0, 0, 0, 2);
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recorder:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.recorder record];
        self.deleteButton.selected = NO;
        self.bigProgressView.subviews.lastObject.backgroundColor = [UIColor colorWithRed:0.95 green:0.61 blue:0.53 alpha:1.00];
        [UIView animateWithDuration:0.25 animations:^{
            self.minTimeTip.alpha = 0.0;
        }];

        [self addProgressView];
        [self showDeleteButtonAndNextButton:NO];

    }else if(sender.state == UIGestureRecognizerStateEnded){
        [self.recorder pause];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
    }
}

- (void)changeProgressWidth:(SCRecordSession *)session{
    CGFloat maxRecorderTime = kMaxRecorderLength;
    CGFloat recorderTime = CMTimeGetSeconds(session.currentSegmentDuration);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *lastView = self.bigProgressView.subviews.lastObject;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        lastView.width = (screenWidth / maxRecorderTime) * recorderTime;
        [self.view layoutIfNeeded];
    }];
}

- (void)addProgressView{
    CGFloat x = 0;
    UIView *view = [self returnProgressView];
    if (self.bigProgressView.subviews.count != 0) {
        x = CGRectGetMaxX(self.bigProgressView.subviews.lastObject.frame);
    }
    
    view.frame = CGRectMake(x, 0, 0, 3);
    [self.bigProgressView addSubview:view];
    
}

- (void)showDeleteButtonAndNextButton:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.25 animations:^{
            self.nextButton.alpha = 0.0;
            self.deleteButton.alpha = 0.0;
            self.albumButton.alpha = 1.0;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.nextButton.alpha = 1.0;
            self.deleteButton.alpha = 1.0;
            self.albumButton.alpha = 0.0;
        }];
        
    }
}

- (IBAction)deleteOneProgress:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIView *lastView = self.bigProgressView.subviews.lastObject;
    lastView.backgroundColor = [UIColor redColor];
    [UIView animateWithDuration:0.25 animations:^{
        self.minTimeTip.alpha = 0.0;
    }];

    self.isDelete = YES;
    if (self.isDelete && !sender.selected) {
        [lastView removeFromSuperview];
        [self.recordSession removeLastSegment];
        self.isDelete = NO;
    }
    [self showDeleteButtonAndNextButton:!(BOOL)self.bigProgressView.subviews.count];
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    if (CMTimeGetSeconds(recordSession.duration) == kMaxRecorderLength) {
        [recorder pause];
        [self next:self.nextButton];
    }

    [self updateTimeRecordedLabel];
    [self changeProgressWidth:recordSession];
}

- (IBAction)next:(UIButton *)sender {
    if (CMTimeGetSeconds(_recordSession.duration) < kMinRecorderLength) {
        [UIView animateWithDuration:0.25 animations:^{
            self.minTimeTip.alpha = 1.0;
        }];

    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"VideoEdit" bundle:nil];
        VideoEditViewController *videoPlayer = [sb instantiateInitialViewController];
        videoPlayer.recordSession = _recordSession;
        [self.navigationController pushViewController:videoPlayer animated:YES];
    }
    
}
@end
