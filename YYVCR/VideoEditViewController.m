//
//  VideoEditViewController.m
//  YYVCR
//
//  Created by Heisenbean on 2017/4/25.
//  Copyright © 2017年 Heisenbean. All rights reserved.
//

#import "VideoEditViewController.h"
#import "UIView+LayoutMethods.h"
@interface VideoEditViewController ()
@property (strong, nonatomic) SCAssetExportSession *exportSession;
@property (strong, nonatomic) SCPlayer *player;
@property (weak, nonatomic) IBOutlet UIImageView *corverImage;

@property (weak, nonatomic) IBOutlet SCVideoPlayerView *playerView;
@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [SCPlayer player];
    _playerView.player = _player;
    _playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _player.loopEnabled = YES;

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.playerView.width = self.view.width;
}




- (void)dealloc {
    [_player pause];
    _player = nil;
    [self cancelSaveToCameraRoll];
}


- (void)cancelSaveToCameraRoll{
    [_exportSession cancelExport];
}


- (IBAction)thumbImage:(id)sender {
   UIImage *cover = [self thumbnailImageForVideo:self.recordSession.outputUrl atTime:0.1];
    self.corverImage.image = cover;
}

-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    NSURL *url = [NSURL URLWithString:videoURL.path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_player setItemByAsset:_recordSession.assetRepresentingSegments];
    [_player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player pause];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
