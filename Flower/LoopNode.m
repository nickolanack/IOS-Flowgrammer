//
//  LoopNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/27/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LoopNode.h"
#import "LoopConnection.h"

@interface LoopNode()

@property bool shouldLoop;

@end

@implementation LoopNode

@synthesize loopin, loopout;

-(int)indexInBundle{
    return 2;
}

-(void)configure{
    [super configure];
    LoopConnection *loopCon=[[LoopConnection alloc] init];
    [self setLoopin:loopCon];
    [self setLoopout:loopCon];
    [loopCon setLoopNode:self];
    
    
    [self.loopin setNext:self];
    [self.loopout setPrevious:self];
    
    [self setName:@"Loop"];
}

-(void)setFlow:(Flow *)flow{
    [super setFlow:flow];
    
    [self.flow addConnection:self.loopin];
    [self.flow addConnection:self.loopout];
}

-(void)declarePositionChange{
    
    [super declarePositionChange];
    [self.loopin needsUpdate];
    if(self.loopin!=self.loopout)[self.loopout needsUpdate];
}

-(void)execute:(JSContext *)context{
    [super execute:context];
    _shouldLoop=true;

}
-(void)handleCloneLoopRequest{
    NSLog(@"Clone Loop");
}
-(NSArray *)getMenuItems{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItems]];
    if(self.loopout.next!=self)[array addObject:[[UIMenuItem alloc] initWithTitle: @"Clone Loop" action:@selector(handleCloneLoopRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(Node *)nextExecutionNode{

    if(_shouldLoop){
        return self.loopout.next;
        self.shouldLoop=false;
    }
    return [super nextNode];
}


-(NSArray *)connectedNodes{
    NSMutableArray *a=[[NSMutableArray alloc] init];
    Node *next=[self nextNode];
    if(next!=nil)[a addObject:next];
    
    Node *prev=[self previousNode];
    if(prev!=nil)[a addObject:prev];
    
   
    if(self.loopout.next!=nil&&self.loopout.next!=self)[a addObject:self.loopout.next];
    if(self.loopin.previous!=nil&&self.loopin.previous!=self.loopout.previous)[a addObject:self.loopout.previous];
    return [[NSArray alloc] initWithArray:a];
}

-(void)drawRect:(CGRect)rect{

    if(self.flow==nil){
        [self.superview insertSubview:self.loopout atIndex:0];
    }
    [super drawRect:rect];
}

@end
