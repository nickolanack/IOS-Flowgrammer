//
//  BackLoopConnection.m
//  Flower
//
//  Created by Nick Blackwell on 2/28/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LoopConnection.h"
#import "FunctionalBlock.h"
#import "LoopBlock.h"


@interface Connection()


@end

@implementation LoopConnection

@synthesize loopBlock;

-(id)init{


    self=[super init];
    if(self){
    
        //[self setDrawFrame:true];
    
        return self;
    }

    return nil;
}

-(void)configure{
    [super configure];
    [self setName:@"loop"];
    [self setConnectionPathColor:[UIColor magentaColor]];
    [self setCenterAlignOffsetDestination:CGPointMake(0, -10)];
    [self setCenterAlignOffsetSource:CGPointMake(0, -10)];
}

-(bool)isPartOfLoop{
    return true;
}

-(bool)isStartOfLoop{
    
    if(self.source==self.loopBlock)return true;
    return false;
    
}
-(bool)isMiddleOfLoop{
    return ([self isStartOfLoop]||[self isEndOfLoop])?false:true;
}

-(bool)isEndOfLoop{
    if(self.destination==self.loopBlock)return true;
    return false;
}
-(bool) isEmptyLoop{
    if(self.destination==self.source)return true;
    return false;
    
}


-(Connection *)getNextConnectionForSplit{

    LoopConnection *l=[[LoopConnection alloc] init];
    [l setLoopBlock:self.loopBlock];
    
    [l setCenterAlignOffsetDestination:self.centerAlignOffsetDestination];
    [l setCenterAlignOffsetSource:CGPointZero];
    [self setCenterAlignOffsetDestination:CGPointZero];
    
    return l;
    
}

-(bool)canInsertBlock:(FunctionalBlock *)block{
    if(block==self.loopBlock)return false;
    return [super canInsertBlock:block];
}


-(bool)connectNode:(FunctionalBlock *)nodeA toNode:(FunctionalBlock *)nodeB{
    
    
    if(nodeA==nodeB&&[nodeA isKindOfClass:[LoopBlock class]])[self setLoopBlock:(LoopBlock *)nodeA];
    
    
    if(nodeA!=self.loopBlock){
       [nodeA setPrimaryOutputConnection:self]; //this will already be set to the main flow
        [self setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    }else{
        [self.loopBlock setLoopout:self];
        [self setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeLeft];
    }
    
    
    if(nodeB!=self.loopBlock){
        [nodeB setPrimaryInputConnection:self]; //this will already be set to the main flow
        [self setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeLeft];
    }else{
        [self.loopBlock setLoopin:self];
        [self setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeRight];
    }
   
   
    
    [self setSource:nodeA];
    [self setDestination:nodeB];
    return true;
}

-(NSDictionary *)save{
    return nil;
}
@end
