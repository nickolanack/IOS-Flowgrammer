//
//  FlowNameViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2014-03-27.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowNameViewController.h"

@interface FlowNameViewController ()

@end

@implementation FlowNameViewController

@synthesize flow;

-(void)viewWillAppear:(BOOL)animated{

    self.titleField.text=self.flow.name;
    self.descriptionField.text=self.flow.description;
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [self.flow setName:self.titleField.text];
    [self.flow setDescription:self.descriptionField.text];

}

@end
