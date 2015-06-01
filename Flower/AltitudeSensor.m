//
//  AltitudeSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "AltitudeSensor.h"

@interface AltitudeSensor()

@property CLLocationManager *locationManager;

@end

@implementation AltitudeSensor






-(void)configure{
    [super configure];
    [self setName:@"Altitude Sensor"];
    
    
    
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    
    [_locationManager startUpdatingLocation];
    //[_locationManager startUpdatingHeading];
    
    
    VariableConnection *alt=[[VariableConnection alloc] init];
    [alt setName:@"altitude"];
    [alt setCenterAlignOffsetSource:CGPointMake(0, -10)];
    [alt setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [alt connectNode:self toNode:nil];
    [alt setNamesVariable:true];
    
    [alt setVariableType:[NumberVariable class]];
    [alt setMidPointColor:[UIColor cyanColor]];
    
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
	 didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
    
    if(locations.count){
        
        
        CLLocation *l=[locations objectAtIndex:0];
        //l.coordinate.latitude
        VariableConnection *vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
        Variable *v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:l.altitude]];
        }
        
        vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:1];
        v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:l.verticalAccuracy]];
        }
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){
    
}
@end
