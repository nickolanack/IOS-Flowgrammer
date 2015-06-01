//
//  AudioBlock.m
//  Flower
//
//  Created by Nick Blackwell on 3/16/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "AudioBlock.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioBlock()

@property AVAudioPlayer *a;
@property NSCondition *lock;
@property bool unlocked;

@end

@implementation AudioBlock

@synthesize sound;
-(void)configure{
    
    [super configure];
    [self setName:@"Play Audio"];
    
    sound=@"Basso";
    
}

-(void)willEvaluate{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioImage setTintColor:[UIColor magentaColor]];
    });
}
-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:sound
                                                              ofType:@"aiff"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSError *e;

    if(_a!=nil){
        //cleanup last.
    }
    _a=[[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&e];
    [_a setDelegate:self];
    _a.numberOfLoops = 1; //Infinite
    _unlocked=false;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_a play];
    });
    
    [_lock lock];
    while (!_unlocked)[_lock wait];
    [_lock unlock];

    
    return output;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_lock lock];
    _unlocked=true;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioImage setTintColor:[UIColor lightGrayColor]];
    });
    [_lock signal];
    [_lock unlock];

}

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Set Audio Clip" action:@selector(displayDetailView)]];
    return [[NSArray alloc] initWithArray:array];
}

-(int)getDetailNibIndex{
    return 2;
}
-(bool)displaysDetailViewInPopover{
    return true;
}
-(NSString *)getDetailNibName{
    return @"nodeviews.viewcontrollers";
}
-(CGSize)detailViewPopoverSize{
    return CGSizeMake(220, 200);
}

@end
