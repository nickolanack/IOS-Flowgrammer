//
//  DelayViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2/28/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "DelayViewController.h"
#import "DelayNode.h"

@interface DelayViewController ()

@end

@implementation DelayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [self.slider setValue:((DelayNode *)self.node).delay];
    self.value.text=[((DelayNode *)self.node) getTimeString:self.slider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{

    [((DelayNode *)self.node) setDelay:self.slider.value];
    
}
- (IBAction)sliderChanged:(id)sender {
    NSString *time=[((DelayNode *)self.node) getTimeString:self.slider.value];
    self.value.text=time;
    [((DelayNode *)self.node) setDelay:self.slider.value];
}
@end
