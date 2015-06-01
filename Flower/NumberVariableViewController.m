//
//  NumberVariableViewController.m
//  Flower
//
//  Created by Nick Blackwell on 3/18/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NumberVariableViewController.h"
#import "NumberVariable.h"

@interface NumberVariableViewController ()

@end

@implementation NumberVariableViewController

- (void)viewWillAppear:(BOOL)animated{
    if([self.block isKindOfClass:[NumberVariable class]]){
        self.textarea.text=[(NSNumber *)[(NumberVariable *)self.block value] stringValue];
    }
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    if([self.block isKindOfClass:[NumberVariable class]]){

        

        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
        [(NumberVariable *)self.block setValue:[f numberFromString:self.textarea.text]];
    }
    [super viewWillDisappear:animated];
}

@end
