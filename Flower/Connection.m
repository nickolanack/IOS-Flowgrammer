//
//  Connection.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Connection.h"
#import "Node.h"
#import "Flow.h"
#import <QuartzCore/QuartzCore.h>
@interface Connection()




@end



@implementation Connection

@synthesize previous, next, delegate, a, b, c, cpa, dx, dy, cpb, cpca, cpcb, droppable, hovering, dropRadius, margin, pathColor, distance, drawCtrlPoints;

-(id)init{

    self=[super init];
    if(self){
    
        [self setBackgroundColor:[UIColor clearColor]];
        [self performSelector:@selector(updateLoop:) withObject:self afterDelay:1.0/4.0];
    
        //[self setDrawFrame:true];
        //drawCtrlPoints=true;
    }
    return self;

}

/* Helper Method for debuging. displays the frame to help with positioning and sizeing, to help avoid clipping */
-(void)setDrawFrame:(bool)draw{
    if(draw){
    
        [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f]];
        [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [self.layer setBorderWidth:0.5f];
        [self.layer setCornerRadius:5.0f];
        //[self.layer setMasksToBounds:YES]; //test if nessesary
    }else{
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setBorderWidth:0];
        [self.layer setCornerRadius:0];
    
    }
    
}

/*this loop is initiated by the constructor it is a helper to fix rendering/sizing issues after splicing and inserting. it would be nice to not need it! */
-(void)updateLoop:(id)sender{
    [self needsUpdate];
    [self performSelector:@selector(updateLoop:) withObject:self afterDelay:1.0/4.0];
}
-(void)setNext:(Node *)n
{
    next=n;
    if(previous==nil){
        [self setFrame:n.frame];
    }else{
        [self setFrame:[self rectUnion:previous.frame :n.frame]];
    }
}
-(void)setPrevious:(Node *)p{
    previous=p;
    if(next==nil){
        [self setFrame:p.frame];
    }else{
        [self setFrame:[self rectUnion:next.frame :p.frame]];
    }
    
}
-(void)calculateDrawParams{
    
    margin=5;

    a=[self convertPoint:CGPointMake(previous.frame.size.width+previous.frame.origin.x+margin, previous.frame.origin.y+(previous.frame.size.height/2.0)) fromView:self.superview];
    b=[self convertPoint:CGPointMake(next.frame.origin.x-margin, next.frame.origin.y+(next.frame.size.height/2.0)) fromView:self.superview];
    
    dx=(b.x-a.x);
    dy=(b.y-a.y);
    distance=sqrt(pow(dx, 2)+pow(dy, 2));
    dropRadius=MIN(100,MAX(20,distance/4.0));
    
    c=CGPointMake((a.x+b.x)/2.0, (a.y+b.y)/2.0);
    
    
    float cpLength=MIN(MAX(40.0, dx/5.0), 200);
    //if(dx<0)cpLength*=-1; //keep the sine of
    cpa=CGPointMake(a.x+cpLength, a.y);
    cpb=CGPointMake(b.x-cpLength, b.y);
    
    cpca=c;
    cpcb=c;
    self.pathColor=[UIColor darkGrayColor];
    

}

-(void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self calculateDrawParams];
    
    
    if(hovering){
        [self drawInsertCircleHover:context];
    }else if(droppable){
        [self drawInsertCircle:context];
    }
    
    [self drawPath:context];
   
    if(drawCtrlPoints){
        [self drawControlPoints:context];
    }
    
    [self drawEndPoints:context];
    
    [self drawMidPoint:context];

    
   
}

-(void)drawControlPoints:(CGContextRef)context{
    
    float r=1.5, d=3;
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(context, a.x, a.y);
    CGContextAddLineToPoint(context,cpa.x, cpa.y);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, b.x, b.y);
    CGContextAddLineToPoint(context,cpb.x, cpb.y);
    CGContextStrokePath(context);
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(cpa.x-r,cpa.y-r, d, d));
    CGContextAddEllipseInRect(context, CGRectMake(cpb.x-r,cpb.y-r, d, d));
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(cpca.x-r,cpca.y-r, d, d));
    CGContextAddEllipseInRect(context, CGRectMake(cpcb.x-r,cpcb.y-r, d, d));
    CGContextStrokePath(context);
    
    
    
    
}

-(void)drawInsertCircle:(CGContextRef)context{
    
    float r=dropRadius, d=r*2;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.03].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(c.x-r, c.y-r, d, d));
}

-(void)drawInsertCircleHover:(CGContextRef)context{
    
    float r=dropRadius, d=r*2;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(c.x-r, c.y-r, d, d));
   
}

-(void)drawPath:(CGContextRef)context{
    
 
    CGContextSetStrokeColorWithColor(context, self.pathColor.CGColor);
    
    
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, a.x, a.y);
    
    
    CGContextAddCurveToPoint(context, cpa.x, cpa.y, cpca.x, cpca.y, c.x, c.y);
    CGContextAddCurveToPoint(context, cpcb.x, cpcb.y, cpb.x, cpb.y, b.x, b.y);
    CGContextStrokePath(context);
    
}
-(void)drawEndPoints:(CGContextRef)context{

    float r=2.5; float d=5; //ellipse dimension for endpoint dots
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(a.x-r, a.y-r, d, d));
    CGContextFillEllipseInRect(context, CGRectMake(b.x-r, b.y-r, d, d));
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //CGContextAddEllipseInRect(context, CGRectMake(a.x-r, a.y-r, d, d));
    //CGContextAddEllipseInRect(context, CGRectMake(b.x-r, b.y-r, d, d));
    //CGContextStrokePath(context);
}

-(void)drawMidPoint:(CGContextRef)context{
    
    float r=4; float d=8; //ellipse dimension for midpoint psuedo-node
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(c.x-r, c.y-r, d, d));
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(c.x-r, c.y-r, d, d));
    CGContextStrokePath(context);
    
}






-(CGRect)rectUnion:(CGRect)rectA :(CGRect)rectB{
    
  CGRect f=CGRectUnion(CGRectMake(rectA.origin.x, rectA.origin.y, rectA.size.width, rectA.size.height), CGRectMake(rectB.origin.x, rectB.origin.y, rectB.size.width, rectB.size.height));
    f.size.height+=200;
    f.size.width+=200;
    f.origin.x-=100;
    f.origin.y-=100;

    return f;
}

-(void) needsUpdate{
    
    //[self setOpaque:false];
    //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
  
   
    [self setFrame:[self rectUnion:previous.frame :next.frame]];
    [self setNeedsDisplay];
}


-(bool)drawInsertArea:(Node *)node{
    droppable=true;
    [self setNeedsDisplay];
    return true;
}


-(void) clearInsertArea:(Node *)node{
    droppable=false;
    [self setNeedsDisplay];
}

-(bool) drawHoverArea:(Node *)node{
    hovering=true;
    [self setNeedsDisplay];
    return true;
}

-(void) clearHoverArea:(Node *)node{
    hovering=false;
    [self setNeedsDisplay];
}

-(float) distanceToHoverArea:(CGPoint)p{
    return (sqrt(pow(p.x-c.x, 2)+pow(p.y-c.y, 2))-dropRadius);
}


-(Connection *)getNextConnectionForSplit{
    return [[Connection alloc] init];
}

-(bool)connectNode:(Node *)nodeA toNode:(Node *)nodeB{


    [nodeA setOutput:self];
    [nodeB setInput:self];
    
    [self setPrevious:nodeA];
    [self setNext:nodeB];
    return true;
}

-(bool)deleteConnectionFromFlow:(Flow *)f{
    return true;
}
@end

