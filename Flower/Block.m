//
//  Block.m
//  
//
//  Created by Nick Blackwell on 3/9/2014.
//
//

#import "Block.h"
#import "Connection.h"
#import "FlowView.h"
#import "NodeViewController.h"
#import "FlowViewController.h"
#import "ScriptBlock.h"
@interface Block()

@end
@implementation Block
@synthesize flow, isSelected, isDoubleSelected, isDraggable, name, flowViewController, description, touchOffset, selection, selectionOffsets, idleBackgroundColor, bundleName, indexInBundle;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        [self configure];
        //[self addGestureRecognizers];
        return self;
    }
    return nil;
    
}

-(void)configure{
    
    self.borderColor=[UIColor colorWithRed:0.0f green:33.0f/255.0f blue:99.0f/255.0f alpha:1.0];
    self.shadowOpacity=0.2f;
    self.shadowRadius=2.0f;
    
    self.activeBorderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    self.activeShadowOpacity=0.4f;
    self.activeShadowRadius=5.0f;
    
    
    self.doubleActiveBorderColor=[UIColor magentaColor];
    self.idleBackgroundColor=self.backgroundColor;
    self.backgroundColor=[UIColor clearColor];
    [self.layer setBackgroundColor:self.idleBackgroundColor.CGColor];
    
    // (0, 33/255, 99/255, 1.0)
    [self.layer setCornerRadius:3.0f];
    //[self.layer setMasksToBounds:YES];
    
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[self.borderColor CGColor]];
    
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 0.0f)];
    [self.layer setShadowOpacity:self.shadowOpacity];
    [self.layer setShadowRadius:self.shadowRadius];
    
    [self setName:@"Block"];
    [self setDescription:@"a block is a moveable object that can be connected to other blocks using connections"];
    
     [self positionLabel];
}


-(void)setFlow:(FlowView *)f{
    flow=f;
    if(f!=nil){
        for(Connection *c in [self getConnections]){
            [self.flow addConnection:c];
        }
        [self addGestureRecognizers];
    }
    [self positionLabel];
  
}


#pragma mark Connections

-(NSArray *)getConnectedBlocks{
    NSMutableArray *a=[[NSMutableArray alloc] init];
    
    for (Connection *c in [self getConnections]) {
        Block *b;
        if(c.source==self){
            b=c.destination;
        }else if(c.destination==self){
            b=c.source;
        }
        
        if(b!=nil&&[a indexOfObject:b]==NSNotFound){
            [a addObject:b];
        }
    }
    return [[NSArray alloc] initWithArray:a];
}

-(NSArray *)getConnections{
    return nil;
}

-(bool) isAvailableForInsertion{
    return false;
}

#pragma mark Detail Views and Menu

-(NSArray *)getMenuItemsArray{
    NSMutableArray *array=[[NSMutableArray alloc] init];
    if([self isAvailableForInsertion]){
        [array addObject:[[UIMenuItem alloc] initWithTitle: @"Delete" action:@selector(handleDeleteRequest)]];
    }
    [array addObject:[[UIMenuItem alloc] initWithTitle: @"Clone" action:@selector(handleCloneRequest)]];
    return [[NSArray alloc] initWithArray:array];
}

-(BOOL)canBecomeFirstResponder{
    return true;
}

- (void)displayDetailView:(NSString *)nib atIndex:(int)i{
    
    NodeViewController *vc;
    
    NSBundle *b=[NSBundle mainBundle];
    NSArray *a=[b loadNibNamed:nib owner:self.flowViewController options:nil];
    id item=[a objectAtIndex:i];

    if([item isKindOfClass:[NodeViewController class]]){
        vc=(NodeViewController *)item;
        [self configureDetialViewController:vc];
        [self.flowViewController displayDetailViewForNode:self withViewController:vc];    
        
    }else{
        NSLog(@"%s: Not a NodeViewController %@",__PRETTY_FUNCTION__, item);
    }

}
-(void)configureDetialViewController:(NodeViewController *)vc{
    [vc setModalPresentationStyle:UIModalPresentationFormSheet];
}

-(void)displayDetailView{
    
    NSString *nib=[self getDetailNibName];
    int index=[self getDetailNibIndex];
    if(nib!=nil&&index>=0)[self displayDetailView:nib atIndex:index];
}

-(int)getDetailNibIndex{
    return -1;
}

-(bool)displaysDetailViewInPopover{
    return false;
}

-(CGSize)detailViewPopoverSize{
    return CGSizeZero;
}


-(NSString *)getDetailNibName{
    return nil;
}


#pragma mark Cloning - Deleting

