//
//  AmbientLightSensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ProximitySensor.h"


@implementation ProximitySensor

-(void)configure{
    [super configure];
    [self setName:@"Proximity Sensor"];
    UIDevice *d=[UIDevice currentDevice];
    [d setProximityMonitoringEnabled:true];
    if(d.proximityMonitoringEnabled==false){
        [self setUserInteractionEnabled:false];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityChanged:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}
-(void)proximityChanged:(id)object{



}


@end
