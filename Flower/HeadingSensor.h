//
//  HeadingSensor.h
//  Flower
//
//  Created by Nick Blackwell on 2014-04-11.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Sensor.h"
#import <CoreLocation/CoreLocation.h>

@interface HeadingSensor : Sensor<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *icon;

@end
