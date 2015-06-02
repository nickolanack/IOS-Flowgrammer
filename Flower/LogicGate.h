//
//  LogicGate.h
//  Flower
//
//  Created by Nick Blackwell on 2014-04-09.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "ProcessorBlock.h"
#import "BooleanVariable.h"

@interface LogicGate : ProcessorBlock

/*!
 * @brief the blocks label, by default this is the name of the block, ie: 'not gate',  'or gate', ...
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

/*!
 * @brief Pixel offset describing how much the blocks boundary is inset from the view boundary, this is used to align connections with the objects input positions
 */
@property float inset;

/*!
 * @brief Defines the Logic blocks outer path for rendering
 */
@property CGPathRef path;

/*!
 * @brief Point A, usually defines the top left corner of the block (right pointing triangle).
 */
@property CGPoint pa;

/*!
 * @brief Point B, usually defines the center right corner of the block (right pointing triangle).
 */
@property CGPoint pb;

/*!
 * @brief Point C, usually defines the blocks bottom left corner of the block (right pointing triangle).
 */
@property CGPoint pc;

-(void)drawConnections:(CGContextRef)c;


-(CGPathRef)getPath;
-(bool)evaluate;
@end
