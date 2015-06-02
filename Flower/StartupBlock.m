//
//  StartupNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "StartupBlock.h"
#import "Connection.h"
#import "FlowView.h"
@interface StartupBlock()

@property NSCondition *lock;
@property bool confirmation;
@property NSString *textForButtonClicked;

@property bool unlocked;


@end
@implementation StartupBlock


-(void)configure{
    [super configure];
    [self setName:@"Start"];
    [[[Connection alloc] init] connectNode:self toNode:nil];
}

-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    
    [self message:@"starting!"];
    [self message:@"initializing environment"];
    [context evaluateScript:@"var output;"];
    
    context[@"console"] = ^(NSString * string) {
        NSLog(@"%@",string);
    };
    
    
    context[@"alert"] = ^(NSString * string) {
        UIAlertView *a=[[UIAlertView alloc] initWithTitle:@"Alert" message:string delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil];
        _unlocked=false;
        dispatch_async(dispatch_get_main_queue(), ^{
            [a show];
        });
        [_lock lock];
        while (!_unlocked)[_lock wait];
        [_lock unlock];
    };
    
    context[@"confirm"] = ^(NSString * string) {
        UIAlertView *a=[[UIAlertView alloc] initWithTitle:@"Confirm" message:string delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok",nil];
        _unlocked=false;
        dispatch_async(dispatch_get_main_queue(), ^{
            [a show];
        });
        
       
        [_lock lock];
        while (!_unlocked)[_lock wait];
        [_lock unlock];
        
        return ([_textForButtonClicked isEqualToString:@"ok"])?true:false;
    };
    
    
    
    [self message:@"running startup scripts"];
    return [super blockEvaluateContext:context withPreviousBlock:block];
    //[self message:@"finished"];

}



- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    _textForButtonClicked=[alertView buttonTitleAtIndex:buttonIndex];
    
    [_lock lock];
    _unlocked=true;
    [_lock signal];
    [_lock unlock];
    
}

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Run" action:@selector(handleRunRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(void)handleRunRequest{
    [self.flow run];
}





@end
