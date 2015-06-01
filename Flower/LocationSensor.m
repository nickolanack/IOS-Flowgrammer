//
//  LocationSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LocationSensor.h"



@interface LocationSensor()

@property CLLocationManager *locationManager;


@end

@implementation LocationSensor



-(void)configure{
    [super configure];
    [self setName:@"Location Sensor"];
 


    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    
    [_locationManager startUpdatingLocation];
    //[_locationManager startUpdatingHeading];
    

    
    VariableConnection *lat=[[VariableConnection alloc] init];
    [lat setName:@"latitude"];
    [lat setCenterAlignOffsetSource:CGPointMake(0, -15)];
    [lat setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [lat connectNode:self toNode:nil];
    [lat setNamesVariable:true];
    
    [lat setVariableType:[NumberVariable class]];
    [lat setMidPointColor:[UIColor cyanColor]];
    
    
    VariableConnection *lon=[[VariableConnection alloc] init];
    [lon setName:@"longitude"];
    [lon setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [lon connectNode:self toNode:nil];
    [lon setNamesVariable:true];
    
    [lon setVariableType:[NumberVariable class]];
    [lon setMidPointColor:[UIColor cyanColor]];
    
    VariableConnection *alt=[[VariableConnection alloc] init];
    [alt setName:@"accuracy"];
    [alt setCenterAlignOffsetSource:CGPointMake(0, 15)];
    [alt setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [alt connectNode:self toNode:nil];
    [alt setNamesVariable:true];
    
    [alt setVariableType:[NumberVariable class]];
    [alt setMidPointColor:[UIColor cyanColor]];
    

}


- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
    
    if(locations.count){
        
        
        CLLocation *l=[locations objectAtIndex:0];
        //l.coordinate.latitude
        VariableConnection *vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
        Variable *v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:l.coordinate.latitude]];
        }
        
        vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:1];
        v=(Variable *)vc.destination;
        if(v!=nil){
            [v setValue:[NSNumber numberWithFloat:l.coordinate.longitude]];
        }
        
        vc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:2];
        v=(Variable *)vc.destination;
        if(v!=nil){
             [v setValue:[NSNumber numberWithFloat:l.horizontalAccuracy]];
           
        }
        
        
        
        
    }

}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0){

}

@end
