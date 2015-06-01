//
//  FlowOptionsViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowOptionsViewController : UIViewController

@property (strong, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UISwitch *delayToggle;
@property (weak, nonatomic) IBOutlet UISlider *delaySlider;
- (IBAction)didToggleDelay:(id)sender;
- (IBAction)didAlterDelay:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sliderDelayLabel;
- (IBAction)onCloseClick:(id)sender;

@end
