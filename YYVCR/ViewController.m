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
#import "VideoEditViewController.h"
@interface ViewController () <SCRecorderDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (strong,nonatomic) SCRecorder *recorder;
@property (strong,nonatomic) SCRecordSession *recordSession;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *timeRecordedLabel;
@property (weak, nonatomic) IBOutlet UIView *bigProgressView;
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

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.recorder previewViewFrameChanged];
}


- (void)updateTimeRecordedLabel {
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    
    self.timeRecordedLabel.text = [NSString stringWithFormat:@"%.2f sec", CMTimeGetSeconds(currentTime)];
    
    CGFloat multi = CMTimeGetSeconds(currentTime)   / 30;

//    NSLog(@"%f--%f",CMTimeGetSeconds(currentTime),multi);
    if (multi > 0 && multi <= 1.0) {

    }
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
        
        [self addProgressView];
        self.deleteButton.hidden = NO;
        self.nextButton.hidden = NO;
    }else if(sender.state == UIGestureRecognizerStateEnded){
        [self.recorder pause];
        NSLog(@"%f",CMTimeGetSeconds(self.recorder.session.currentSegmentDuration));
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
    }
}

- (void)changeProgressWidth:(SCRecordSession *)session{
    CGFloat maxRecorderTime = 10;
    CGFloat recorderTime = CMTimeGetSeconds(session.currentSegmentDuration);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *lastView = self.bigProgressView.subviews.lastObject;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.0 animations:^{
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
- (IBAction)deleteOneProgress:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIView *lastView = self.bigProgressView.subviews.lastObject;
    lastView.backgroundColor = [UIColor redColor];
    self.isDelete = YES;
    if (self.isDelete && !sender.selected) {
        [lastView removeFromSuperview];
        [self.recordSession removeLastSegment];
        self.isDelete = NO;
    }
    self.deleteButton.hidden = !(BOOL)self.bigProgressView.subviews.count;
    self.nextButton.hidden = !(BOOL)self.bigProgressView.subviews.count;
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    if (CMTimeGetSeconds(recordSession.duration) == 10) {
        [recorder pause];
//        // jump to next page
    }

    [self changeProgressWidth:recordSession];
    [self updateTimeRecordedLabel];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[VideoEditViewController class]]) {
        VideoEditViewController *videoPlayer = segue.destinationViewController;
        videoPlayer.recordSession = _recordSession;
    }
}
@end
