
//
//  CodeViewController.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "CodeViewController.h"
#import "FlowBlock.h"

@interface CodeViewController ()

@end

@implementation CodeViewController


-(void)viewWillAppear:(BOOL)animated{
    if(self.block!=nil&&[self.block isKindOfClass:[FlowBlock class]])[self.editor setText:((FlowBlock *)self.block).javascript];
    [self.editor becomeFirstResponder];
    [super viewWillAppear:animated];
    
    //[self.editor.layer setBorderWidth:1.0];
    //[self.editor.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.editor.layer setCornerRadius:3.0];
    
    if(self.block){
        if(((VariableConnection *)[((FlowBlock *)self.block).outputVariableConnections objectAtIndex:0]).destination!=nil){
            
        }else{
            self.outputConnectionLabel.text=[NSString stringWithFormat:@"//%@ //no output connection",self.outputConnectionLabel.text];
            [self.outputConnectionLabel setTextColor:[UIColor lightGrayColor]];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{

    if(self.block!=nil&&[self.block isKindOfClass:[FlowBlock class]]){
        [((FlowBlock *)self.block) setJavascript:self.editor.text];
    }
    [super viewWillDisappear:animated];

    
}


@end
