//
//  BackLoopConnection.m
//  Flower
//
//  Created by Nick Blackwell on 2/28/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LoopConnection.h"
#import "Node.h"
#import "LoopNode.h"


@interface Connection()


@end

@implementation LoopConnection

@synthesize loopNode;

-(id)init{


    self=[super init];
    if(self){
    
        //[self setDrawFrame:true];
    
        return self;
    }

    return nil;
}


-(bool)isStartOfLoop{
    
    if(self.previous==self.loopNode)return true;
    return false;
    
}
-(bool)isMiddleOfLoop{
    return ([self isStartOfLoop]||[self isEndOfLoop])?false:true;
}

-(bool)isEndOfLoop{
    if(self.next==self.loopNode)return true;
    return false;
}
-(bool) isEmptyLoop{
    if(self.next==self.previous)return true;
    return false;
    
}

-(void)calculateDrawParams{
    
    
    [super calculateDrawParams];
    
    self.pathColor=[UIColor magentaColor];
    
    if([self isEmptyLoop]){
        float cp=100;
        self.c=CGPointMake(self.c.x, self.c.y-100);
        self.cpca=CGPointMake(self.c.x+cp,self.c.y);
        self.cpcb=CGPointMake(self.c.x-cp,self.c.y);
    }else{
    
        float cpLength=MIN(MAX(40.0, ABS(self.dx)/5.0), 200);
        
        if(![self isStartOfLoop]){
            self.a=[self convertPoint:CGPointMake(self.previous.frame.origin.x-self.margin, self.previous.frame.origin.y+(self.previous.frame.size.height/2.0)) fromView:self.superview];
            self.cpa=CGPointMake(self.a.x-cpLength, self.cpa.y);
            
        }
        
        if([self isStartOfLoop]||[self isEndOfLoop]){
            cpLength=MIN(MAX(40.0, ABS(self.distance)/2.5), 200);
        }
        
        if([self isStartOfLoop]){
            
            self.cpb=CGPointMake(self.b.x+cpLength, self.cpb.y);
            self.cpa=CGPointMake(self.a.x+cpLength, self.cpa.y);
            //cpa from parent is fine
        }
        
        
        
        
        if(![self isEndOfLoop]){
            self.b=[self convertPoint:CGPointMake(self.next.frame.size.width+self.next.frame.origin.x+self.margin, self.next.frame.origin.y+(self.next.frame.size.height/2.0)) fromView:self.superview];
            self.cpb=CGPointMake(self.b.x+cpLength, self.cpb.y);
        }else{
            
            self.cpb=CGPointMake(self.b.x-cpLength, self.cpb.y);
            self.cpa=CGPointMake(self.a.x-cpLength, self.cpa.y);
        
        
        }
  
       
        self.c=CGPointMake((self.cpa.x+self.cpb.x)/2.0, self.c.y);
        self.cpca=self.c;
        self.cpcb=self.c;
       
        
    
        
    
    }
}
/*
-(void)drawRect:(CGRect)rect{

    if([self isStartOfLoop])[super drawRect:rect];

}
*/
-(Connection *)getNextConnectionForSplit{

    LoopConnection *l=[[LoopConnection alloc] init];
    [l setLoopNode:self.loopNode];
    return l;
    
}

-(CGRect)rectUnion:(CGRect)a :(CGRect)b{

    if(self.next==self.previous){
    
        return [super rectUnion:a :CGRectMake(a.origin.x-50, a.origin.y-160, a.size.width+100, a.size.height+160)];
    
    }
    CGRect r=[super rectUnion:a :b];

    if(![self isMiddleOfLoop]){
        float dxy=(r.size.height*2)-r.size.width;
        if(dxy>0){
            r.origin.x-=dxy/2.0;
            r.size.width+=dxy;
        }
    }
    return r;
}

-(bool)drawInsertArea:(Node *)node{

    if(node==self.loopNode)return false;
    return [super drawInsertArea:node];
}

-(bool)connectNode:(Node *)nodeA toNode:(Node *)nodeB{
    
    
    
    if(nodeA!=self.loopNode){
       [nodeA setOutput:self]; //this will already be set to the main flow
    }
    
    if(nodeB!=self.loopNode){
        [nodeB setInput:self]; //this will already be set to the main flow
    }else{
        [self.loopNode setLoopin:self];
    }
   
   
    
    [self setPrevious:nodeA];
    [self setNext:nodeB];
    return true;
}

@end
