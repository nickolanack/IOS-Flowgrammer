//
//  MicrophoneLevelSensor.h
//  Flower
//
//  Created by Nick Blackwell on 2014-04-13.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Sensor.h"
#import <AVFoundation/AVFoundation.h>

@interface MicrophoneLevelSensor : Sensor
@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIButton *iconMeter;
@end
