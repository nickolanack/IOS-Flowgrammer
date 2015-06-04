//
//  Connection.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Connection.h"
#import "ProcessorBlock.h"
#import "ThreadStartBlock.h"
#import "FlowView.h"
#import <QuartzCore/QuartzCore.h>




@interface Connection()

//points and control points relative to the source and destination

@property float f_y;
@property float f_x;

@end



@implementation Connection

@synthesize source, destination, name, delegate, connectionPointSource, connectionPointDestination, centerPoint, controlPointFromSource, dx, dy, controlPointFromDestination, controlPointFromCenterToSource, controlPointFromCenterToDestination, isReadyForDropInsertion, isHoveredByDroppable, insertTargetRadius, connectionEndPointMargin, connectionPathColor, distance, drawCtrlPoints, connectionAnchorTypeSource, connectionAnchorTypeDestination, centerAlignOffsetSource, centerAlignOffsetDestination, connectionEndPointDestinationStyle, relativeConnectionPointSource, relativeConnectionPointDestination, cpsource, cpdestination, cpcentertosource, cpcentertodestination, relativeCenterPoint, controlPointRelativeDistanceFromConnection, controlPointLengthFromCenterToSource, controlPointLengthFromCenterToDestination, endPointColor, connectionAnchorAllowedTypeDestination, connectionAnchorAllowedTypeSource, midPointColors;

-(id)init{

    self=[super init];
    if(self){
    
        [self setBackgroundColor:[UIColor clearColor]];
        [self configure];
        //[self performSelector:@selector(updateLoop:) withObject:self afterDelay:1.0/4.0];
    
        //drawCtrlPoints=true;
        
    }
    return self;
}

-(void)configure{
    
    connectionEndPointMargin=5;
    connectionPathColor=[UIColor darkGrayColor];
    endPointColor=[UIColor blackColor];
    self.activeConnnectionPathColor=[UIColor greenColor];
    [self setName:@"connection"];
    connectionAnchorTypeSource=ConnectionEndPointAnchorTypeRight;
    connectionAnchorTypeDestination=ConnectionEndPointAnchorTypeLeft;
    connectionEndPointDestinationStyle=ConnectionEndPointStyleArrow;
    
    midPointColors=@[[UIColor whiteColor]];
    
    centerAlignOffsetDestination=CGPointZero;
    centerAlignOffsetSource=CGPointZero;
    relativeCenterPoint=CGPointZero;
    
}

