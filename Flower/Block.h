//
//  Block.h
//  
//
//  Created by Nick Blackwell on 3/9/2014.
//
//

#import <UIKit/UIKit.h>


@class FlowViewController;
@class NodeViewController;
@class FlowView;
@interface Block : UIView

@property NSString *bundleName;
@property int indexInBundle;

@property NSString *name;
@property NSString *description;

@property (nonatomic) FlowView *flow;
@property FlowViewController *flowViewController;


@property UIColor *borderColor;
@property float shadowOpacity;
@property float shadowRadius;
@property UIColor *activeBorderColor;
@property UIColor *doubleActiveBorderColor;
@property float activeShadowOpacity;
@property float activeShadowRadius;
@property UIColor *idleBackgroundColor;

-(void)configure;
-(void)addGestureRecognizers;

-(NSArray *)getConnections;
-(NSArray *)getConnectedBlocks;
-(NSArray *)getMenuItemsArray;
-(void)handleDeleteRequest;

-(bool) isAvailableForInsertion;

-(void)deleteBlockFromFlow:(FlowView *)f;

-(void)moveRelative:(CGPoint)offset;
-(void)moveToTouch: (CGPoint)location;
-(void)moveToPoint:(CGPoint)location;
-(void)declarePositionChange;



-(NSString *)getDetailNibName;
-(int)getDetailNibIndex;
-(void)displayDetailView;
-(void)displayDetailView:(NSString *)nib atIndex:(int)i;
-(void)configureDetialViewController:(NodeViewController *)vc;

-(bool)displaysDetailViewInPopover;
-(CGSize)detailViewPopoverSize;


@property (nonatomic) bool isDraggable;
@property (nonatomic) bool isDoubleSelected;
@property (nonatomic) bool isSelected;
@property bool draggingEnabled;


@property (readonly) CGPoint touchOffset;
@property (readonly) NSArray *selection;
@property (readonly) NSArray *selectionOffsets;

-(void)deleteBlock;

-(NSDictionary *)save;
-(bool)restore:(NSDictionary *) state;

-(void)moveCenterToPoint:(CGPoint)p;

-(int)indexInFlow;

+(Block *)InstantiateWithBundle:(NSString *)bundle andIndex:(int)index andOwner:(id) owner;

@end
