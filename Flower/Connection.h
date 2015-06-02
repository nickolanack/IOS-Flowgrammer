//
//  Connection.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConnectionEndPointAnchorType) {
    
    ConnectionEndPointAnchorTypeLeft = 1,
    ConnectionEndPointAnchorTypeRight = 2,
    ConnectionEndPointAnchorTypeTop = 4,
    ConnectionEndPointAnchorTypeBottom = 8,
    ConnectionEndPointAnchorTypeVariable=1+2+4,
    ConnectionEndPointAnchorTypeAny=1+2+4+8
    
};

typedef NS_ENUM(NSInteger, ConnectionEndPointStyle) {
    
    
    ConnectionEndPointStyleNone = 0,
    ConnectionEndPointStyleDot= 2,
    ConnectionEndPointStyleArrow = 4,

    
};

@class Block;
@class FlowView;
@interface Connection : UIView

@property NSString *name;

//These should actually be interactable since they don't really change
@property UIColor *connectionPathColor;
@property UIColor *activeConnnectionPathColor;
@property bool isActive;
@property UIColor *endPointColor;

@property NSArray *midPointColors;

@property CGPoint relativeConnectionPointSource;
@property CGPoint relativeConnectionPointDestination;

@property CGPoint relativeCenterPoint;

@property float controlPointRelativeDistanceFromConnection;

@property CGPoint cpsource;
@property CGPoint cpdestination;


@property CGPoint cpcentertosource;
@property CGPoint cpcentertodestination;


//these should be readonly since they update on all move events and can be calculated from above properties

@property bool isReadyForDropInsertion; //connection state, anticipating node insert
@property bool isHoveredByDroppable; //connection state, anticipating node insert and touch is currently hovering over insert target

@property CGPoint centerPoint; //center of connection path center of insert circle (droppable target)
@property float insertTargetRadius; //size of circle to draw for insertCircle (droppable target)
@property CGPoint connectionPointSource; //end of path (start)usually the center-right + margin from node
@property CGPoint connectionPointDestination; //end of path (start)usually the center-right - margin from node
@property CGPoint controlPointFromSource; //control point a for bezier curve at start of path
@property CGPoint controlPointFromDestination; //control point b for bezier curve at end of path
@property CGPoint controlPointFromCenterToSource; //control point at center back to a
@property CGPoint controlPointFromCenterToDestination; //control point at center to b

@property float controlPointLengthFromCenterToSource;
@property float controlPointLengthFromCenterToDestination;

@property CGPoint centerAlignOffsetSource;
@property CGPoint centerAlignOffsetDestination;

@property (nonatomic) ConnectionEndPointAnchorType connectionAnchorAllowedTypeSource;
@property (nonatomic) ConnectionEndPointAnchorType connectionAnchorAllowedTypeDestination;


@property ConnectionEndPointAnchorType connectionAnchorTypeSource;
@property ConnectionEndPointAnchorType connectionAnchorTypeDestination;
@property ConnectionEndPointStyle connectionEndPointDestinationStyle;



@property float connectionEndPointMargin; //distance from node (path endpoints) to start/stop path and draw connection

@property float dx;
@property float dy;
@property float distance;

@property bool drawCtrlPoints;



@property (nonatomic) Block *source;
@property (nonatomic) Block *destination;

@property (strong, nonatomic) id delegate;

-(void)needsUpdate;
-(bool)canInsertBlock:(Block *)block;
-(bool)drawInsertArea:(Block *)node;
-(bool)drawHoverArea:(Block *)node;
-(float)distanceToHoverArea:(CGPoint)p;
-(void)clearHoverArea:(Block *)node;
-(void)clearInsertArea:(Block *)node;

-(void)setMidPointColor:(UIColor *)midPointColor;

-(Connection *)getNextConnectionForSplit;

-(bool)connectNode:(Block *)a toNode:(Block *)b;
-(bool)deleteConnectionFromFlow:(FlowView *)f;


/* protected methods */
-(void)configure;
-(void)updateDrawingDimensionsBeforeRenderingPath;
-(void)calculateRelativeConnectionPointAnchors;
-(void)calculateConnectionPointAnchors;
-(void)calculateRelativeConnectionPointControlPoints;
-(void)calculateCenterControlPointsRelativeToCenter;
-(void)calculateControlPointLength;
-(void)calculateConnectionPointControlPoints;
-(void)calculateCenterPoint;
-(void)calculateCenterControlPointsLength;
-(void)drawControlPoints:(CGContextRef)context;
-(void)drawInsertCircle:(CGContextRef)context;
-(void)drawInsertCircleHover:(CGContextRef)context;
-(void)drawPath:(CGContextRef)context;
-(void)drawEndPoints:(CGContextRef)context;
-(void)drawMidPoint:(CGContextRef)context;
-(CGRect)rectUnion:(CGRect)a :(CGRect)b;

-(void)setDrawFrame:(bool)b;

-(bool)isPartOfLoop;
-(CGPoint)emptyLoopBubbleDirection;


-(NSArray *)getTargetMenuItems;

+(CGPoint)DirectionVectorForAnchorType:(ConnectionEndPointAnchorType)anchor;
+(CGPathRef)ArrowPathForAnchor:(CGPoint)point AndAnchorType:(ConnectionEndPointAnchorType)anchor;

-(void)activate:(float)delay;

-(NSDictionary *)save;

@end


