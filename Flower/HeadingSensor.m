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
    
    
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingHeading];
    
    
    VariableConnection *hea=[[VariableConnection alloc] init];
    [hea setName:@"heading"];
    [hea setCenterAlignOffsetSource:CGPointMake(0, -10)];
    [hea setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [hea connectNode:self toNode:nil];
    [hea setNamesVariable:true];
    
    [hea setVariableType:[NumberVariable class]];
    [hea setMidPointColor:[UIColor cyanColor]];
    
    VariableConnection *acc=[[VariableConnection alloc] init];
    [acc setName:@"accuracy"];
    [acc setCenterAlignOffsetSource:CGPointMake(0, 10)];
    [acc setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [acc connectNode:self toNode:nil];
    [acc setNamesVariable:true];
    
    [acc setVariableType:[NumberVariable class]];
    [acc setMidPointColor:[UIColor cyanColor]];
    
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

    
}

@end
