//
//  Sensor.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-09.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Sensor.h"

@implementation Sensor

-(void)configure{
    
    [super configure];
    [self setName:@"Sensor"];
    [self.layer setCornerRadius:5.0];
    //self.borderColor=[UIColor whiteColor];
    //[self.layer setBorderColor:self.borderColor.CGColor];
    
}

@end
