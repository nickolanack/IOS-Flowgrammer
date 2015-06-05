//
//  Clock.m
//  Flower
//
//  Created by Nick Blackwell on 2015-06-05.
//  Copyright (c) 2015 Nick Blackwell. All rights reserved.
//

#import "Clock.h"

@interface Clock ()

@property bool state;
@property bool running;
@property bool initialState;


@end

@implementation Clock
-(void)configure{
    [super configure];
    [self setName:@"Clock"];
    _initialState=false;
}

-(void)addInputs{
    //no inputs.
}
-(void)addOutputs{
    
    VariableConnection *o=[[VariableConnection alloc] init];
    [o setName:@"out"];
    [o setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [o setCenterAlignOffsetSource:CGPointMake(-5, 0)];
    [o connectNode:self toNode:nil];
    
    [o setVariableType:[BooleanVariable class]];
    [o setMidPointColor:[BooleanVariable Color]];
    
}

-(CGPathRef)getPath{
    
  
    CGMutablePathRef p=CGPathCreateMutable();
    //[a setCenterAlignOffsetDestination:CGPointMake(3, -(self.frame.size.height/2)+self.inset+2)];
    CGRect f=self.frame;
    
    
    
    CGPathAddEllipseInRect(p, nil, CGRectMake(3, 3, f.size.width-6, f.size.height-6));
    return p;
}


-(bool)evaluate{
    return _state;

}
-(void)loop{
    
    [self propagate];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1000 * NSEC_PER_MSEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _state=!_state;
        [self loop];
    });
}

-(void)notifyOutputVariableConnectionStateDidChange:(VariableConnection *)vc{
    if(!_running){
        _state=_initialState;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self loop];
        });
        _running=true;
    }
}




@end
