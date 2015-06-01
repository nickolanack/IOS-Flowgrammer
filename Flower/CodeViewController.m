//
//  CodeViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "CodeViewController.h"

@interface CodeViewController ()

@end

@implementation CodeViewController



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
    if(self.node!=nil)[self.editor setText:self.node.code];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onCloseClick:(id)sender {
    
    if(self.node !=nil){
        [self.node setCode:self.editor.text];
    }
    
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}
@end
