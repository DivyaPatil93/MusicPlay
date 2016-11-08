//
//  ViewController.m
//  DPMusicPlayer
//
//  Created by Student P_05 on 06/11/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isplaying = false;
    
    self.sliderDuration.userInteractionEnabled = NO;
    
    self.sliderDuration.minimumValue = 0;
    self.sliderDuration.maximumValue = 0;

    self.sliderDuration.value = 0;
    
    [self.sliderDuration setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDurationSlider) userInfo:nil repeats:YES];
    
}

-(void)updateDurationSlider {
    
    if (self.sliderDuration.value == myAudioplayer.duration) {
        timer = nil;
    }
    self.sliderDuration.value = myAudioplayer.currentTime;
}


-(BOOL)initialzeAudioPlayer{
    
    BOOL Status = false;
    
    NSURL *musicFileURl = [[NSBundle mainBundle]URLForResource:@"mySong" withExtension:@"mp3"];
    
    if(musicFileURl != nil){
        NSError *error;
        myAudioplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicFileURl error:&error];
        if (error !=  nil) {
            NSLog(@"Error:%@",error.localizedDescription);
            
            
        }
        else{
            
            
            self.sliderDuration.maximumValue = myAudioplayer
            .duration;
            Status = true;
        }
    }
    
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:musicFileURl options:nil];
    
    NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
    NSArray *artists = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon];
    NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyAlbumName keySpace:AVMetadataKeySpaceCommon];
    
    //        AVMetadataItem *title = [titles objectAtIndex:0];
    //        AVMetadataItem *artist = [artists objectAtIndex:0];
    //        AVMetadataItem *albumName = [albumNames objectAtIndex:0];
    //
    NSArray *metadata = [asset commonMetadata];
    
    NSString *titleOfSong;
    NSString *artistsOfSong;
    NSString *albumNamesOfSong;
    
    
    for (AVMetadataItem *item in metadata) {
        if ([[item commonKey] isEqualToString:@"title"]) {
            titleOfSong = (NSString *)[item value];
        }
        
        if ([[item commonKey] isEqualToString:@"artist"]) {
            artistsOfSong = (NSString *)[item value];
        }
        
        if ([[item commonKey] isEqualToString:@"albumName"]) {
            albumNamesOfSong = (NSString *)[item value];
        }
        
        // NSLog(@"title:%@",title);
        //    self.titleLabel.text = [NSString stringWithFormat:@"%@",title];
        //    self.artistLabel.text = [NSString stringWithFormat:@"%@",artist];
        //    self.albumNameLabel.text = [NSString stringWithFormat:@"%@",albumName];
        
        self.labelTitle.text =titleOfSong;
        self.labelArtist.text =artistsOfSong;
        self.labelAlbum.text =albumNamesOfSong;
        
    }
    NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                           withKey:AVMetadataCommonKeyArtwork
                                                          keySpace:AVMetadataKeySpaceCommon];
        
        for (AVMetadataItem *item in artworks) {
            if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                // NSDictionary *d = [item.value copyWithZone:nil];
                
                NSData *data = [item.value copyWithZone:nil];
                UIImage *image = [UIImage imageWithData:data];
                self.myimageView.image = image;
            } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                self.myimageView.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
            }
        }
    }];
    
    
    
    return Status;
    
}



- (IBAction)actionButton:(id)sender {
    
    UIButton *button = sender;
    
    if (button.tag == 101) {
        
        //if ([button.titleLabel.text isEqualToString:@"Play"]) {
        if (isplaying) {
            //[audioPlayer play];
            [myAudioplayer play];
            [self startTimer];
            
        }
        else {
            if([self initialzeAudioPlayer]) {
                [myAudioplayer play];

                [self startTimer];
                
                isplaying = true;
            }
            else {
                NSLog(@"Something went wrong while initializing audio player");
            }
        }
        
        [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        button.tag = 102;
    }
    else if (button.tag == 102) {
        //start playing and rename button title to pause
        [myAudioplayer pause];
        [timer invalidate];
        button.tag = 101;
        [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}




- (IBAction)actionStop:(id)sender {
    
    
   // [audioPlayer stop];
    [myAudioplayer stop];
    isplaying = false;
    self.sliderDuration.value = 0;
    [timer invalidate];
    timer = nil;
    self.buttonPlay.tag = 101;
    

}

@end