-(void)handleCloneRequest{
    
    Block *n=[self clone];
    //n.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //[self.flow prepareForAutolayout];
    [self.flow addBlock:n];
    
    [n moveCenterToPoint:CGPointMake(self.center.x+20, self.center.y+20)];
    [n setIsSelected:true];
    
    NSLog(@"Clone");
    
}


-(Block *)clone{
    Block * block=(Block *)[[[NSBundle mainBundle] loadNibNamed:[self bundleName] owner:self.flowViewController options:nil] objectAtIndex:[self indexInBundle]];
    [block setBundleName:self.bundleName];
    [block setIndexInBundle:self.indexInBundle];
    return block;
    
}

-(void)deleteBlockFromFlow:(FlowView *)f{
    //cleanup.
}
-(void)handleDeleteRequest{
    [self deleteBlock];
}

-(void)deleteBlock{
    if(self.flow!=nil){
        FlowView *f=self.flow;
        [f deleteBlock:self];
        for (Connection *c in [self getConnections]) {
            [f deleteConnection:c];
        }
    }else{
        if(self.superview!=nil){

            [self removeFromSuperview];
            for (Connection *c in [self getConnections]) {
                [c removeFromSuperview];
            }
        }
    }
    
    
}

#pragma mark Touch Handlers and Moving

-(void)addGestureRecognizers{
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPress setMinimumPressDuration:0.5];
    [self addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    touchOffset= CGPointMake(location.x-self.frame.origin.x, location.y-self.frame.origin.y);
    [[UIMenuController sharedMenuController] setMenuVisible:false animated:true];
    if(self.isDraggable)[self.flow dragStart:self];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(!isDraggable)return;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    //location.x=location.x-self.frame.origin.x;
    //location.y=location.y-self.frame.origin.y;
    [self moveToTouch:location];
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    selection=nil;
    selectionOffsets=nil;
    
    
    [self.flow dragEnd:self];
    
    
}
-(void)updateFrame:(CGRect)frame{
   
    [super setFrame:[self limit:frame]];
    [self declarePositionChange];
}

-(void)setFrame:(CGRect)frame{
    return;
}

-(void)moveCenterToPoint:(CGPoint)p;{

    [self updateFrame:CGRectMake(p.x-self.frame.size.width/2.0, p.y-self.frame.size.height/2.0, self.frame.size.width, self.frame.size.height)];

}



