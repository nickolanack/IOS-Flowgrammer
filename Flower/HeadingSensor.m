//
//  HeadingSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-11.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "HeadingSensor.h"

@interface HeadingSensor()

@property CLLocationManager *locationManager;

@end

@implementation HeadingSensor






-(void)configure{
    [super configure];
    [self setName:@"Heading Sensor"];
    
    

    VariableConnection *hea=[[VariableConnection alloc] init];
    [hea setName:@"heading °"];
    [hea setCenterAlignOffsetSource:CGPointMake(0, -10)];
    [hea setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [hea connectNode:self toNode:nil];
    [hea setNamesVariable:true];
    
    [hea setVariableType:[NumberVariable class]];
    [hea setMidPointColor:[NumberVariable Color]];
    
    VariableConnection *acc=[[VariableConnection alloc] init];
    [acc setName:@"accuracy m"];
    [acc setCenterAlignOffsetSource:CGPointMake(0, 10)];
    [acc setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [acc connectNode:self toNode:nil];
    [acc setNamesVariable:true];
    
    [acc setVariableType:[NumberVariable class]];
    [acc setMidPointColor:[NumberVariable Color]];
    
}


- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){

    

        
    
        //l.coordinate.latitude
        VariableConnection *vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
        Variable *v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:newHeading.trueHeading]];
        }
        
        vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:1];
        v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:newHeading.headingAccuracy]];
        }

    
        [self.icon setTransform:CGAffineTransformMakeRotation(-(M_PI/180.0)*(newHeading.trueHeading-30))]; //-30 to account for the icon...
    
    
}


-(void)startRecording{
    
    if (_locationManager==nil){
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    [_locationManager setDelegate:self];
    
    
    //[_locationManager startUpdatingHeading];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingHeading];
    
    [self.icon setTintColor:[UIColor magentaColor]];
}

-(void)stopRecording{
    
    if (_locationManager!=nil){
        [_locationManager stopUpdatingHeading];
    }
    [self.icon setTintColor:[UIColor whiteColor]];

    
}

@end
