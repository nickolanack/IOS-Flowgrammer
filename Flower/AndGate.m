//
//  AndGate.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "AndGate.h"

@implementation AndGate

-(void)configure{
    [super configure];
    [self setName:@"And Gate"];
}


-(CGPathRef)getPath{
    
    
    CGPoint a=self.pa;
    CGPoint b=self.pb;
    CGPoint c=self.pc;
    
    
    CGMutablePathRef p=CGPathCreateMutable();
    
    CGPathMoveToPoint(p, nil,  b.x, b.y);
    CGPathAddCurveToPoint(p, nil, b.x, b.y+10, c.x+15, c.y, c.x, c.y);
    //CGPathAddLineToPoint(p, nil, c.x, c.y);
    
    CGPathAddLineToPoint(p, nil, a.x, a.y);
    CGPathAddCurveToPoint(p, nil, a.x+15, a.y, b.x, b.y-10, b.x, b.y);
    //CGPathAddLineToPoint(p, nil, b.x, b.y);
    return p;
}


-(bool)evaluate{
    
    VariableConnection *avc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:0];
    Variable *a=(Variable *)avc.source;
    
    VariableConnection *bvc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:1];
    Variable *b=(Variable *)bvc.source;
    
    if(a!=nil&&b!=nil){
        return [[a value] boolValue]&&[[b value] boolValue];
    }
    return false;
}

@end
