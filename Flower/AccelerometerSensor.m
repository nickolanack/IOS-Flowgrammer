//
//  AccelerometerSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-11.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "AccelerometerSensor.h"

@interface AccelerometerSensor()

@property CMMotionManager *motionManager;

@end
@implementation AccelerometerSensor

-(void)configure{
    [super configure];
    [self setName:@"Accelerometer Sensor"];
    
    _motionManager =[[CMMotionManager alloc] init];
    
    
    if(!_motionManager.accelerometerAvailable){
        
        [self setUserInteractionEnabled:false];
        
    }else{
    
    _motionManager.accelerometerUpdateInterval = .2;
    
    //create the output connections
        
    VariableConnection *x=[[VariableConnection alloc] init];
    [x setName:@"x"];
    [x setCenterAlignOffsetSource:CGPointMake(0, -15)];
    [x setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [x connectNode:self toNode:nil];
    [x setNamesVariable:true];
        
    [x setVariableType:[NumberVariable class]];
    [x setMidPointColor:[UIColor cyanColor]];
    
    VariableConnection *y=[[VariableConnection alloc] init];
    [y setName:@"y"];
    [y setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [y connectNode:self toNode:nil];
    [y setNamesVariable:true];
        
    [y setVariableType:[NumberVariable class]];
    [y setMidPointColor:[UIColor cyanColor]];
        
    VariableConnection *z=[[VariableConnection alloc] init];
    [z setName:@"z"];
    [z setCenterAlignOffsetSource:CGPointMake(0, 15)];
    [z setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [z connectNode:self toNode:nil];
    [z setNamesVariable:true];
        
    [z setVariableType:[NumberVariable class]];
    [z setMidPointColor:[UIColor cyanColor]];
        
    //start monitoring.
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        //send accelerometer values to outputs
        
        VariableConnection *vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
        Variable *v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:accelerometerData.acceleration.x]];
            
        }
        
        vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:1];
        v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:accelerometerData.acceleration.y]];
        }
        
        vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:2];
        v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:accelerometerData.acceleration.z]];
        }
    }];
        
    
    }
    
}

@end