-(void)setMidPointColor:(UIColor *)midPointColor{
    midPointColors=@[midPointColor];
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

#pragma mark Dimensions

-(void)updateFrame:(CGRect)frame{
    
    _f_x=frame.origin.x;
    _f_y=frame.origin.y;
    
    [super setFrame:frame];
}
//setFrame is usually ignored
-(void)setFrame:(CGRect)frame{
    if(_f_x!=frame.origin.x&&_f_y!=frame.origin.y)return;
    [super setFrame:frame];
}

-(CGRect)rectUnion:(CGRect)rectA :(CGRect)rectB{
    
    bool isA=!CGRectIsEmpty(rectA);
    bool isB=!CGRectIsEmpty(rectB);
    
    if((isA||isB)&&!(isA&&isB)){
        if(isA){
            rectB=rectA;
        }
        if(isB){
            rectA=rectB;
        }
    }
    
    CGRect f=CGRectUnion(CGRectMake(rectA.origin.x, rectA.origin.y, rectA.size.width, rectA.size.height), CGRectMake(rectB.origin.x, rectB.origin.y, rectB.size.width, rectB.size.height));
    f.size.height+=200;
    f.size.width+=200;
    f.origin.x-=100;
    f.origin.y-=100;
    
    return f;
}

-(void)setDestination:(ProcessorBlock *)n
{
    destination=n;
    if(source==nil){
        [self updateFrame:n.frame];
    }else{
        [self updateFrame:[self rectUnion:source.frame :n.frame]];
    }
}

-(void)setSource:(ProcessorBlock *)p{
    source=p;
    if(destination==nil){
        [self updateFrame:p.frame];
    }else{
        [self updateFrame:[self rectUnion:destination.frame :p.frame]];
    }
}

-(void) needsUpdate{
    
    //[self setOpaque:false];
    //[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];

    [self updateFrame:[self rectUnion:source.frame :destination.frame]];
    [self setNeedsDisplay];
}

-(bool) canInsertBlock:(Block *)block{
    if([block isKindOfClass:[FunctionalBlock class]])return true;
    return false;
}

-(bool)drawInsertArea:(ProcessorBlock *)node{
    isReadyForDropInsertion=true;
    [self setNeedsDisplay];
    return true;
}


-(void) clearInsertArea:(ProcessorBlock *)node{
    isReadyForDropInsertion=false;
    [self setNeedsDisplay];
}

-(bool) drawHoverArea:(ProcessorBlock *)node{
    isHoveredByDroppable=true;
    [self setNeedsDisplay];
    return true;
}

-(void) clearHoverArea:(ProcessorBlock *)node{
    isHoveredByDroppable=false;
    [self setNeedsDisplay];
}

-(float) distanceToHoverArea:(CGPoint)p{
    return (sqrt(pow(p.x-centerPoint.x, 2)+pow(p.y-centerPoint.y, 2))-insertTargetRadius);
}


-(bool)insertBlock:(Block *)n{
    
    Block *next=self.destination;
    
    if(self.source!=nil){
        [self connectNode:self.source toNode:n];
    }
    
    FlowView *flow=self.source.flow;
    
    if(next!=nil){
        Connection *nextCon;
        if(self.source==nil){
            nextCon=self;
        }else{
            nextCon=[self createConnectionForInsertingBlock];
            if(n.flow!=nil){
                [flow addConnection:nextCon];
            }
        }
        
        [nextCon connectNode:n toNode:next];
        [nextCon needsUpdate];
    }else{
        [self connectNode:self.source toNode:n];
    }
    
    [self needsUpdate];
    
    
    return true;
    
}

-(Connection *)createConnectionForInsertingBlock{
    return [[Connection alloc] init];
}

-(bool)connectNode:(Block *)newSource toNode:(Block *)newDest{
    
    if([newSource isKindOfClass:[FunctionalBlock class]]&&[newDest isKindOfClass:[FunctionalBlock class]]){
        
        FunctionalBlock *sourceFn=(FunctionalBlock *)newSource;
        FunctionalBlock *destFn=(FunctionalBlock *)newDest;
        
        [sourceFn setPrimaryOutputConnection:self];
        [destFn setPrimaryInputConnection:self];
        
        [self setSource:sourceFn];
        [self setDestination:newDest];
        
        [sourceFn notifyOutputConnectionStateDidChange];
        [destFn notifyInputConnectionStateDidChange];
        
        return true;
    }else{
        if([newSource isKindOfClass:[ThreadStartBlock class]]&&newDest==nil){
            [(ThreadStartBlock *)newSource setPrimaryOutputConnection:self];
            [self setSource:newSource];
            return true;
        }
    
    }
    return false;
}

-(bool)deleteConnectionFromFlow:(FlowView *)f{
    return true;
}


-(void)activate:(float)delay{
    if(self.isActive)return;
    self.isActive=true;
    
    double delayInSeconds = MAX(delay,0.05);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.isActive=false;
        [self needsUpdate];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self needsUpdate];
    });
    
    
}



#pragma mark Rendering Calculations
-(void)calculateRelativeConnectionPointAnchors{
    
    relativeConnectionPointSource=[Connection BlockPosition:self.source WithStyle:self.connectionAnchorTypeSource Margin:connectionEndPointMargin AndOffset:centerAlignOffsetSource];
    relativeConnectionPointDestination=[Connection BlockPosition:self.destination WithStyle:self.connectionAnchorTypeDestination Margin:connectionEndPointMargin AndOffset:centerAlignOffsetDestination];

}


