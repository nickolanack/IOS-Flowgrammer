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

@property float min;
@property float max;



@end
@implementation MicrophoneLevelSensor

-(void)configure{
    [super configure];
    [self setName:@"Microphone Level Sensor"];
    
    VariableConnection * peak=[[VariableConnection alloc] init];
    [peak setName:@"peak db"];
    [peak setCenterAlignOffsetSource:CGPointMake(0, -10)];
    [peak setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [peak connectNode:self toNode:nil];
    [peak setNamesVariable:true];
    
    [peak setVariableType:[NumberVariable class]];
    [peak setMidPointColor:[UIColor cyanColor]];
    
    
    VariableConnection *avg=[[VariableConnection alloc] init];
    [avg setName:@"average db"];
    [avg setCenterAlignOffsetSource:CGPointMake(0, 10)];
    [avg setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [avg connectNode:self toNode:nil];
    [avg setNamesVariable:true];
    
    [avg setVariableType:[NumberVariable class]];
    [avg setMidPointColor:[UIColor cyanColor]];
    
}

-(void)loop{
    
    if([_audioRecorder isRecording]){
        [_audioRecorder updateMeters];
        float peak=[_audioRecorder peakPowerForChannel:0];
        float avg= [_audioRecorder averagePowerForChannel:0];
    
        //mask the icons to look like a level sensor.
        CGRect f=self.iconMeter.layer.frame;
        
        float minh=5;
        float height=(f.size.height-minh);
        
        float hp=0;
        float ha=0;
        _min=MIN(peak, MIN(avg, _min));
        _max=MAX(peak, MAX(avg, _max));
        
        float span=_max-_min;
        if(span>0){
            hp=height*((peak-_min)/span)+minh;
            ha=height*((avg-_min)/span)+minh;
        }
        
    
        
        CAShapeLayer *maskPLayer = [[CAShapeLayer alloc] init];
        CGRect maskPRect = CGRectMake(0, (f.size.height-hp), f.size.width, hp);
        CGPathRef pathP = CGPathCreateWithRect(maskPRect, NULL);
        maskPLayer.path = pathP;
        CGPathRelease(pathP); //not covered by arc
        
        CAShapeLayer *maskALayer = [[CAShapeLayer alloc] init];
        CGRect maskARect = CGRectMake(0, (f.size.height-ha), f.size.width, ha);
        CGPathRef pathA = CGPathCreateWithRect(maskARect, NULL);
        maskALayer.path = pathA;
        CGPathRelease(pathA); //not covered by arc
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            self.iconMeter.layer.mask = maskPLayer;
            [self.iconMeter.layer setMasksToBounds:true];
            
            self.icon.layer.mask = maskALayer;
            [self.icon.layer setMasksToBounds:true];
        });
        
        
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self loop];
        });
    }
    
}


-(void)startRecording{
    
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
    
    
    
    
    
    //[self.icon setTintColor:[UIColor purpleColor]];
    [self.iconMeter setTintColor:[UIColor yellowColor]];
    [self.iconMeter setAlpha: 1];
    
    [self.icon setTintColor:[UIColor greenColor]];
    [self.icon setAlpha:1];
    
    [_audioRecorder record];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self loop];
    });
    
}

-(void)stopRecording{

    [_audioRecorder stop];
}






@end
