//
//  OutputBlock.m
//  Flower
//
//  Created by Nick Blackwell on 3/13/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "OutputBlock.h"
#import "VariableConnection.h"
#import "StringVariable.h"

@interface OutputBlock()

@property NSCondition *lock;
@property bool unlocked;

@end
@implementation OutputBlock



-(void)configure{
    
    [super configure];
    
    VariableConnection *title=[[VariableConnection alloc] init];
    [title setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
    [title setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [title setCenterAlignOffsetDestination:CGPointMake(-15, 0)];
    [title connectNode:nil toNode:self];
    
    [title setVariableType:[StringVariable class]];
    [title setMidPointColor:[UIColor blueColor]];
    
    VariableConnection *message=[[VariableConnection alloc] init];
    [message setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeTop];
    [message setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [message setCenterAlignOffsetDestination:CGPointMake(15, 0)];
    [message connectNode:nil toNode:self];
    
    [message setVariableType:[StringVariable class]];
    [message setMidPointColor:[UIColor blueColor]];
    
    [self setName:@"Print Message"];
    
}


-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    _unlocked=false;
    _lock=[NSCondition new];
    
    NSString *title=@"";
    NSString *message=@"oh, umm... nevermind";
    
    Block *t=((VariableConnection *)[self.inputVariableConnections objectAtIndex:0]).source;
    if(t!=nil&&[t isKindOfClass:[StringVariable class]]){
        title =(NSString *)[((StringVariable *)t) value];
    }
    
    Block *m=((VariableConnection *)[self.inputVariableConnections objectAtIndex:1]).source;
    if(m!=nil&&[m isKindOfClass:[StringVariable class]]){
        message =(NSString *)[((StringVariable *)m) value];
    }
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"close" otherButtonTitles: nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
    
    [_lock lock];
    while (!_unlocked)[_lock wait];
    [_lock unlock];
    return output;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [_lock lock];
    _unlocked=true;
    [_lock signal];
    [_lock unlock];
    
}

@end