-(void)calculateCenterPoint{
    
    CGPoint endTypeOffset=CGPointZero;
    
    
    if([Connection ConnectedByEdges:self]){
        
        float l=controlPointRelativeDistanceFromConnection*2;
        float b=M_PI_2;
        float a=dx==0?(dy>0?-b:b):atan(dy/dx);
        
        if(self.connectionAnchorTypeSource==ConnectionEndPointAnchorTypeBottom){
      
            endTypeOffset=CGPointMake(cos(a+b)*l, sin(a+b)*l);
            
        }
        if(self.connectionAnchorTypeSource==ConnectionEndPointAnchorTypeTop){
            endTypeOffset=CGPointMake(-cos(a+b)*l, -sin(a+b)*l);
        }

        
        
        
        
        if(self.connectionAnchorTypeSource==ConnectionEndPointAnchorTypeLeft){
            
            if(dx<=0)b*=-1;
            if(dy<0)b*=-1;
            
            endTypeOffset=CGPointMake(cos(a+b)*l, sin(a+b)*l);
            
        }
        if(self.connectionAnchorTypeSource==ConnectionEndPointAnchorTypeRight){
            if((dx<0&&dy<0)||(dx>0&&dy>0))b*=-1;
            endTypeOffset=CGPointMake(cos(a+b)*l, sin(a+b)*l);
            
        }
    
    }else if([self isPartOfLoop]&&[self isEmptyLoop]){
        CGPoint p=[Connection EmptyLoopCenterOffset:self WidthLength:60];
        endTypeOffset.x+=p.x;
        endTypeOffset.y+=p.y;
    
    
    }else if([Connection ConnectedByAdjacents:self]&&[Connection ControlPointsIntersectAtCorner:self withDx:dx andDy:dy]){
    
         float sign=[Connection ConnectionTypeIsHorizontal:self.connectionAnchorTypeDestination]?1:-1;
        
        if(ABS(dx)>=ABS(dy)){
            
            endTypeOffset.y+=sign*(connectionPointDestination.y-connectionPointSource.y)/2.0;
        
        }else{
            
            endTypeOffset.x+=-sign*(connectionPointDestination.x-connectionPointSource.x)/2.0;
        
        }
        
    
    }
    
    
    centerPoint=CGPointMake((connectionPointSource.x+connectionPointDestination.x)/2.0+relativeCenterPoint.x+endTypeOffset.x, (connectionPointSource.y+connectionPointDestination.y)/2.0+relativeCenterPoint.y+endTypeOffset.y);
}

-(void) calculateControlPointLength{
    if([self isPartOfLoop]&&[self isEmptyLoop]){
        controlPointRelativeDistanceFromConnection=20;
    }else{
        controlPointRelativeDistanceFromConnection=ABS(dx)/7.0+ABS(dy)/12.0;
        if([Connection ConnectedByEdges:self]){
            controlPointRelativeDistanceFromConnection=MAX(10,ABS(dx)/3.0+ABS(dy)/5.0);
        }
    }
}

-(void)calculateRelativeConnectionPointControlPoints{
    
    cpsource=[Connection BlockControlPointPosition:self.source WithConnectionPoint:relativeConnectionPointSource Length:controlPointRelativeDistanceFromConnection AndOffset:centerAlignOffsetSource];
    
    cpdestination=[Connection BlockControlPointPosition:self.destination WithConnectionPoint:relativeConnectionPointDestination Length:controlPointRelativeDistanceFromConnection AndOffset:centerAlignOffsetDestination];
    
    
}

-(NSArray *)getTargetMenuItems{
    return nil;
}

-(void)calculateCenterControlPointsLength{
    
    if([self isPartOfLoop]&&[self isEmptyLoop]){
        
        controlPointLengthFromCenterToSource=20;
        controlPointLengthFromCenterToDestination=20;
        
    }else if([Connection ConnectedByEdges:self]){
        
        controlPointLengthFromCenterToSource=distance/3.0;
        controlPointLengthFromCenterToDestination=distance/3.0;
        
    }else{
        
        controlPointLengthFromCenterToSource=distance/5.0;
        controlPointLengthFromCenterToDestination=distance/5.0;
        
    }
    
    
}

