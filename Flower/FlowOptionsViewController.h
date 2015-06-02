//
//  FlowOptionsViewController.h
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowView.h"

@interface FlowOptionsViewController : UIViewController

@property (strong, nonatomic) FlowView *flow;
@property (weak, nonatomic) IBOutlet UISwitch *delayToggle;
@property (weak, nonatomic) IBOutlet UISlider *delaySlider;
- (IBAction)didToggleDelay:(id)sender;
- (IBAction)didAlterDelay:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sliderDelayLabel;
- (IBAction)onCloseClick:(id)sender;
- (IBAction)didToggleCtrlPoints:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *ctrlPointToggle;
- (IBAction)didToggleFrames:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *framesToggle;
@property (weak, nonatomic) IBOutlet UISwitch *autoSaveToggle;
- (IBAction)didToggleAutoSave:(id)sender;

@end
