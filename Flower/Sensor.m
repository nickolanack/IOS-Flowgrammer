//
//  Sensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-09.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Sensor.h"

@interface Sensor()

@property bool recording;
@end
@implementation Sensor

-(void)configure{
    
    [super configure];
    [self setName:@"Sensor"];
    _recording=false;
    [self.layer setCornerRadius:5.0];
    //self.borderColor=[UIColor whiteColor];
    //[self.layer setBorderColor:self.borderColor.CGColor];
    
}


-(void)notifyOutputVariableConnectionStateDidChange:(VariableConnection *)vc{
    
    
    int count=0;
    
    for(int i=0;i<self.outputVariableConnections.count;i++){
        VariableConnection * vc=[self.outputVariableConnections objectAtIndex:i];
        if(vc.destination!=nil){
            count++;
        }
    }
    
    if(count==0&&_recording){
        [self stopRecording];
        _recording=false;
    }
    if(count>0&&(!_recording)){
        
        [self startRecording];
        _recording=true;
    }
    
    
}


-(void)startRecording{
     
}

-(void)stopRecording{
    
}


@end