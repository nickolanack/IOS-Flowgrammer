//
//  OrGate.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "OrGate.h"

@implementation OrGate

-(void)configure{
    [super configure];
    [self setName:@"Or Gate"];
}
-(CGPathRef)getPath{
    
    
    CGPoint a=self.pa;
    CGPoint b=self.pb;
    CGPoint c=self.pc;
    
    
    CGMutablePathRef p=CGPathCreateMutable();
    
    CGPathMoveToPoint(p, nil,  b.x, b.y);
    CGPathAddCurveToPoint(p, nil, b.x-2, b.y+5, c.x+12, c.y, c.x, c.y);
    //CGPathAddLineToPoint(p, nil, c.x, c.y);
    
    CGPathAddCurveToPoint(p, nil, c.x+4, c.y-6, a.x+4, a.y+6, a.x, a.y);
    //CGPathAddLineToPoint(p, nil, a.x, a.y);
    CGPathAddCurveToPoint(p, nil, a.x+12, a.y, b.x-2, b.y-5, b.x, b.y);
    //CGPathAddLineToPoint(p, nil, b.x, b.y);
    return p;
}
-(bool)evaluate{
    
    VariableConnection *avc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:0];
    Variable *a=(Variable *)avc.source;
    
    VariableConnection *bvc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:1];
    Variable *b=(Variable *)bvc.source;
    
    if(a!=nil&&[[a value] boolValue]){
        return true;
    }
    if(b!=nil&&[[b value] boolValue]){
        return true;
    }
    return false;
}

@end
