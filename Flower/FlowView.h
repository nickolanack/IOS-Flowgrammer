//
//  Flow.h
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionalBlock.h"



@class Junction;
@class Connection;
@class FunctionalBlock;

@interface FlowView : UIView
@property (weak, nonatomic) IBOutlet UIButton *runButton;

@property float delay;

@property (nonatomic, readonly) bool groupSelection;
@property (strong, nonatomic) id delegate;

@property (nonatomic) bool drawCtrlPoints;
@property (nonatomic) bool drawFrames;

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *description;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property bool autoSave;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *saveSpinner;

-(void)run;
-(void)setNSNumberDelay:(NSNumber *)n;


-(bool)sliceBlock:(FunctionalBlock *)n;

-(bool)addBlock:(Block *)n;
-(bool)deleteBlock:(Block *)n;


-(bool)addConnection:(Connection *)c;
-(bool)deleteConnection:(Connection *)c;

-(void)selectNode:(Block *)n;
-(void)unselectNode:(Block *)n;
-(void)groupSelectNode:(Block *)n;


-(NSArray *) getSelected;
-(NSArray *) getSelectedOffsetsFrom:(Block *)n;


-(void)dragStart:(Block *)n;
-(void)drag:(Block *)n point:(CGPoint)p;
-(void)dragEnd:(Block *)n;


-(void)prepareForAutolayout;
-(void)reactToAutolayout;


- (UIImage *)captureView;

-(NSDictionary *)save;
-(bool)restore:(NSDictionary *)state;

-(int)indexOfBlock:(Block *)block;
-(Block *)blockAtIndex:(int)index;
-(int)indexOfConnection:(Connection *)connection;
-(Connection *)connectionAtIndex:(int)index;
@end