-(void)calculateCenterControlPointsRelativeToCenter{

    [self calculateCenterControlPointsLength];
    
    float sign=1;
    
    
    float dcpx=controlPointFromDestination.x-controlPointFromSource.x;
    float dcpy=controlPointFromDestination.y-controlPointFromSource.y;
    
   
    //calculate center control points to destination.
    
    if(controlPointLengthFromCenterToDestination<=0){
        cpcentertodestination=CGPointZero;
    }else{
        
       
        
        if([Connection ConnectedByAdjacents:self]&&[Connection ControlPointsIntersectAtCorner:self withDx:dx andDy:dy]){
        
            if(ABS(dx)>=ABS(dy)){
                cpcentertodestination=CGPointMake(sign*2.5*dcpx*(controlPointLengthFromCenterToDestination/distance), 0);
            }else{
                cpcentertodestination=CGPointMake(0, sign*2.5*dcpy*(controlPointLengthFromCenterToDestination/distance));
            }
        }else{
       
            cpcentertodestination=CGPointMake(sign*dcpx*(controlPointLengthFromCenterToDestination/distance), sign*dcpy*(controlPointLengthFromCenterToDestination/distance));
        }
        
        
    }
    
    
    //calculate center control points to source.
    
    if(controlPointLengthFromCenterToSource<=0){
        cpcentertosource=CGPointZero;
    }else{
        if([Connection ConnectedByAdjacents:self]&&[Connection ControlPointsIntersectAtCorner:self withDx:dx andDy:dy]){
            if(ABS(dx)>=ABS(dy)){
                cpcentertosource=CGPointMake(-sign*2.5*dcpx*(controlPointLengthFromCenterToSource/distance), 0);
            }else{
                cpcentertosource=CGPointMake(0, -sign*2.5*dcpy*(controlPointLengthFromCenterToSource/distance));
            }
        }else{
        cpcentertosource=CGPointMake(-sign*dcpx*(controlPointLengthFromCenterToSource/distance), -sign*dcpy*(controlPointLengthFromCenterToSource/distance));
        }
    }
    

}
+(bool) ControlPointsIntersectAtCorner:(Connection *)c withDx:(float)dx andDy:(float)dy{

    ConnectionEndPointAnchorType t=c.connectionAnchorTypeSource;
    
    switch(t){
        case ConnectionEndPointAnchorTypeLeft:
            if(c.connectionAnchorTypeDestination==ConnectionEndPointAnchorTypeTop){
                if(dx<0&&dy>0)return true;
                return false;
            }else{
                if(dx<0&&dy<0)return true;
                return false;
            }
            break;
        case ConnectionEndPointAnchorTypeRight:
            if(c.connectionAnchorTypeDestination==ConnectionEndPointAnchorTypeTop){
                if(dx>0&&dy>0)return true;
                return false;
            }else{
                if(dx>0&&dy<0)return true;
                return false;
            }
            break;
        case ConnectionEndPointAnchorTypeTop:
            if(c.connectionAnchorTypeDestination==ConnectionEndPointAnchorTypeLeft){
                if(dx>0&&dy<0)return true;
                return false;
            }else{
                if(dx<0&&dy<0)return true;
                return false;
            }
            break;
        case ConnectionEndPointAnchorTypeBottom:
            if(c.connectionAnchorTypeDestination==ConnectionEndPointAnchorTypeLeft){
                if(dx>0&&dy>0)return true;
                return false;
            }else{
                if(dx<0&&dy>0)return true;
                return false;
            }
            break;
        default:
            break;
            
            
    
    }
    @throw [[NSException alloc] initWithName:@"Invalid Connection Type Source" reason:@"Expected Source Connection to be distinct" userInfo:nil];
}



-(CGPoint) getSourcePoint{
    if(self.source==nil){
        if(self.destination==nil){
            @throw [[NSException alloc] initWithName:@"NoCoordinatesConnected" reason:@"Attempted to get coordinates on disconnected connection" userInfo:nil];
        }
        
    }
    return [self.source.flow convertPoint:connectionPointSource fromCoordinateSpace:self];
}
-(CGPoint) getDestinationPoint{
    if(self.destination==nil){
        return [self getSourcePoint];
    }
    return [self.destination.flow convertPoint:connectionPointDestination fromCoordinateSpace:self];
}

-(CGPoint) getCenterPoint{
    if(self.destination==nil){
        return [self getSourcePoint];
    }
    return [self.source.flow convertPoint:centerPoint fromCoordinateSpace:self];
}


-(void)calculateConnectionPointAnchors{
    connectionPointSource=[self convertPoint:relativeConnectionPointSource fromView:self.source];
    connectionPointDestination=[self convertPoint:relativeConnectionPointDestination fromView:self.destination];
}

-(void)calculateConnectionPointControlPoints{
    controlPointFromSource=[self convertPoint:cpsource fromView:self.source];
    controlPointFromDestination=[self convertPoint:cpdestination fromView:self.destination];
}

