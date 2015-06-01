//
//  NotGate.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-10.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NotGate.h"

@implementation NotGate

-(void)configure{
    [super configure];
    [self setName:@"Not Gate"];
}
-(void)drawConnections:(CGContextRef)c{
 
    float i=self.inset-2;
    CGRect r=CGRectMake(self.pb.x-2, self.pb.y-(i/2.0), i, i);
    CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
   CGContextAddEllipseInRect(c, r);
    CGContextFillPath(c);
    

    
    if(self.isDoubleSelected){
        CGContextSetStrokeColorWithColor(c, self.doubleActiveBorderColor.CGColor);
    }else if(self.isSelected){
        CGContextSetStrokeColorWithColor(c, self.activeBorderColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(c, self.borderColor.CGColor);
    }
    CGContextAddEllipseInRect(c, r);
    CGContextStrokePath(c);
     
}


-(void)addInputs{
    
    VariableConnection *a=[[VariableConnection alloc] init];
    [a setName:@"in"];
    [a setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeLeft];
    [a setCenterAlignOffsetDestination:CGPointMake(7,0)];
    [a connectNode:nil toNode:self];
    
    [a setVariableType:[BooleanVariable class]];
    [a setMidPointColor:[UIColor magentaColor]];
    
}

-(void)addOutputs{
    
    VariableConnection *o=[[VariableConnection alloc] init];
    [o setName:@"out"];
    [o setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [o setCenterAlignOffsetSource:CGPointMake(-5, 0)];
    [o connectNode:self toNode:nil];
    
    [o setVariableType:[BooleanVariable class]];
    [o setMidPointColor:[UIColor magentaColor]];
    
}

-(bool)evaluate{
    VariableConnection *avc=(VariableConnection *)[self.inputVariableConnections objectAtIndex:0];
    Variable *a=(Variable *)avc.source;
    if(a!=nil){
        bool v=![[a value] boolValue];
        return v;
    }
    return true;
}

@end
