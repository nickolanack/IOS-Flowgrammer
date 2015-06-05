//
//  XorGate.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-11.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "XorGate.h"

@implementation XorGate



-(void)configure{
    [super configure];
    [self setName:@"Xor Gate"];
}
-(void)addInputs{
    
    VariableConnection *a=[[VariableConnection alloc] init];
    [a setName:@"a"];
    [a setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeLeft];
    [a setCenterAlignOffsetDestination:CGPointMake(3, -(self.frame.size.height/2)+self.inset+2)];
    [a connectNode:nil toNode:self];
    
    [a setVariableType:[BooleanVariable class]];
    [a setMidPointColor:[BooleanVariable Color]];
    
    
    VariableConnection *b=[[VariableConnection alloc] init];
    [b setName:@"b"];
    [b setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeLeft];
    [b setCenterAlignOffsetDestination:CGPointMake(3, +(self.frame.size.height/2)-self.inset-2)];
    [b connectNode:nil toNode:self];
    
    [b setVariableType:[BooleanVariable class]];
    [b setMidPointColor:[BooleanVariable Color]];
    
}
-(bool)evaluate{
    
    VariableConnection *avc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:0];
    Variable *a=(Variable *)avc.source;
    
    VariableConnection *bvc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:1];
    Variable *b=(Variable *)bvc.source;
    
    bool aval=false;
    bool bval=false;
    
    if(a!=nil&&[[a value] boolValue]){
        aval=true;
    }
    if(b!=nil&&[[b value] boolValue]){
        bval=true;
    }
    return (!(aval&&bval))&&(aval||bval);
}

-(void)drawConnections:(CGContextRef)c{
    [super drawConnections:c];
    
    CGPoint a=self.pa;
    CGPoint b=self.pc;
    a.x-=4;
    b.x-=4;
    CGContextMoveToPoint(c, a.x, a.y);
    //CGPathAddCurveToPoint(p, nil, c.x+4, c.y-6, a.x+4, a.y+6, a.x, a.y);
    CGContextAddCurveToPoint(c, a.x+4, a.y+6, b.x+4, b.y-6, b.x, b.y);
    if(self.isDoubleSelected){
        CGContextSetStrokeColorWithColor(c, self.doubleActiveBorderColor.CGColor);
    }else if(self.isSelected){
        CGContextSetStrokeColorWithColor(c, self.activeBorderColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
    }
    CGContextStrokePath(c);
    
}

@end