-(void)updateDrawingDimensionsBeforeRenderingPath{
    
    [self calculateRelativeConnectionPointAnchors]; //can be optimized to only run when style, end blocks, and margin changes
    [self calculateConnectionPointAnchors];
    
    
    dx=(connectionPointDestination.x-connectionPointSource.x);
    dy=(connectionPointDestination.y-connectionPointSource.y);
    
    distance=sqrt(pow(dx, 2)+pow(dy, 2));
    
    insertTargetRadius=MIN(100,MAX(20,distance/4.0));
    
    [self calculateControlPointLength];
    [self calculateCenterPoint];
    
    [self calculateRelativeConnectionPointControlPoints];
    [self calculateConnectionPointControlPoints];
    
    [self calculateCenterControlPointsRelativeToCenter];
    
   
    
    controlPointFromCenterToSource=CGPointMake(centerPoint.x+cpcentertosource.x, centerPoint.y+cpcentertosource.y);
    controlPointFromCenterToDestination=CGPointMake(centerPoint.x+cpcentertodestination.x, centerPoint.y+cpcentertodestination.y);

}

-(void)updateEndPointConnectionTypes{
    
    if(self.source!=nil&&self.destination!=nil){
    
        
        ConnectionEndPointAnchorType allowedType=connectionAnchorAllowedTypeSource;
        Block *oppositeBlock=self.destination;
        Block *current=self.source;
        
        if(allowedType!=0){
           ConnectionEndPointAnchorType currentType=connectionAnchorTypeSource;
            
            
            CGPoint sCenter=oppositeBlock.center;
            
            CGPoint currentAnchor=[self.superview convertPoint:[Connection BlockPosition:current WithStyle:currentType Margin:connectionEndPointMargin AndOffset:CGPointZero] fromView:current];
            
            float d=sqrtf(pow((currentAnchor.x-sCenter.x),2) + pow((currentAnchor.y-sCenter.y),2));
            
           
            
            
            ConnectionEndPointAnchorType types[]={ConnectionEndPointAnchorTypeTop, ConnectionEndPointAnchorTypeBottom, ConnectionEndPointAnchorTypeLeft, ConnectionEndPointAnchorTypeRight};
            
            for(int i=0;i<4;i++){
                ConnectionEndPointAnchorType type=types[i];
                if((type&allowedType)&&currentType!=type){
                    
                    CGPoint rel=[Connection BlockPosition:current WithStyle:type Margin:connectionEndPointMargin AndOffset:CGPointZero];
                    CGPoint anchor=[self.superview convertPoint:rel fromView:current];
                
              
                    
                    float f=sqrtf(pow((anchor.x-sCenter.x),2) + pow((anchor.y-sCenter.y),2));
                    if(f<d){
                        currentType=type;
                        d=f;
                        
                    }
                }
            
            
            }
             self.connectionAnchorTypeSource=currentType;
            
        }
        
        
        allowedType=connectionAnchorAllowedTypeDestination;
        oppositeBlock=self.source;
        current=self.destination;
        if(allowedType!=0){
            
            ConnectionEndPointAnchorType currentType=connectionAnchorTypeDestination;
            
            
            CGPoint sCenter=oppositeBlock.center;
            
            CGPoint currentAnchor=[self.superview convertPoint:[Connection BlockPosition:current WithStyle:currentType Margin:connectionEndPointMargin AndOffset:CGPointZero] fromView:current];
            
            float d=sqrtf(pow((currentAnchor.x-sCenter.x),2) + pow((currentAnchor.y-sCenter.y),2));
            
            
            
            
            ConnectionEndPointAnchorType types[]={ConnectionEndPointAnchorTypeTop, ConnectionEndPointAnchorTypeBottom, ConnectionEndPointAnchorTypeLeft, ConnectionEndPointAnchorTypeRight};
            
            for(int i=0;i<4;i++){
                ConnectionEndPointAnchorType type=types[i];
                if((type&allowedType)&&currentType!=type){
                    
                    CGPoint rel=[Connection BlockPosition:current WithStyle:type Margin:connectionEndPointMargin AndOffset:CGPointZero];
                    CGPoint anchor=[self.superview convertPoint:rel fromView:current];
                    
                    
                    
                    float f=sqrtf(pow((anchor.x-sCenter.x),2) + pow((anchor.y-sCenter.y),2));
                    if(f<d){
                        currentType=type;
                        d=f;
                        
                    }
                }
                
                
            }
            self.connectionAnchorTypeDestination=currentType;

        }
        
        
    }

}


