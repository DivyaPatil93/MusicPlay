//
//  ViewController.h
//  DPMusicPlayer
//
//  Created by Student P_05 on 06/11/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController
{
    AVAudioPlayer *myAudioplayer;
    BOOL isplaying;
    MPMediaLibrary *nowPlaying;
    NSTimer *timer;
    
}

@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
- (IBAction)actionButton:(id)sender;
- (IBAction)actionStop:(id)sender;

@property (strong, nonatomic) IBOutlet UISlider *sliderDuration;

@property (strong, nonatomic) IBOutlet UIImageView *myimageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelArtist;
@property (weak, nonatomic) IBOutlet UILabel *labelAlbum;

@end

