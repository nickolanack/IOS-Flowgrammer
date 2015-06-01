//
//  LocationSensor.h
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Sensor.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationSensor : Sensor<CLLocationManagerDelegate>

@end