#pragma mark Rendering
-(void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self updateEndPointConnectionTypes];
    
    [self updateDrawingDimensionsBeforeRenderingPath];
    
    
    if(isHoveredByDroppable){
        [self drawInsertCircleHover:context];
    }else if(isReadyForDropInsertion){
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
    CGContextMoveToPoint(context, connectionPointSource.x, connectionPointSource.y);
    CGContextAddLineToPoint(context,controlPointFromSource.x, controlPointFromSource.y);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, connectionPointDestination.x, connectionPointDestination.y);
    CGContextAddLineToPoint(context,controlPointFromDestination.x, controlPointFromDestination.y);
    CGContextStrokePath(context);
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor magentaColor].CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(controlPointFromSource.x-r,controlPointFromSource.y-r, d, d));
    CGContextAddEllipseInRect(context, CGRectMake(controlPointFromDestination.x-r,controlPointFromDestination.y-r, d, d));
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
    CGContextAddEllipseInRect(context, CGRectMake(controlPointFromCenterToSource.x-r,controlPointFromCenterToSource.y-r, d, d));
    CGContextAddEllipseInRect(context, CGRectMake(controlPointFromCenterToDestination.x-r,controlPointFromCenterToDestination.y-r, d, d));
    CGContextStrokePath(context);
    
}

-(void)drawInsertCircle:(CGContextRef)context{
    
    float r=insertTargetRadius, d=r*2;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.03].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x-r, centerPoint.y-r, d, d));
}

-(void)drawInsertCircleHover:(CGContextRef)context{
    
    float r=insertTargetRadius, d=r*2;
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x-r, centerPoint.y-r, d, d));
   
}

-(void)drawPath:(CGContextRef)context{
    if(self.isActive){
         CGContextSetStrokeColorWithColor(context, self.activeConnnectionPathColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, self.connectionPathColor.CGColor);
    }
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, connectionPointSource.x, connectionPointSource.y);
    
    CGContextAddCurveToPoint(context, controlPointFromSource.x, controlPointFromSource.y, controlPointFromCenterToSource.x, controlPointFromCenterToSource.y, centerPoint.x, centerPoint.y);
    CGContextAddCurveToPoint(context, controlPointFromCenterToDestination.x, controlPointFromCenterToDestination.y, controlPointFromDestination.x, controlPointFromDestination.y, connectionPointDestination.x, connectionPointDestination.y);
    CGContextStrokePath(context);
    
}
-(void)drawEndPoints:(CGContextRef)context{
    float r=2.5; float d=5;
    if(self.distance<20){
        
        r=2.5*distance/20.0;
        d=2*r;
    
    }
     //ellipse dimension for endpoint dots
    CGContextSetFillColorWithColor(context, self.endPointColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(connectionPointSource.x-r, connectionPointSource.y-r, d, d));
    
    if(connectionEndPointDestinationStyle==ConnectionEndPointStyleDot){
        CGContextFillEllipseInRect(context, CGRectMake(connectionPointDestination.x-r, connectionPointDestination.y-r, d, d));
    }
    if(connectionEndPointDestinationStyle==ConnectionEndPointStyleArrow){
        
        CGContextAddPath(context, [Connection ArrowPathForAnchor:connectionPointDestination AndAnchorType:connectionAnchorTypeDestination]);
        CGContextClosePath(context);
        CGContextFillPath(context);
    }
    
    //CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    //CGContextAddEllipseInRect(context, CGRectMake(a.x-r, a.y-r, d, d));
    //CGContextAddEllipseInRect(context, CGRectMake(b.x-r, b.y-r, d, d));
    //CGContextStrokePath(context);
}
-(bool)shouldDrawMidPoint{
    return true;
}
-(void)drawMidPoint:(CGContextRef)context{
    
    if([self shouldDrawMidPoint]){
        UIColor *midPointColor=[midPointColors objectAtIndex:0];
        float r=4; float d=8; //ellipse dimension for midpoint psuedo-node
        
        if(midPointColors.count==1){
            CGContextSetFillColorWithColor(context, midPointColor.CGColor);
            CGContextFillEllipseInRect(context, CGRectMake(centerPoint.x-r, centerPoint.y-r, d, d));
        }else{
            
            UIColor *midPointColor=[midPointColors objectAtIndex:0];
            CGContextSetFillColorWithColor(context, midPointColor.CGColor);
            CGContextAddArc(context, centerPoint.x, centerPoint.y, r, M_PI_2, -M_PI_2, 0);
            CGContextFillPath(context);
            
            midPointColor=[midPointColors objectAtIndex:1];
            CGContextSetFillColorWithColor(context, midPointColor.CGColor);
            CGContextAddArc(context, centerPoint.x, centerPoint.y, r, M_PI_2, -M_PI_2, 1);
            CGContextFillPath(context);
            
        }
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x-r, centerPoint.y-r, d, d));
        CGContextStrokePath(context);
    }
    
    
}





