//
//  ComparisonBlock.m
//  Flower
//
//  Created by Nick Blackwell on 3/8/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ComparisonBlock.h"
#import "ComparisonConnection.h"
#import "Flow.h"
#import "NumberVariable.h"
#import "BooleanVariable.h"

@interface ComparisonBlock()


@property bool currentState;


@end

@implementation ComparisonBlock

@synthesize  primaryLoopInputConnection, primaryLoopOutputConnection, secondaryLoopInputConnection, secondaryLoopOutputConnection;


-(void)configure{
    [super configure];
    _currentState=false;
    
    ComparisonConnection *loopIf=[[ComparisonConnection alloc] init];
    [loopIf setIsPrimaryLoop:true];
    ComparisonConnection *loopElse=[[ComparisonConnection alloc] init];
    
    [loopIf connectNode:self toNode:self];
    [loopElse connectNode:self toNode:self];
    
    VariableConnection *shouldLoop=[[VariableConnection alloc] init];
    [shouldLoop setName:@"evaluationBoolean"];
    [shouldLoop setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeBottom];
    [shouldLoop setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeTop];
    [shouldLoop connectNode:nil toNode:self];
    
    Class c1=[NumberVariable class], c2=[BooleanVariable class];
    
    [shouldLoop setVariableTypes:@[[NSValue valueWithBytes:&c1 objCType:@encode(Class)],[NSValue valueWithBytes:&c2 objCType:@encode(Class)]]];
    [shouldLoop setMidPointColors:@[[UIColor magentaColor],[UIColor cyanColor]]];

    [self setName:@"If Else"];
}

-(void)selectNextConnection:(float)delay{
    if(self.selectedNextConnection!=nil){
        [self.selectedNextConnection activate:delay];
    }else{
        [super selectNextConnection:delay];
    }
}




-(JSValue *)blockEvaluateContext:(JSContext *)context withPreviousBlock:(FunctionalBlock *)block{
    
    JSValue *output=[super blockEvaluateContext:context withPreviousBlock:block];
    if(block==[self getPreviousPrimaryLoopBlock]||block==[self getPreviousSecondaryLoopBlock]||block==self){
        //nothing to do here.
    }else{
    
        
        Variable *var=(Variable *)((VariableConnection *)[self.inputVariableConnections objectAtIndex:0]).source;
        id value=var!=nil?[var value]:nil;
        if(value!=nil&&(([value isKindOfClass:[NSNumber class]]&&[(NSNumber *)value boolValue])||([value isKindOfClass:[NSString class]]&&[(NSString *)value boolValue]))){
            self.selectedNextConnection=self.primaryLoopOutputConnection;
        }else{
            self.selectedNextConnection=self.secondaryLoopOutputConnection;
        }
    
        //[self message:@"comparison!"];
    }
    
    return output;
}


-(FunctionalBlock *)getNextPrimaryLoopBlock{
    if(self.primaryLoopOutputConnection==nil)return nil;
    FunctionalBlock *next=(FunctionalBlock *)self.primaryLoopOutputConnection.destination;
    if(next!=self)return next;
    return nil;
}

-(FunctionalBlock *)getPreviousPrimaryLoopBlock{
    if(self.primaryLoopInputConnection==nil)return nil;
    FunctionalBlock *prev=(FunctionalBlock *)self.primaryLoopInputConnection.source;
    if(prev!=self)return prev;
    return nil;
}

-(FunctionalBlock *)getNextSecondaryLoopBlock{
    if(self.secondaryLoopOutputConnection==nil)return nil;
    FunctionalBlock *next=(FunctionalBlock *)self.secondaryLoopOutputConnection.destination;
    if(next!=self)return next;
    return nil;
}


-(bool)doesPrimaryLoopHaveMultipleBlocks{
    return ([self isPrimaryLoopEmpty]||[self doesPrimaryLoopHaveOneBlock])?false:true;
}
-(bool)doesPrimaryLoopHaveOneBlock{
    FunctionalBlock *block=[self getNextPrimaryLoopBlock];
    return (block!=self)?true:false;
}
-(bool)isPrimaryLoopEmpty{
    return ([self getNextPrimaryLoopBlock]==nil)?true:false;
}


