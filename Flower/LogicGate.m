//
//  LogicGate.m
//  Flower
//
//  Created by Nick Blackwell on 2014-04-09.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "LogicGate.h"

@interface LogicGate()

@property bool configuring;

@end

@implementation LogicGate

@synthesize inset, pa, pb, pc;

-(void)configure{
    [self setBackgroundColor:[UIColor clearColor]];
    [super configure];

    [self.layer setBorderWidth:0];
    [self setName:@"Logic Gate"];
    [self positionLabel];
    
    self.inset=10.0;
   
    float i=inset;
    pa=CGPointMake(i, i);
    pb=CGPointMake(self.frame.size.width-i, self.frame.size.height/2.0);
    pc=CGPointMake(i, self.frame.size.height-i);
    
    self.path=[self getPath];
    _configuring=true;
    [self addInputs];
    [self addOutputs];
    _configuring=false;
    
}

-(void)addInputs{
    
    VariableConnection *a=[[VariableConnection alloc] init];
    [a setName:@"a"];
    [a setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeLeft];
    [a setCenterAlignOffsetDestination:CGPointMake(7, -(self.frame.size.height/2)+self.inset+2)];
    [a connectNode:nil toNode:self];
    
    [a setVariableType:[BooleanVariable class]];
    [a setMidPointColor:[BooleanVariable Color]];
    
    
    
    VariableConnection *b=[[VariableConnection alloc] init];
    [b setName:@"b"];
    [b setConnectionAnchorTypeDestination:ConnectionEndPointAnchorTypeLeft];
    [b setCenterAlignOffsetDestination:CGPointMake(7, +(self.frame.size.height/2)-self.inset-2)];
    [b connectNode:nil toNode:self];
    
    [b setVariableType:[BooleanVariable class]];
    [b setMidPointColor:[BooleanVariable Color]];
    
}
-(void)addOutputs{
    
    VariableConnection *o=[[VariableConnection alloc] init];
    [o setName:@"out"];
    [o setConnectionAnchorTypeSource:ConnectionEndPointAnchorTypeRight];
    [o setCenterAlignOffsetSource:CGPointMake(-10, 0)];
    [o connectNode:self toNode:nil];
    
    [o setVariableType:[BooleanVariable class]];
    [o setMidPointColor:[BooleanVariable Color]];
    
}

-(bool)evaluate{
    return false;
}
-(void)propagate{
    if(_configuring)return;
    VariableConnection *ovc=(VariableConnection *)[self.outputVariableConnections objectAtIndex:0];
    Variable *v=(Variable *)ovc.destination;
    if(v!=nil){
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            bool o=[self evaluate];
            if([[v value] boolValue]!=o){
                [v setValue:[NSNumber numberWithBool:o]];
            }
        });
        
    }
    
}

-(void)notifyOutputVariableDidChangeValueForConnection:(VariableConnection *)vc{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         [self propagate];
    });
    
}

-(void)notifyInputVariableDidChangeValueForConnection:(VariableConnection *)vc{
    [self propagate];
    
}

-(void)notifyOutputVariableConnectionStateDidChange:(VariableConnection *)vc{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self propagate];
    });
}

-(void)notifyInputVariableConnectionStateDidChange:(VariableConnection *)vc{
    [self propagate];
}

-(CGPathRef)getPath{
    
    CGPoint a=pa;
    CGPoint b=pb;
    CGPoint c=pc;
    
    CGMutablePathRef p=CGPathCreateMutable();
    
    CGPathMoveToPoint(p, nil,  b.x, b.y);
    CGPathAddLineToPoint(p, nil, c.x, c.y);
    CGPathAddLineToPoint(p, nil, a.x, a.y);
    CGPathAddLineToPoint(p, nil, b.x, b.y);
    
    return p;
}

-(void)positionLabel{
    [self.label setAlpha:0];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.label setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height+5)];
        self.label.text=[self.name lowercaseString];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5];
        [self.label setAlpha:1];
        [UIView commitAnimations];
    });
}

-(void)setIsSelected:(bool)isSelected{
    bool was=self.isSelected;
    [super setIsSelected:isSelected];
    if(isSelected!=was){
        [self setNeedsDisplay];
    }
}




-(void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextAddPath(context,  self.path);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
   
    CGContextAddPath(context,  self.path);
    if(self.isDoubleSelected){
     CGContextSetStrokeColorWithColor(context, self.doubleActiveBorderColor.CGColor);
    }else if(self.isSelected){
        CGContextSetStrokeColorWithColor(context, self.activeBorderColor.CGColor);
    }else{
     CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    }
   
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
    [self drawConnections:context];
    
}

-(void)drawConnections:(CGContextRef)c{

}


@end