#pragma mark Loops
-(bool)isPartOfLoop{
    return false;
}

-(Block *)loopControlBlock{
    return nil;
}

-(bool)isEmptyLoop{
   return (self.source==self.destination&&self.source!=nil);
}

//an empty loop needs to bubble out or it will be hidden by they block
-(CGPoint)emptyLoopBubbleDirection{
    return CGPointMake(1, -1);
}


#pragma mark Static Methods
+(CGPoint)BlockPosition:(Block *)block WithStyle:(ConnectionEndPointAnchorType)style Margin:(float)margin AndOffset:(CGPoint)offset{

    switch(style){
        case ConnectionEndPointAnchorTypeLeft:
            return CGPointMake(-margin+offset.x, block.frame.size.height/2.0+offset.y);
            break;
        case ConnectionEndPointAnchorTypeRight:
            return CGPointMake(block.frame.size.width+margin+offset.x, block.frame.size.height/2.0+offset.y);
            break;
        case ConnectionEndPointAnchorTypeTop:
            return CGPointMake(block.frame.size.width/2.0+offset.x, -margin+offset.y);
            break;
        case ConnectionEndPointAnchorTypeBottom:
            return CGPointMake(block.frame.size.width/2.0+offset.x, block.frame.size.height+margin+offset.y);
            break;
        default:
            @throw [[NSException alloc] initWithName:@"Invalid Connection Type" reason:@"Connection Type must not be ambiguous" userInfo:nil];
            break;
            
    }
    
    
    return CGPointZero;
}

+(CGPoint)BlockControlPointPosition:(Block *)block WithConnectionPoint:(CGPoint)c Length:(float)l AndOffset:(CGPoint)offset{
    
    CGPoint center=CGPointMake(block.frame.size.width/2.0+offset.x, block.frame.size.height/2.0+offset.y);
    if(c.x==center.x){
        return CGPointMake(c.x, c.y+(l*(c.y>center.y?1:-1)));
    }
    
    if(c.y==center.y){
        return CGPointMake(c.x+(l*(c.x>center.x?1:-1)), c.y);
    }
    
    float angle=atan((c.y-center.y)/(c.x-center.x));
    return CGPointMake(c.x+l*cos(angle), c.y+l*sin(angle));
    
}              


+(CGPoint)DirectionVectorForAnchorType:(ConnectionEndPointAnchorType)anchor{

    
    switch(anchor){
            
        case ConnectionEndPointAnchorTypeBottom:
            return CGPointMake(0, 1);
            break;
        case ConnectionEndPointAnchorTypeLeft:
            return CGPointMake(-1, 0);
            break;
        case ConnectionEndPointAnchorTypeRight:
            return CGPointMake(1, 0);
            break;
        case ConnectionEndPointAnchorTypeTop:
            return CGPointMake(0, -1);
            break;
            
        default:
            @throw [[NSException alloc] initWithName:@"Invalid Connection Type" reason:@"Connection Type must not be ambiguous" userInfo:nil];
            break;
    }
    
    
    return CGPointZero;
}

