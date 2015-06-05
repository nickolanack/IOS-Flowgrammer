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
        
    
    VariableConnection *alt=[[VariableConnection alloc] init];
    [alt setName:@"altitude m"];
    [alt setCenterAlignOffsetSource:CGPointMake(0, -10)];
    [alt setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [alt connectNode:self toNode:nil];
    [alt setNamesVariable:true];
    
    [alt setVariableType:[NumberVariable class]];
    [alt setMidPointColor:[NumberVariable Color]];
    
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
	 didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
    
    if(locations.count){
        
        
        [self.icon setTintColor:[UIColor magentaColor]];
        
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.icon setTintColor:[UIColor whiteColor]];
        });
        
        
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


-(void)startRecording{
    
    if (_locationManager==nil){
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    [_locationManager setDelegate:self];
    
    
    //[_locationManager startUpdatingHeading];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

-(void)stopRecording{
    
    if (_locationManager!=nil){
        [_locationManager stopUpdatingLocation];
    }
    
}

@end
