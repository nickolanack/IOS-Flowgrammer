//
//  VariableConnection.m
//  Flower
//
//  Created by Nick Blackwell on 3/9/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "VariableConnection.h"
#import "ProcessorBlock.h"
#import "FlowView.h"

@implementation VariableConnection

@synthesize strictTypeSource, namesVariable, displaysName, variableTypes;

-(void)configure{
    
    [super configure];
    self.namesVariable=false;
    self.locksToFirstConnected=true;
    self.connectionPathColor=[[UIColor blueColor] colorWithAlphaComponent:0.1];
    self.endPointColor=[UIColor blueColor];
    [self setName:@"variable connection"];
    
    
}

-(NSArray *)getTargetMenuItems{
    if(self.source==nil||self.destination==nil)return @[];
    
    if(!self.destinationLocked||!self.sourceLocked){
        [self becomeFirstResponder];
        return @[[[UIMenuItem alloc] initWithTitle:@"Disconnect" action:@selector(disconnectUnlockedEnd)]];
    }
    
    return @[];
}
-(void)disconnectUnlockedEnd{
    if(!self.destinationLocked){
        
        if([self.destination isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.destination) removeInputVariableConnection:self];
        }else{
            [((Variable *)self.destination) removeMutatorConnection:self];
        }
        
        self.destination=nil;
        
        if([self.source isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.source) notifyOutputVariableDidChangeValueForConnection:self];
        }
        
        if(self.source&&[self.source isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.source) notifyOutputVariableConnectionStateDidChange:self];
        }
        
    }if(!self.sourceLocked){
        
        if([self.destination isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.destination) removeOutputVariableConnection:self];
        }else{
            [((Variable *)self.destination) removeAccessorConnection:self];
            
            
        }
        
        self.source=nil;
        
        if([self.destination isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.destination) notifyInputVariableDidChangeValueForConnection:self];
        }
        
        if(self.destination&&[self.destination isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.destination) notifyInputVariableConnectionStateDidChange:self];
        }
    
    }
    
    if(self.source==nil&&self.destination==nil){
        if([self.superview isKindOfClass:[FlowView class]]){
            [(FlowView *)self.superview deleteConnection:self];
        }else{
            [self removeFromSuperview];
        }
    }else{
        [self needsUpdate];
    }
}

-(BOOL)canBecomeFirstResponder{
    return true;
}

-(bool)shouldDrawMidPoint{
    return self.source==nil||self.destination==nil;
}

-(bool)connectNode:(Block *)nodeA toNode:(Block *)nodeB{
    
    if(self.locksToFirstConnected&&self.source==nil&&self.destination==nil){
        
            if(nodeA!=nil)self.sourceLocked=true;
            if(nodeB!=nil)self.destinationLocked=true;
        
    }
    
    NSMutableArray *notify=[[NSMutableArray alloc] init];
    if(nodeA!=nil)[notify addObject:nodeA];
    if(nodeB!=nil)[notify addObject:nodeB];
    
    if(nodeA==nil&&nodeB==nil)return false; ///throw exception?
    
    if(nodeA!=nil){
        if([nodeA isKindOfClass:[Variable class]]){
            
            if(self.connectionAnchorAllowedTypeSource==0){
                self.connectionAnchorAllowedTypeSource=ConnectionEndPointAnchorTypeVariable;
            }
            
            [(Variable *)nodeA addAccessorConnection:self];
            [self setSource:nodeA];
            
            
    
        }else if([nodeA isKindOfClass:[ProcessorBlock class]]){
            [(ProcessorBlock *)nodeA addOutputVariableConnection:self];
            [self setSource:nodeA];
    
        }
    }
    
    if(nodeB!=nil){
        if([nodeB isKindOfClass:[Variable class]]){
            
            if(self.connectionAnchorAllowedTypeDestination==0){
                self.connectionAnchorAllowedTypeDestination=ConnectionEndPointAnchorTypeVariable;
            }
            
            [(Variable *)nodeB addMutatorConnection:self];
            [self setDestination:nodeB];
            
        }else if([nodeB isKindOfClass:[ProcessorBlock class]]){
            [(ProcessorBlock *)nodeB addInputVariableConnection:self];
            [self setDestination:nodeB];
            
        }
    }
    
    if(self.source!=nil&&self.destination){
        if([self.source isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.source) notifyOutputVariableDidChangeValueForConnection:self];
        }
        
        if([self.destination isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.destination) notifyInputVariableDidChangeValueForConnection:self];
        }
    }
    
    for (Block *b in notify) {
        if([b isKindOfClass:[ProcessorBlock class]]){
            ProcessorBlock *f=(ProcessorBlock *)b;
            if(b==self.source){
                [f notifyOutputVariableConnectionStateDidChange:self];
            }else{
                [f notifyInputVariableConnectionStateDidChange:self];
            }
        }else{
            //should it be necessary to notify variable blocks
            //if so add similar (to above) statements here
        }
    }
    
    return true;
   
}
-(void)setVariableType:(Class)variableType{
    variableTypes=@[[NSValue valueWithBytes:&variableType objCType:@encode(Class)]];
    
    
}
-(bool)canInsertBlock:(Block *)block{

    if(self.source==nil||self.destination==nil){
    
        Block *b=self.source;
        if(b==nil)b=self.destination;
        
        if(b!=nil){
            if(([b isKindOfClass:[Variable class]]&&[block isKindOfClass:[ProcessorBlock class]])||([b isKindOfClass:[ProcessorBlock class]]&&[block isKindOfClass:[Variable class]])){
                
                if(self.variableTypes !=nil&&self.variableTypes.count){
                    
                    for (NSValue *v in self.variableTypes) {
                        Class variableType;
                        [v getValue:&variableType];
                        if([block isKindOfClass:variableType])return true;
                    }
                    
                    return false;
                }
                return true;
            }
        }
    }return false;
}

