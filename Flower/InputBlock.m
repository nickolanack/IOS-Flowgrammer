//
//  InputBlock.m
//  Flower
//
//  Created by Nick Blackwell on 3/13/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "InputBlock.h"
#import "VariableConnection.h"
#import "StringVariable.h"
@interface InputBlock()

@property NSCondition *lock;
@property bool unlocked;

@end
@implementation InputBlock



-(void)configure{
    
    [super configure];
    
    VariableConnection *label=[[VariableConnection alloc] init];
    [label setName:@"messageText"];
    [label setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
    [label setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [label connectNode:nil toNode:self];
    
    [label setVariableType:[StringVariable class]];
    [label setMidPointColor:[StringVariable Color]];
    
    VariableConnection *input=[[VariableConnection alloc] init];
    [input setName:@"input text"];
    [input setNamesVariable:true];
    [input setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
    [input setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeBottom];
    [input connectNode:self toNode:nil];
    
    [input setVariableType:[StringVariable class]];
    [input setMidPointColor:[StringVariable Color]];
    
    [self setName:@"Keyboard Input"];
    
}



-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FlowBlock *)block{
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    _unlocked=false;
    _lock=[NSCondition new];
    
    NSString *msg=@"Input Text";
    NSString *desc=@"";
    
    Variable *v0=(Variable *)((VariableConnection *)[self.inputVariableConnections objectAtIndex:0]).source;
    if(v0!=nil&&[v0 isKindOfClass:[StringVariable class]]){
        msg=[((StringVariable *)v0) value];
    }
    /*
    Variable *v1=(Variable *)((VariableConnection *)[self.inputVariableConnections objectAtIndex:1]).source;
    if(v1!=nil&&[v1 isKindOfClass:[StringVariable class]]){
        desc=[((StringVariable *)v1) value];
    }
    */
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:msg message:desc delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"submit", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
     
    
    [_lock lock];
    while (!_unlocked)[_lock wait];
    [_lock unlock];
    return output;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{

    NSString *text=[alertView textFieldAtIndex:0].text;
    Block *string=((VariableConnection *)[self.outputVariableConnections objectAtIndex:0]).destination;
    if([string isKindOfClass:[StringVariable class]]){
        [((StringVariable *)string) setValue:text];
    }
    
    [_lock lock];
    _unlocked=true;
    [_lock signal];
    [_lock unlock];

}

@end
