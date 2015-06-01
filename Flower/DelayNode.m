//
//  DelayNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/27/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "DelayNode.h"

@interface DelayNode()


@property NSCondition *time;
@property bool expired;
@property float running_delay;

@end

@implementation DelayNode

@synthesize delay;

-(void)configure{
    [super configure];
    delay=5.0;
    _expired=true;
    [self setTimeLabel:delay];
    
    [self setName:@"Time Delay"];
}



-(int)indexInBundle{
    return 1;
}


-(void)execute:(JSContext *)context{
  
    _running_delay=delay;
    [self setTimeLabel:_running_delay];
    _expired=false;
    _time=[NSCondition new];
    
    double delayInSeconds = _running_delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelector:@selector(unlock) withObject:nil];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelector:@selector(updateCountdown:) withObject:[[NSDate alloc] init]];
    });
    
    
    
    
    
    [_time lock];
    while (!_expired)[_time wait];
    [_time unlock];

}

-(void)setDelay:(float)d{
    delay=d;
    if(_expired){
        [self setTimeLabel:delay];
    }


}

-(void)unlock{

    [_time lock];
    _expired=true;
    [_time signal];
    [_time unlock];

}
-(NSString *)getTimeString:(float)interval{
    
    int mins=((int)(interval/60))%60 ;
    int secs=((int) interval)%60;
    int dec=((int)round((interval-((int) interval))*10))%10;
    
    return [NSString stringWithFormat:@"%d:%02d.%d", mins, secs, dec];

}
-(void)setTimeLabel:(float)interval{

    NSString *time=[self getTimeString:interval];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.countdown setText:time];
    });
    
}
-(void)updateCountdown:(NSDate *)start{
   
    NSTimeInterval interval=_running_delay-[[[NSDate alloc] init] timeIntervalSinceDate:start];
    if(interval<0){
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(_expired){
                //check expired, just incase it is on a loop.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setTimeLabel:delay];
                });
            }
        });
    
        interval=0;
        
    }
    //int hours=interval/3600;
    //int days=hours/24;
    [self setTimeLabel:interval];
    
    if(_expired){
        return;
    }
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self updateCountdown:start];
    });
    
    

}

-(NSString *)getEditViewControllerName{
    return nil;
}

- (IBAction)onEditClick:(id)sender{
    
    [super onEditClick:sender];
    
}

@end
