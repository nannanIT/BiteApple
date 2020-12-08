//
//  BAVideoPlay.m
//  BiteApple
//
//  Created by jayhuan on 2020/12/4.
//

#import "BAVideoPlay.h"
#import <AVFoundation/AVFoundation.h>

@implementation BAVideoPlay

/**
 /// 播放视频动画
 - (void)p_playOpenVideo {
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"card_explore" ofType:@"mp4"];
     AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:filePath]];
     
     self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
     @weakify(self);
     self.playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                                     queue:dispatch_get_main_queue()
                                                                usingBlock:^(CMTime time) {
         @strongify(self);
         CGFloat currentTime = CMTimeGetSeconds(time); // 当前视频播放时长
         CGFloat totalTime = CMTimeGetSeconds(self.player.currentItem.duration); // 视频整体时长
         if (currentTime >= kQNNewsCardViewAnimTimeBeforeVideoFinish) {
             // 开播到1.5秒时，卡片淡入
             [self p_showCardView];
         }
         if (currentTime >= totalTime) {
             // 视频播放完毕
             [self p_didVideoFinishedPlay];
         }
     }];
     AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
     avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
     avLayer.frame = self.view.bounds;
     [self.view.layer addSublayer:avLayer];
     self.playerLayer = avLayer;
     
     [self.player play];
 }
 */

@end
