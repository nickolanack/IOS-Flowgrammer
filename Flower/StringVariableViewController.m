//
//  StringVariableViewController.m
//  Flower
//
//  Created by Nick Blackwell on 3/12/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "StringVariableViewController.h"
#import "StringVariable.h"

@interface StringVariableViewController ()

@end

@implementation StringVariableViewController

- (void)viewWillAppear:(BOOL)animated{
    if([self.block isKindOfClass:[StringVariable class]]){
        self.textarea.text=(NSString *)[(StringVariable *)self.block value];
    }
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    if([self.block isKindOfClass:[StringVariable class]]){
        [(StringVariable *)self.block setValue:self.textarea.text];
    }
    [super viewWillDisappear:animated];
}

@end
