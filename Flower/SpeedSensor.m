//
//  SpeedSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "SpeedSensor.h"


@interface SpeedSensor()

@property CLLocationManager *locationManager;

@end

@implementation SpeedSensor






-(void)configure{
    [super configure];
    [self setName:@"Speed Sensor"];
    
    
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    
    
    VariableConnection *spe=[[VariableConnection alloc] init];
    [spe setName:@"speed"];
    [spe setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [spe connectNode:self toNode:nil];
    [spe setNamesVariable:true];
    
    [spe setVariableType:[NumberVariable class]];
    [spe setMidPointColor:[UIColor cyanColor]];
}


- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
    
    if(locations.count){
        
        
        CLLocation *l=[locations objectAtIndex:0];
        //l.coordinate.latitude
        VariableConnection *vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
        Variable *v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:l.speed]];
        }
    }
}

@end