-(void)moveToTouch:(CGPoint)location{
    
    CGPoint point=CGPointMake(location.x-self.touchOffset.x, location.y-self.touchOffset.y);
    
    if(self.flow.groupSelection){
        
        if(self.selection==nil||self.selectionOffsets==nil){
            
            selection=[self.flow getSelected];
            selectionOffsets=[self.flow getSelectedOffsetsFrom:self];
            
        }
        
        for(int i=0;i<selection.count;i++){
            
            Block *n=[selection objectAtIndex:i];
            CGPoint p=[[selectionOffsets objectAtIndex:i] CGPointValue];
            [n moveToPoint:CGPointMake(point.x+p.x, point.y+p.y)];
        }
    }
    [self updateFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
    [self.flow drag:self point:self.center];
    
}

-(void)moveRelative:(CGPoint)offset{
    [self updateFrame:CGRectMake(self.frame.origin.x+offset.x, self.frame.origin.y+offset.y, self.frame.size.width, self.frame.size.height)];
}

-(void)moveToPoint:(CGPoint)location{
    [self updateFrame:CGRectMake(location.x, location.y, self.frame.size.width, self.frame.size.height)];
}

-(void)handleLongPress:(UIGestureRecognizer *) gesture{
    switch(gesture.state){
        case UIGestureRecognizerStateBegan:
            
            //[self.flow sliceNode:self];
            //[self setSelected:false];
            //if(draggable)[self.flow dragStart:self];
        {
            
            NSArray *items=[self getMenuItemsArray];
            if(items!=nil&&items.count){
                UIMenuController *menuController = [UIMenuController sharedMenuController];
                [menuController setMenuItems:items];
                [menuController setTargetRect:self.frame inView:self.flow];
                // menuController.arrowDirection = UIMenuControllerArrowLeft;
                [self becomeFirstResponder];
                [menuController setMenuVisible:true animated:true];
                //[self resignFirstResponder];
            }
            
        }
            break;
        default:break;
    }
    
    
}

-(void)handleTap:(UIGestureRecognizer *) gesture{
    [self setIsSelected:!self.isSelected];
}

-(void)handleDoubleTap:(UIGestureRecognizer *) gesture{
    //if(selected){
    [self setIsDoubleSelected:true];
    //}
}

-(void)declarePositionChange{
    
    for (Connection *c in [self getConnections]) {
        [c needsUpdate];
    }
    
}

#pragma marker Draggability

/* Notify System (ask for permission - dissable other currently draggable items) that node wants to drag */
-(BOOL)canRequestToDrag{
    return true;
}


-(BOOL)declareAboutToDrag{
    return true;
}

-(void)setIsDraggable:(bool) d{
    bool was=isDraggable;
    isDraggable=d;
    
    if(isDraggable&&was!=isDraggable){
        [self setIsSelected:true];
        if(!isDoubleSelected)[self.layer setBorderColor:[self.activeBorderColor CGColor]];
        [self.layer setShadowOpacity:self.activeShadowOpacity];
        [self.layer setShadowRadius:self.activeShadowRadius];
        
    }else{
        if(was!=isDraggable){
            [self setIsSelected:false];
        }
        [self.layer setBorderColor:[self.borderColor CGColor]];
        [self.layer setShadowOpacity:self.shadowOpacity];
        [self.layer setShadowRadius:self.shadowRadius];
        
    }
    
}

-(BOOL)declareFinishedDrag{
    return true;
}


#pragma mark Drawing

-(void)drawRect:(CGRect)rect{
    if(self.flow==nil){
        for(Connection *c in [self getConnections]){
            if(c.superview!=self.superview)[self.superview insertSubview:c atIndex:0];
        }
    }

    [super drawRect:rect];
}

-(CGRect)limit:(CGRect)rect{
    
    // CGRect frame=self.superview.frame;
    CGRect bounds=[self convertRect:self.superview.frame fromView:self.superview.superview];
    
    if(bounds.size.width<100&&bounds.size.height<100){
        return rect;  
    }
    
    float pad=10.0;
    CGRect r;
    r.origin.x=MIN(MAX(rect.origin.x, pad),bounds.size.width-pad-rect.size.width);
    r.origin.y=MIN(MAX(rect.origin.y, pad),bounds.size.height-pad-rect.size.height);
    r.size.width=rect.size.width;
    r.size.height=rect.size.height;
    
    return r;
    
}

#pragma mark Selecting

-(BOOL)declareAboutToSelect{
    [self.flow selectNode:self];
    return true;
}

-(void)setIsSelected:(bool)s{
    
    bool was=isSelected;
    isSelected=s;
    
    if(!s&&isDoubleSelected)[self setIsDoubleSelected:false];
    
    if(isSelected&&(was!=isSelected)&&[self canRequestToDrag]&&[self declareAboutToSelect]&&[self declareAboutToDrag]){
        [self setIsDraggable:true];
    }
    
    if(!isSelected&&isDraggable){
        [self setIsDraggable:false];
        [self declareFinishedDrag];
    }
    
    if(!isSelected&&was!=isSelected){
        [self declareUnselected];
    }
}

-(BOOL)declareUnselected{
    [self.flow unselectNode:self];
    return true;
}

-(BOOL)declareAboutToDoubleSelect{
    [self.flow groupSelectNode:self];
    return true;
}

-(void)setIsDoubleSelected:(bool)s{
    if(s)[self setIsSelected:true];
    isDoubleSelected=s;
    if([self declareAboutToDoubleSelect]){
        [self.layer setBorderColor:[self.doubleActiveBorderColor CGColor]];
    }
}
-(int)indexInFlow{
    return [self.flow indexOfBlock:self];
}



-(NSDictionary *)save{

    NSMutableDictionary *d =[[NSMutableDictionary alloc] init];

    [d addEntriesFromDictionary:@{@"center":@[
                                         [NSNumber numberWithInt:self.center.x],
                                         [NSNumber numberWithInt:self.center.y]],
                                 @"index":[NSNumber numberWithInt:[self indexInFlow]],
                                  @"name":self.name,
                                  @"description":self.description
                                 
                                  }];
    if([self bundleName]!=nil){
        [d addEntriesFromDictionary:@{ @"bundle":@[[self bundleName], [NSNumber numberWithInt:[self indexInBundle]]]}];
    }
    
    return [[NSDictionary alloc] initWithDictionary:d];

}

-(bool)restore:(NSDictionary *) state{
    NSArray *point=(NSArray *)[state objectForKey:@"center"];
    CGPoint p=CGPointMake([((NSNumber *)[point objectAtIndex:0]) integerValue], [((NSNumber *)[point objectAtIndex:1]) integerValue]);
    [self moveCenterToPoint:p];

    NSLog(@"%f,%f",p.x,p.y);
    return true;
}

+(Block *)InstantiateWithBundle:(NSString *)bundle andIndex:(int)index andOwner:(id) owner{
    Block *b= (Block *)[[[NSBundle mainBundle] loadNibNamed:bundle owner:owner options:nil] objectAtIndex:index];
    [b setBundleName:bundle];
    [b setIndexInBundle:index];
    return b;
}


-(void)positionLabel{}

@end
