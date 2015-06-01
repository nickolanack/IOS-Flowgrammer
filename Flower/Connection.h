//
//  Connection.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Node;
@class Flow;
@interface Connection : UIView





@property bool droppable; //connection state, anticipating node insert
@property bool hovering; //connection state, anticipating node insert and touch is currently hovering over insert target
@property CGPoint c; //center of connection path center of insert circle (droppable target)
@property float dropRadius; //size of circle to draw for insertCircle (droppable target)
@property CGPoint a; //end of path (start)usually the center-right + margin from node
@property CGPoint b; //end of path (start)usually the center-right - margin from node
@property CGPoint cpa; //control point a for bezier curve at start of path
@property CGPoint cpb; //control point b for bezier curve at end of path
@property CGPoint cpca; //control point at center back to a
@property CGPoint cpcb; //control point at center to b

@property UIColor *pathColor;


@property float margin; //distance from node (path endpoints) to start/stop path and draw connection

@property float dx;
@property float dy;
@property float distance;

@property bool drawCtrlPoints;



@property (nonatomic) Node *previous;
@property (nonatomic) Node *next;

@property (strong, nonatomic) id delegate;

-(void) needsUpdate;
-(bool) drawInsertArea:(Node *)node;
-(bool) drawHoverArea:(Node *)node;
-(float) distanceToHoverArea:(CGPoint)p;
-(void) clearHoverArea:(Node *)node;
-(void) clearInsertArea:(Node *)node;


-(Connection *)getNextConnectionForSplit;

-(bool)connectNode:(Node *)a toNode:(Node *)b;
-(bool)deleteConnectionFromFlow:(Flow *)f;


/* protected methods */


-(void)calculateDrawParams;
-(void)drawControlPoints:(CGContextRef)context;
-(void)drawInsertCircle:(CGContextRef)context;
-(void)drawInsertCircleHover:(CGContextRef)context;
-(void)drawPath:(CGContextRef)context;
-(void)drawEndPoints:(CGContextRef)context;
-(void)drawMidPoint:(CGContextRef)context;
-(CGRect)rectUnion:(CGRect)a :(CGRect)b;





-(void)setDrawFrame:(bool)b;
@end