+(CGPathRef)ArrowPathForAnchor:(CGPoint)point AndAnchorType:(ConnectionEndPointAnchorType)anchor{

    CGMutablePathRef path = CGPathCreateMutable();
   
    float l=3;
    switch(anchor){
    
        case ConnectionEndPointAnchorTypeBottom:
            
            CGPathMoveToPoint(path, nil, point.x-l, point.y+l);
            CGPathAddLineToPoint(path, nil, point.x, point.y-l);
            CGPathAddLineToPoint(path, nil, point.x+l, point.y+l);
            
            break;
        case ConnectionEndPointAnchorTypeLeft:
            
            CGPathMoveToPoint(path, nil, point.x-l, point.y-l);
            CGPathAddLineToPoint(path, nil, point.x+l, point.y);
            CGPathAddLineToPoint(path, nil, point.x-l, point.y+l);
            
            break;
        case ConnectionEndPointAnchorTypeRight:
            
            CGPathMoveToPoint(path, nil, point.x+l, point.y-l);
            CGPathAddLineToPoint(path, nil, point.x-l, point.y);
            CGPathAddLineToPoint(path, nil, point.x+l, point.y+l);
            
            break;
        case ConnectionEndPointAnchorTypeTop:
            
            CGPathMoveToPoint(path, nil, point.x-l, point.y-l);
            CGPathAddLineToPoint(path, nil, point.x, point.y+l);
            CGPathAddLineToPoint(path, nil, point.x+l, point.y-l);
            
            break;
        default:
            @throw [[NSException alloc] initWithName:@"Invalid Connection Type" reason:@"Connection Type must not be ambiguous" userInfo:nil];
            break;
            
    }
    
    
    return CGPathCreateCopy(path);
}

+(bool)PointsDown:(Connection *)c{
    return c.dy>0?true:false;
}
+(bool)PointsUp:(Connection *)c{
    return c.dy<=0?true:false;
}

+(bool)PointsRight:(Connection *)c{
    return c.dx>0?true:false;
}
+(bool)PointsLeft:(Connection *)c{
    return c.dx<=0?true:false;
}

+(bool)ConnectedByEdges:(Connection *)c{
    return (c.connectionAnchorTypeSource==c.connectionAnchorTypeDestination);
}
+(bool)ConnectedByAdjacents:(Connection *)c{
    return ((![Connection ConnectedVertically:c])&&(![Connection ConnectedHorizontally:c])&&
            (![Connection ConnectedByEdges:c]));
}
+(bool)ConnectionTypeIsVertical:(ConnectionEndPointAnchorType)type{
    return (type==ConnectionEndPointAnchorTypeTop||type==ConnectionEndPointAnchorTypeBottom);
}

+(bool)ConnectionTypeIsHorizontal:(ConnectionEndPointAnchorType)type{
    return (type==ConnectionEndPointAnchorTypeLeft||type==ConnectionEndPointAnchorTypeRight);
}

+(bool)ConnectsWithoughMovingCenter:(Connection *)c{
    return [Connection ConnectedVertically:c]||[Connection ConnectedHorizontally:c];
}
+(bool)ConnectedVertically:(Connection *)c{
    return([Connection ConnectionTypeIsVertical:c.connectionAnchorTypeSource]&&[Connection ConnectionTypeIsVertical:c.connectionAnchorTypeDestination]);
}

+(bool)ConnectedHorizontally:(Connection *)c{
    return([Connection ConnectionTypeIsHorizontal:c.connectionAnchorTypeSource]&&[Connection ConnectionTypeIsHorizontal:c.connectionAnchorTypeDestination]);
}
+(CGPoint)EmptyLoopCenterOffset:(Connection *)c WidthLength:(float)d{

    
    CGPoint p=[c emptyLoopBubbleDirection];
    if([c isPartOfLoop]&&[c isEmptyLoop]){
        
        if([Connection ConnectedHorizontally:c]){
            
            return CGPointMake(0, p.y*d);
            
            
        }
        
        if([Connection ConnectedVertically:c]){
            
            return CGPointMake(p.x*d, 0);
            
        }

        return CGPointMake(p.x*d, p.y*d);
        
        
    }else{
        return CGPointZero;
    }

}


-(NSDictionary *)save{

    return @{
             
                @"source":[NSNumber numberWithInt:self.source!=nil?[self.source indexInFlow]:NSNotFound],
                @"destination":[NSNumber numberWithInt:self.destination!=nil?[self.destination indexInFlow]:NSNotFound]
                
            };

}

@end