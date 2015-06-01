//
//  MicrophoneLevelSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-13.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "MicrophoneLevelSensor.h"
@interface MicrophoneLevelSensor()
@property AVAudioRecorder *audioRecorder;

@end
@implementation MicrophoneLevelSensor

-(void)configure{
    [super configure];
    [self setName:@"Microphone Level Sensor"];
    
   
    NSError *error;
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 0],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    [_audioRecorder setMeteringEnabled:true];
    
    VariableConnection *peak=[[VariableConnection alloc] init];
    [peak setName:@"peak"];
    [peak setCenterAlignOffsetSource:CGPointMake(0, -10)];
    [peak setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [peak connectNode:self toNode:nil];
    [peak setNamesVariable:true];
    
    [peak setVariableType:[NumberVariable class]];
    [peak setMidPointColor:[UIColor cyanColor]];
    
    
    VariableConnection *avg=[[VariableConnection alloc] init];
    [avg setName:@"average"];
    [avg setCenterAlignOffsetSource:CGPointMake(0, 10)];
    [avg setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [avg connectNode:self toNode:nil];
    [avg setNamesVariable:true];
    
    [avg setVariableType:[NumberVariable class]];
    [avg setMidPointColor:[UIColor cyanColor]];
    
    
    
    
    [_audioRecorder record];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self loop];
    });
    
    
}

-(void)loop{
    
    [_audioRecorder updateMeters];
    float peak=[_audioRecorder peakPowerForChannel:0];
    float avg= [_audioRecorder averagePowerForChannel:0];
    
    VariableConnection *vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
    Variable *v=(Variable *)vc.destination;
    if(v!=nil){
        [v setValue:[NSNumber numberWithFloat:peak]];
    }
    
    vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:1];
    v=(Variable *)vc.destination;
    if(v!=nil){
        [v setValue:[NSNumber numberWithFloat:avg]];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self loop];
    });
    
}

@end