-(bool)doesSecondaryLoopHaveMultipleBlocks{
    return ([self isSecondaryLoopEmpty]||[self doesSecondaryLoopHaveOneBlock])?false:true;
}
-(bool)doesSecondaryLoopHaveOneBlock{
    FunctionalBlock *block=[self getNextSecondaryLoopBlock];
    return (block!=self)?true:false;
}
-(bool)isSecondaryLoopEmpty{
    return ([self getNextSecondaryLoopBlock]==nil)?true:false;
}

-(FunctionalBlock *)getPreviousSecondaryLoopBlock{
    if(self.secondaryLoopInputConnection==nil)return nil;
    FunctionalBlock *prev=(FunctionalBlock *)self.secondaryLoopInputConnection.source;
    if(prev!=self)return prev;
    return nil;
}




-(void)handleCloneLoopRequest{
    NSLog(@"Clone Comparison");
}
-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[super getMenuItemsArray]];
    
    //add new menu items
    
    return [[NSArray alloc] initWithArray:array];
}



-(NSArray *)getConnections{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getConnections]];
   
    if(self.primaryLoopOutputConnection!=nil)[a addObject:self.primaryLoopOutputConnection];
    if(![self isPrimaryLoopEmpty]){
        [a addObject:self.primaryLoopInputConnection];
    }
    if(self.secondaryLoopOutputConnection!=nil)[a addObject:self.secondaryLoopOutputConnection];
    if(![self isSecondaryLoopEmpty]){
        [a addObject:self.secondaryLoopInputConnection];
    }
    
    return [[NSArray alloc] initWithArray:a];
}

-(NSArray *)getBlocksConnectedToInput{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getBlocksConnectedToInput]];
    if(![self isPrimaryLoopEmpty]){
        [a addObject:[self getPreviousPrimaryLoopBlock]];
    }
    if(![self isSecondaryLoopEmpty]){
        [a addObject:[self getPreviousSecondaryLoopBlock]];
    }
    return [[NSArray alloc] initWithArray:a];
}
-(NSArray *)getBlocksConnectedToOutput{
    NSMutableArray *a=[[NSMutableArray alloc] initWithArray:[super getBlocksConnectedToInput]];
    if(![self isPrimaryLoopEmpty]){
        [a addObject:[self getNextPrimaryLoopBlock]];
    }
    if(![self isSecondaryLoopEmpty]){
        [a addObject:[self getNextSecondaryLoopBlock]];
    }
    return [[NSArray alloc] initWithArray:a];
}



-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    
    //draw if else internals
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float l=10;
    float r=5;
    float dy=10;
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGPoint p=CGPointMake(0, self.frame.size.height/2.0);
    if(_currentState){
        
        CGContextMoveToPoint(context, p.x, p.y+dy);
        CGContextAddLineToPoint(context, p.x+l, p.y+dy);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
        CGContextMoveToPoint(context, p.x, p.y);
        CGContextAddLineToPoint(context, p.x+l, p.y);
        CGContextAddCurveToPoint(context, p.x+(l+r), p.y, p.x+(l+r), p.y-dy, p.x+l, p.y-dy);
        CGContextAddLineToPoint(context, p.x, p.y-dy);
        CGContextStrokePath(context);
        
    }else{
        CGContextMoveToPoint(context, p.x, p.y-dy);
        CGContextAddLineToPoint(context, p.x+l, p.y-dy);
        CGContextStrokePath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
        CGContextMoveToPoint(context, p.x, p.y);
        CGContextAddLineToPoint(context, p.x+l, p.y);
        CGContextAddCurveToPoint(context, p.x+(l+r), p.y, p.x+(l+r), p.y+dy, p.x+l, p.y+dy);
        CGContextAddLineToPoint(context, p.x, p.y+dy);
        CGContextStrokePath(context);
    }
    //CGContextAddCurveToPoint(context, p.x+15, p.y, p.x+15, p.y+10, 10, p.y+10);
    //CGContextAddLineToPoint(context, p.x, p.y+10);
   
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    
    p=CGPointMake(self.frame.size.width, self.frame.size.height/2.0);
   
    CGContextMoveToPoint(context, p.x, p.y);
    CGContextAddLineToPoint(context, p.x-l, p.y);
    CGContextAddCurveToPoint(context, p.x-(l+r), p.y, p.x-(l+r), p.y-dy, p.x-l, p.y-dy);
    CGContextAddLineToPoint(context, p.x, p.y-dy);
    CGContextStrokePath(context);

    CGContextMoveToPoint(context, p.x, p.y);
    CGContextAddLineToPoint(context, p.x-l, p.y);
    CGContextAddCurveToPoint(context, p.x-(l+r), p.y, p.x-(l+r), p.y+dy, p.x-l, p.y+dy);
    CGContextAddLineToPoint(context, p.x, p.y+dy);
    CGContextStrokePath(context);
}

