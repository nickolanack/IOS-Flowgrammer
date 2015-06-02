//
//  LoopNode.m
//  Flower
//
//  Created by Nick Blackwell on 2/27/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LoopBlock.h"
#import "LoopConnection.h"
#import "FlowView.h"
#import "NumberVariable.h"
#import "BooleanVariable.h"
#import "Flowutils.h"

@interface LoopBlock()


@property int counter;

@end

@implementation LoopBlock

@synthesize loopin, loopout;



-(void)configure{
    [super configure];
  
    [[[LoopConnection alloc] init] connectNode:self toNode:self];
    
    VariableConnection *shouldLoop=[[VariableConnection alloc] init];
    [shouldLoop setName:@"shouldLoop"];
    [shouldLoop setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeBottom];
    [shouldLoop connectNode:nil toNode:self];
    
    Class c1=[NumberVariable class], c2=[BooleanVariable class];
    
    [shouldLoop setVariableTypes:@[[NSValue valueWithBytes:&c1 objCType:@encode(Class)],[NSValue valueWithBytes:&c2 objCType:@encode(Class)]]];
    [shouldLoop setMidPointColors:@[[UIColor magentaColor],[UIColor cyanColor]]];

    
    VariableConnection *incrementor=[[VariableConnection alloc] init];
    [incrementor setName:@"increment"];
    [incrementor setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [incrementor setCenterAlignOffsetSource:CGPointMake(15, 0)];
    [incrementor connectNode:self toNode:nil];
    
    [incrementor setVariableType:[NumberVariable class]];
    [incrementor setMidPointColor:[UIColor cyanColor]];
    
    VariableConnection *decrementor=[[VariableConnection alloc] init];
    [decrementor setName:@"decrement"];
    [decrementor setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [decrementor setCenterAlignOffsetSource:CGPointMake(-15, 0)];
    [decrementor connectNode:self toNode:nil];
    
    [decrementor setVariableType:[NumberVariable class]];
    [decrementor setMidPointColor:[UIColor cyanColor]];

    
    [self setName:@"Loop"];
}

-(void)handleDeleteRequest{
   
    
    while(self.loopout.destination!=self){
        [self.flow sliceBlock:(FunctionalBlock *)self.loopout.destination];
    }
   
    if(self.flow!=nil){
        [self.flow deleteConnection:self.loopout];
    }else{
        [self.loopout removeFromSuperview];
    }
    [super handleDeleteRequest];
}



-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    
    
    if(block==self.loopin.source){
        _counter++;
       
        VariableConnection *inc=[self.outputVariableConnections objectAtIndex:0];
        if(inc.destination!=nil){
            NSValue *i=[(Variable *)inc.destination value];
            if([i isKindOfClass:[NSNumber class]]){
                [(Variable *)inc.destination setValue:[NSNumber numberWithInteger:[(NSNumber *)i integerValue]+1]];
            }
        }
        
        
        VariableConnection *dec=[self.outputVariableConnections objectAtIndex:1];
        if(dec.destination!=nil){
            NSValue *j=[(Variable *)dec.destination value];
            if(j!=nil&&[j isKindOfClass:[NSNumber class]]){
                [(Variable *)dec.destination setValue:[NSNumber numberWithInteger:[(NSNumber *)j integerValue]-1]];
            }
        }
        
    }else{
        _counter=0;
    }
    
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    VariableConnection *con=[self.inputVariableConnections objectAtIndex:0];
    NSValue *var=[(Variable *)con.source value];
    if(var!=nil&&(([var isKindOfClass:[NSNumber class]]&&[(NSNumber *)var boolValue])||([var isKindOfClass:[NSString class]]&&[(NSString *)var boolValue]))){
        self.selectedNextConnection=self.loopout;
    }
    
    return output;
}
-(void)handleCloneLoopRequest{
    NSLog(@"Clone Loop");
}
-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
   // if(self.loopout.destination!=self)[array addObject:[[UIMenuItem alloc] initWithTitle: @"Clone Loop" action:@selector(handleCloneLoopRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(void)selectNextConnection:(float)delay{
    if(self.selectedNextConnection!=nil){
        [self.selectedNextConnection activate:delay];
    }else{
        [super selectNextConnection:delay];
    }
}



-(NSArray *)getConnections{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getConnections]];
    
    if(self.loopout!=nil)[a addObject:self.loopout];
    if(self.loopin!=nil&&self.loopout!=self.loopin)[a addObject:self.loopin];
    
    return [[NSArray alloc] initWithArray:a];
}

-(NSArray *)getBlocksConnectedToInput{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getBlocksConnectedToInput]];
    
    FunctionalBlock *prevLoopNode=[self getLoopPrevNode];
    if(prevLoopNode!=nil)[a addObject:prevLoopNode];
    
    return [[NSArray alloc] initWithArray:a];
}
-(NSArray *)getBlocksConnectedToOutput{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getBlocksConnectedToInput]];
    
    FunctionalBlock *nextLoopNode=[self getLoopNextNode];
    if(nextLoopNode!=nil)[a addObject:nextLoopNode];
    
    return [[NSArray alloc] initWithArray:a];
}

-(FunctionalBlock *) getLoopNextNode{
    
   FunctionalBlock *n=(FunctionalBlock *)self.loopout.destination;
    if(n==self)return nil;
    return n;
   
}
-(FunctionalBlock *) getLoopPrevNode{
    FunctionalBlock *n=(FunctionalBlock *)self.loopin.source;
    if(n==self)return nil;
    return n;
}



-(bool)isAvailableForInsertion{
    if(self.primaryInputConnection==nil&&self.primaryOutputConnection==nil)return true;
    return false;
}

-(bool)restore:(NSDictionary *)state{
    NSArray *loopBlocks=[state objectForKey:@"loopBlocks"];
 
    if(loopBlocks!=nil){
        for(NSNumber *b in loopBlocks){
            [Flowutils InsertBlock:(FunctionalBlock *)[self.flow blockAtIndex:[b integerValue]] At:self.loopin];
        }
        
   
    }
    return [super restore:state];
}

-(void)notifyInputVariableDidChangeValueForConnection:(VariableConnection *)v{
    if(v==[self.inputVariableConnections objectAtIndex:0]){
        if(v.source!=nil&&[[((Variable *) v.source) value] boolValue]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loopImage setTintColor:[UIColor magentaColor]];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loopImage setTintColor:[UIColor lightGrayColor]];
            });
            
        }
    }

}

-(NSDictionary *)save{
    NSMutableDictionary *d=[[NSMutableDictionary alloc] initWithDictionary:[super save]];

    NSMutableArray *loopBlocks=[[NSMutableArray alloc] init];
    FunctionalBlock *b=(FunctionalBlock *)self.loopout.destination;
    while(b!=self){
        [loopBlocks addObject:[NSNumber numberWithInt:[self.flow indexOfBlock:b]]];
        b=[b getNextBlock];
    }
    [d addEntriesFromDictionary:@{@"loopBlocks":loopBlocks}];
    return d;
}
@end
