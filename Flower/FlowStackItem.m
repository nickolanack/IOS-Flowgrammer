//
//  FlowStackItem.m
//  Flower
//
//  Created by Nick Blackwell on 3/13/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//


#import "FlowStackItem.h"
#import <QuartzCore/QuartzCore.h>

@interface FlowStackItem()

@property bool running;

@end
@implementation FlowStackItem

@synthesize flow;


-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
    
        
        [self.layer setCornerRadius:self.frame.size.width/2.0];
        //[self.layer setMasksToBounds:true];
        //[self setClipsToBounds:true];
        [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderWidth:1.0];
        [self.layer setBorderColor:[UIColor colorWithRed:0.0f green:33.0f/255.0f blue:99.0f/255.0f alpha:1.0].CGColor];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowRadius:2.0];
        [self.layer setShadowOpacity:0.2];
        [self.layer setShadowOffset:CGSizeZero];
        
        
        return self;
    }
    return nil;
}

-(void)setFlow:(Flow *)f{
    flow=f;
    _running=true;
    if(_running){
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            [self updateImage];
        });
    }
    
    

}

-(void) updateImage{
    UIImage *i=[flow captureView];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image.image=i;
        [self.image.layer setCornerRadius:self.layer.cornerRadius];
        [self.image.layer setMasksToBounds:true];
    });


    if(_running){
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            [self updateImage];
        });
    }

}

@end
