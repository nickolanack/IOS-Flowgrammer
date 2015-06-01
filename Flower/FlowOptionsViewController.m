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
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didToggleDelay:(id)sender {
    
    if(self.delayToggle.isOn){
        [self.delaySlider setEnabled:true];
        if([self.delegate respondsToSelector:@selector(setNSNumberDelay:)]){
            [self.delegate performSelector:@selector(setNSNumberDelay:) withObject:[NSNumber numberWithFloat:self.delaySlider.value]];
        }
    }else{
        [self.delaySlider setEnabled:false];
        if([self.delegate respondsToSelector:@selector(setNSNumberDelay:)]){
            [self.delegate performSelector:@selector(setNSNumberDelay:) withObject:[NSNumber numberWithFloat:0.0]];
        }
    }
    
    
    
}

- (IBAction)didAlterDelay:(id)sender {
    if([self.delegate respondsToSelector:@selector(setNSNumberDelay:)]){
        [self.delegate performSelector:@selector(setNSNumberDelay:) withObject:[NSNumber numberWithFloat:self.delaySlider.value]];
    }
    [self.sliderDelayLabel setText:[NSString stringWithFormat:@"%.1f",self.delaySlider.value]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self didToggleDelay:nil];
}

- (IBAction)onCloseClick:(id)sender {
 
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}
@end