-(bool)isAvailableForInsertion{
    if(self.primaryInputConnection==nil&&self.primaryOutputConnection==nil)return true;
    return false;
}

-(void)handleDeleteRequest{
    
    while(self.primaryLoopOutputConnection.destination!=self){
        [self.flow sliceBlock:(FunctionalBlock *)self.primaryLoopOutputConnection.destination];
    }
    
    while(self.secondaryLoopOutputConnection.destination!=self){
        [self.flow sliceBlock:(FunctionalBlock *)self.secondaryLoopOutputConnection.destination];
    }
    if(self.flow!=nil){
        [self.flow deleteConnection:self.primaryLoopOutputConnection];
        [self.flow deleteConnection:self.secondaryLoopOutputConnection];
    }else{
        [self.primaryLoopOutputConnection removeFromSuperview];
        [self.secondaryLoopOutputConnection removeFromSuperview];
    }
    [super handleDeleteRequest];
}


-(void)notifyInputVariableDidChangeValueForConnection:(VariableConnection *)v{
    if(v==[self.inputVariableConnections objectAtIndex:0]){
        if(v.source!=nil&&[[((Variable *) v.source) value] boolValue]){
            _currentState=true;
        }else{
            _currentState=false;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
        
    }
    
}

-(bool)restore:(NSDictionary *)state{
    
    NSArray *ifLoopBlocks=[state objectForKey:@"ifLoopBlocks"];
    if(ifLoopBlocks!=nil){
        for(NSNumber *b in ifLoopBlocks){
            [self.flow insertBlock:(FunctionalBlock *)[self.flow blockAtIndex:[b integerValue]] at:self.primaryLoopInputConnection];
        }
    }
    
    NSArray *elseLoopBlocks=[state objectForKey:@"elseLoopBlocks"];
    if(elseLoopBlocks!=nil){
        for(NSNumber *b in elseLoopBlocks){
            [self.flow insertBlock:(FunctionalBlock *)[self.flow blockAtIndex:[b integerValue]] at:self.secondaryLoopInputConnection];
        }
    }
    
    return [super restore:state];
}


-(NSDictionary *)save{
    NSMutableDictionary *d=[[NSMutableDictionary alloc] initWithDictionary:[super save]];
    
    NSMutableArray *ifLoopBlocks=[[NSMutableArray alloc] init];
    FunctionalBlock *b=(FunctionalBlock *)self.primaryLoopOutputConnection.destination;
    while(b!=self){
        [ifLoopBlocks addObject:[NSNumber numberWithInt:[self.flow indexOfBlock:b]]];
        b=[b getNextBlock];
    }
    [d addEntriesFromDictionary:@{@"ifLoopBlocks":ifLoopBlocks}];
    
    
    NSMutableArray *elseLoopBlocks=[[NSMutableArray alloc] init];
    FunctionalBlock *c=(FunctionalBlock *)self.secondaryLoopOutputConnection.destination;
    while(c!=self){
        [elseLoopBlocks addObject:[NSNumber numberWithInt:[self.flow indexOfBlock:c]]];
        c=[c getNextBlock];
    }
    [d addEntriesFromDictionary:@{@"elseLoopBlocks":elseLoopBlocks}];
        
    return d;
}

@end
