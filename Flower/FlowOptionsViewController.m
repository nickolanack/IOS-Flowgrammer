//
//  FlowOptionsViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowOptionsViewController.h"

@interface FlowOptionsViewController ()

@end

@implementation FlowOptionsViewController
@synthesize flow;



- (IBAction)didToggleDelay:(id)sender {
    
    if(self.delayToggle.isOn){
        [self.delaySlider setEnabled:true];
        [self.flow setDelay:self.delaySlider.value];
    }else{
        [self.delaySlider setEnabled:false];
        [self.flow setDelay:0.0];
    }
}

- (IBAction)didAlterDelay:(id)sender {
    if([self.flow respondsToSelector:@selector(setNSNumberDelay:)]){
        [self.flow performSelector:@selector(setNSNumberDelay:) withObject:[NSNumber numberWithFloat:self.delaySlider.value]];
    }
    [self.sliderDelayLabel setText:[NSString stringWithFormat:@"%.1f",self.delaySlider.value]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self didToggleDelay:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(self.flow.delay==0.0){
        [self.delayToggle setOn:false];
        [self.delaySlider setValue:self.delaySlider.minimumValue];
    }else{
        [self.delaySlider setValue:self.flow.delay];
    }
    
    [self.ctrlPointToggle setOn:self.flow.drawCtrlPoints];
    [self.framesToggle setOn:self.flow.drawFrames];
    [self.autoSaveToggle setOn:self.flow.autoSave];
    
    [self didAlterDelay:nil];
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
    }];
}

- (IBAction)didToggleCtrlPoints:(id)sender {
    [self.flow setDrawCtrlPoints:self.ctrlPointToggle.isOn];
}
- (IBAction)didToggleFrames:(id)sender {
    [self.flow setDrawFrames:self.framesToggle.isOn];
}


- (IBAction)didToggleAutoSave:(id)sender {
    [self.flow setAutoSave:self.autoSaveToggle.isOn];
}
@end
