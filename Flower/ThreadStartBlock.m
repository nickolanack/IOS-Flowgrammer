//
//  StartupNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/25/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ThreadStartBlock.h"
#import "ThreadEndBlock.h"
#import "Connection.h"
#import "FlowView.h"
@interface ThreadStartBlock()

@property NSCondition *lock;
@property bool confirmation;
@property NSString *textForButtonClicked;

@property bool running;
@property dispatch_queue_t queue;
@property JSContext *currentContext;
@property float delay;

@property bool unlocked;
@property  ThreadEndBlock *end;


@end
@implementation ThreadStartBlock


-(void)configure{
    [super configure];
    [self.layer setCornerRadius:self.frame.size.height/2.0];
    [self setName:@"Start"];
    [[[Connection alloc] init] connectNode:self toNode:nil];
    _delay=0.5;
}

-(bool)isSliceable{
    return false;
}
-(bool)isCloneable{
    return false;
}

-(void)deleteBlock{

    
    FunctionalBlock *current= [self getNextBlock];
    NSMutableArray *blocksToSlice=[[NSMutableArray alloc] init];
    while(current != _end){
        if(current==nil){
            //@throw iterated past end of flow. unclosed/inconsistent flow?
        }
        
        if(![current isSliceable]){
            //@throw all flow blocks should be sliceable!
        }
        
        [blocksToSlice addObject:current];
        current =[current getNextBlock];
    }
    
    
    for (FunctionalBlock *blockInFlow in blocksToSlice) {
        [blockInFlow slice];
    }
   
    [current deleteBlock];
    [super deleteBlock];
    

}

-(void)notifyOutputConnectionStateDidChange{
    if(_end==nil){
        [self checkAndSetThreadEndBlock];
    }
}

-(void)checkAndSetThreadEndBlock{
   
    FunctionalBlock *next=[self getNextBlock];
    if([next isKindOfClass:[ThreadEndBlock class]]){
        _end=(ThreadEndBlock *)next;
    }
    
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
    if(_running){
        return [super getMenuItemsArray];
    }
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Run" action:@selector(handleRunRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(void)handleRunRequest{
    [self run];
}




-(void)run{
    if(_running) return;
    _queue = dispatch_queue_create("Flow Execution Thread", 0);
    _running=true;
    
    JSContext *context = [[JSContext alloc] initWithVirtualMachine:[[JSVirtualMachine alloc] init]];
    _currentContext=context;
    [context setExceptionHandler:^(JSContext * context, JSValue *value) {
        
        NSLog(@"Exception Handler %s %@", __PRETTY_FUNCTION__, value);
        
    }];
    
    
    dispatch_async(_queue, ^{
        [self execute:self];
    });

}

-(void)execute:(FunctionalBlock *)block{
    [self execute:block withPreviousBlock:nil];
}
-(void)execute:(FunctionalBlock *)block withPreviousBlock:(FunctionalBlock *)prev{
    
    if(!_running)return;
    
    @try {
        
        [block willEvaluate]; //any setup.
        [block blockEvaluateContext:_currentContext withPreviousBlock:prev];
        [block didEvaluate]; //any cleanup.
        
        
        
        
        //chain execution.
        [block selectNextConnection:_delay-0.1];
        FunctionalBlock *next=[block nextExecutionBlock];
        if(next!=nil){
            
            double delayInSeconds = _delay;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            //dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(popTime, _queue, ^(void){
                [self execute:next withPreviousBlock:block];
            });
            //});
        }else{
            _running=false;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Caught Exception %s: %@",__PRETTY_FUNCTION__,exception);
    }
    @finally {
        
    }
}





@end
