//
//  ComparisonConnection.m
//  Flower
//
//  Created by Nick Blackwell on 3/8/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ComparisonConnection.h"
#import "ComparisonBlock.h"

@implementation ComparisonConnection


@synthesize comparisonBlock, isPrimaryLoop;


-(void)configure{
    [super configure];
    [self setName:@"comparison loop"];
    [self setConnectionPathColor:[UIColor magentaColor]];
    [self setCenterAlignOffsetDestination:CGPointMake(0, +10)];
    [self setCenterAlignOffsetSource:CGPointMake(0, +10)];
    
    
    //self.connectionAnchorTypeSource=ConnectionEndPointAnchorTypeLeft;
    //self.connectionAnchorTypeDestination=ConnectionEndPointAnchorTypeRight;
}

-(bool)isPartOfLoop{
    return true;
}

- (void)setIsPrimaryLoop:(bool)is{
    
    if(is){
        [self setCenterAlignOffsetDestination:CGPointMake(self.centerAlignOffsetDestination.x, self.centerAlignOffsetDestination.y*-1)];
        [self setCenterAlignOffsetSource:CGPointMake(self.centerAlignOffsetSource.x, self.centerAlignOffsetSource.y*-1)];
        [self setName:@"primary comparison loop"];
    }else{
        [self setName:@"secondary comparison loop"];
    }
    isPrimaryLoop=is;
}
-(CGPoint)emptyLoopBubbleDirection{
    if(isPrimaryLoop)return [super emptyLoopBubbleDirection];
    return CGPointMake(-1, +1);
}
-(bool)isStartOfLoop{
    
    if(self.source==self.comparisonBlock)return true;
    return false;
    
}
-(bool)isMiddleOfLoop{
    return ([self isStartOfLoop]||[self isEndOfLoop])?false:true;
}

-(bool)isEndOfLoop{
    if(self.destination==self.comparisonBlock)return true;
    return false;
}
-(bool) isEmptyLoop{
    if(self.destination==self.source)return true;
    return false;
    
}

-(Connection *)createConnectionForInsertingBlock{
    
    ComparisonConnection *l=[[ComparisonConnection alloc] init];
    [l setIsPrimaryLoop:self.isPrimaryLoop];
    [l setComparisonBlock:self.comparisonBlock];
    
    [l setCenterAlignOffsetDestination:self.centerAlignOffsetDestination];
    [l setCenterAlignOffsetSource:CGPointZero];
    [self setCenterAlignOffsetDestination:CGPointZero];
    
    return l;
    
}

-(bool)connectNode:(FlowBlock *)nodeA toNode:(FlowBlock *)nodeB{
    
    
    
    
    if(nodeA==nodeB&&[nodeA isKindOfClass:[ComparisonBlock class]]){
        [self setComparisonBlock:(ComparisonBlock *)nodeA];
    }
    
    
    if(nodeA!=self.comparisonBlock){
        [nodeA setPrimaryOutputConnection:self];
    }else{
        if(self.isPrimaryLoop){
            [self.comparisonBlock setPrimaryLoopOutputConnection:self];
        }else{
            [self.comparisonBlock setSecondaryLoopOutputConnection:self];
        }
        
        
    }
    
    
    if(nodeB!=self.comparisonBlock){
        [nodeB setPrimaryInputConnection:self];
   
    }else{
        if(self.isPrimaryLoop){
            [self.comparisonBlock setPrimaryLoopInputConnection:self];
        }else{
            [self.comparisonBlock setSecondaryLoopInputConnection:self];
        }
        
    }
    
    
    
    [self setSource:nodeA];
    [self setDestination:nodeB];
    
    if([self isEmptyLoop]){
    
        self.connectionAnchorTypeSource=ConnectionEndPointAnchorTypeLeft;
        self.connectionAnchorTypeDestination=ConnectionEndPointAnchorTypeRight;
    
    }else{
    
        if([self isStartOfLoop]){
            
            self.connectionAnchorTypeSource=ConnectionEndPointAnchorTypeLeft;
            self.connectionAnchorTypeDestination=ConnectionEndPointAnchorTypeLeft;
            
        }else if([self isEndOfLoop]){
            
            self.connectionAnchorTypeSource=ConnectionEndPointAnchorTypeRight;
            self.connectionAnchorTypeDestination=ConnectionEndPointAnchorTypeRight;
            
        }else{
        
            self.connectionAnchorTypeSource=ConnectionEndPointAnchorTypeRight;
            self.connectionAnchorTypeDestination=ConnectionEndPointAnchorTypeLeft;
            
        }
    }
    
    return true;
}

-(NSDictionary *)save{
    return nil;
}


@end
