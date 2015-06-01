//
//  DelayViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2/28/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NodeViewController.h"

@interface DelayViewController : NodeViewController
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *min;
@property (weak, nonatomic) IBOutlet UILabel *max;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISlider *slider;

- (IBAction)sliderChanged:(id)sender;
@end