-(void)calculateConnectionPointAnchors{
    float l=10;
    if(self.source==nil){
        
        self.connectionPointDestination=[self convertPoint:self.relativeConnectionPointDestination fromView:self.destination];
        CGPoint p=CGPointMake(self.connectionPointDestination.x, self.connectionPointDestination.y);
        CGPoint v=[Connection DirectionVectorForAnchorType:self.connectionAnchorTypeDestination];
        p.x+=v.x*l; p.y+=v.y*l;
        self.connectionPointSource=p;
        
    }else if(self.destination==nil){
        
        self.connectionPointSource=[self convertPoint:self.relativeConnectionPointSource fromView:self.source];
        CGPoint p=CGPointMake(self.connectionPointSource.x, self.connectionPointSource.y);
        CGPoint v=[Connection DirectionVectorForAnchorType:self.connectionAnchorTypeSource];
        p.x+=v.x*l; p.y+=v.y*l;
        self.connectionPointDestination=p;
        
    }else{
        [super calculateConnectionPointAnchors];
    }
    
}
-(void)calculateCenterPoint{
    if(self.source==nil){
        self.centerPoint=self.connectionPointSource;
    }else if(self.destination==nil){
        self.centerPoint=self.connectionPointDestination;
    }else{
        [super calculateCenterPoint];
    }

}
-(void)calculateConnectionPointControlPoints{
    if(self.source==nil||self.destination==nil){
        self.controlPointFromSource=self.connectionPointSource;
        self.controlPointFromDestination=self.connectionPointDestination;
    }else{
        [super calculateConnectionPointControlPoints];
    }
}
-(CGRect)rectUnion:(CGRect)a :(CGRect)b{
    
    bool isA=!CGRectIsEmpty(a);
    bool isB=!CGRectIsEmpty(b);
    
    if((isA||isB)&&!(isA&&isB)){
        if(isA){
            return [super rectUnion:a :a];
        }
        if(isB){
            return [super rectUnion:b :b];
        }
    }
    
    CGRect f=[super rectUnion:a :b];
    
    //NSLog(@"frame");
    
    return f;
}
-(bool)deleteConnectionFromFlow:(FlowView *)f{
    if(self.destination!=nil){
        if([self.destination isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.destination) removeInputVariableConnection:self];
        }
        
        if([self.destination isKindOfClass:[Variable class]]){
            [((Variable *)self.destination) removeMutatorConnection:self];
        }
    }
    if(self.destination!=nil){
        if([self.source isKindOfClass:[ProcessorBlock class]]){
            [((ProcessorBlock *)self.source) removeOutputVariableConnection:self];
        }
        
        if([self.source isKindOfClass:[Variable class]]){
            [((Variable *)self.source) removeAccessorConnection:self];
        }
    }
    return true;
}
-(bool)isMutator{
    return ((self.destination!=nil&&[self.destination isKindOfClass:[Variable class]])||(self.source!=nil&&[self.source isKindOfClass:[ProcessorBlock class]]))?true:false;
}
-(bool)isAccessor{
    return ![self isMutator];
}

-(NSDictionary *)save{
    return nil;
}
@end
