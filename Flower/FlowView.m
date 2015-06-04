//
//  Flow.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "FlowView.h"
#import "FlowViewController.h"
#import "ThreadStartBlock.h"
#import "ThreadEndBlock.h"


#import "Connection.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <QuartzCore/QuartzCore.h>

#import "Flowutils.h"

@interface FlowView()

@property JSContext *currentContext;
@property NSMutableArray *blocks;
@property NSMutableArray *connections;
@property NSMutableArray *roots;
@property bool running;

@property NSMutableArray *selectedBlocks;
@property NSMutableArray *insertableConnections;
@property Connection *hoveringOver;

@property dispatch_queue_t queue;

@property UIView *touch;


@property NSArray *autolayoutNodeOrigins;

@property CGPoint nextInsertPoint;
@property Connection *nextInsertConnection;

@property UITapGestureRecognizer *flowTap;
@property UITapGestureRecognizer *flowDoubleTap;

@property bool isRestoring;


@end

@implementation FlowView



@synthesize delegate, delay, groupSelection, drawCtrlPoints, drawFrames, autoSave, name, description;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
        
        [self configure];
        return self;
    }
    return nil;
    
}


-(void)configure{
    
    self.autoSave=true;
    self.delay=1.0f;
    
    self.blocks=[[NSMutableArray alloc] init];
    self.connections=[[NSMutableArray alloc] init];
    self.roots=[[NSMutableArray alloc] init];
    
    
    _flowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFlowTap:)];
    [self addGestureRecognizer:_flowTap];
    
    _flowDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFlowDoubleTap:)];
    [_flowDoubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:_flowDoubleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
    
    
}





-(void)setNSNumberDelay:(NSNumber *)n{
    self.delay=[n floatValue];
}

-(void)handleFlowTap:(UIGestureRecognizer *)gesture{
    
    for (FunctionalBlock *node in self.blocks) {
        [node setIsSelected:false];
        
    }
    groupSelection=false;
    
    [self clearTouch];
}
-(void)clearTouch{
    if(_touch){
        [_touch removeFromSuperview];
        _touch=nil;
        [[UIMenuController sharedMenuController] setMenuVisible:false];
        
    }
}
-(UIView*)touch:(CGPoint)p duration:(float) d color:(UIColor *)c{
    [self clearTouch];
    CGPoint location = p;
    float r=20.0;
    
    _touch=[[UIView alloc] initWithFrame:CGRectMake(location.x-r, location.y-r, 2*r, 2*r)];
    [_touch.layer setCornerRadius:r];
    //[_touch.layer setBorderColor:[UIColor magentaColor].CGColor];
    //[_touch.layer setBorderWidth:1.0];
    [_touch setBackgroundColor:c];
    
    [self insertSubview:_touch atIndex:0];
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:d];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [_touch setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];
    
    return _touch;
}

-(void)handleFlowDoubleTap:(UIGestureRecognizer *)gesture{
    CGPoint p=[gesture locationInView:self];
    
    bool hover=false;
    Connection *over;
    for(Connection *c in self.connections) {
        float distance=[c distanceToHoverArea:[c convertPoint:p fromView:self]];
        if(distance<0){
            hover=true;
            over=c;
            p=[c convertPoint:c.centerPoint toView:self];
            
            break;
        }
    }
    
    
    CGRect frame;
    
    if(!hover){
        UIView *t=[self touch:p duration:0.5 color:[UIColor magentaColor]];
        [t.layer setBorderColor:[UIColor magentaColor].CGColor];
        [t.layer setBorderWidth:1.0];
        frame=t.frame;
    }else{
        frame.size=CGSizeMake(8, 8);
        frame.origin=CGPointMake(p.x-4, p.y-4);
    }
    
    
    
    
    
    _nextInsertConnection=nil;
    if(hover){
        _nextInsertConnection=over;
        
        NSArray *connectionsMenuItems=[_nextInsertConnection getTargetMenuItems];
        
        if(connectionsMenuItems==nil){
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"Insert Block" action:@selector(handleInsertNode)]]];
            
            [menuController setTargetRect:frame inView:self];
            [self becomeFirstResponder];
            [menuController setMenuVisible:true animated:true];
            
        }else if(connectionsMenuItems.count){
            
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems:connectionsMenuItems];
            [menuController setTargetRect:frame inView:self];
            [menuController setMenuVisible:true animated:true];
            
        }
        
    }else{
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        _nextInsertPoint=p;
        [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"Place Block" action:@selector(handlePlaceBlock)], [[UIMenuItem alloc] initWithTitle:@"Place Flow" action:@selector(handlePlaceFlow)]]];
        
        [menuController setTargetRect:frame inView:self];
        [self becomeFirstResponder];
        [menuController setMenuVisible:true animated:true];
        
    }
    
    
    
    
    
    
}
-(void)willHideEditMenu:(id)object{
    [self clearTouch];
    [self clearDrag];
}

-(void)handlePlaceBlock{
    
    
    if([self.delegate respondsToSelector:@selector(displayNodeLibraryWithPoint:)]){
        [self.delegate performSelector:@selector(displayNodeLibraryWithPoint:) withObject:[NSValue valueWithCGPoint:_nextInsertPoint]];
    }
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
}


-(void)handlePlaceFlow{
    
    ThreadStartBlock *start=(ThreadStartBlock *)[Flowutils InstantiateWithBundle:@"program" andIndex:0 andOwner:self.delegate];
    [self addBlock:start];
    [start moveCenterToPoint:_nextInsertPoint];
    
    ThreadEndBlock *end=(ThreadEndBlock *)[Flowutils InstantiateWithBundle:@"program" andIndex:1 andOwner:self.delegate];
    [self addBlock:end];
    [end moveCenterToPoint:CGPointMake(_nextInsertPoint.x+100, _nextInsertPoint.y+100)];
    [start.primaryOutputConnection insertBlock:end];
}
-(void)handleInsertNode{
    if([self.delegate respondsToSelector:@selector(displayNodeLibraryWithConnection:)]){
        [self.delegate performSelector:@selector(displayNodeLibraryWithConnection:) withObject:_nextInsertConnection];
    }
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

-(BOOL)canBecomeFirstResponder{
    return true;
}
-(void)run{
    
    for (ThreadStartBlock *start in self.roots) {
        [start run];
    }
    
}

-(void)selectNode:(FunctionalBlock *)n{
    
    
    NSArray *nodes=[n getConnectedBlocks];
    bool nextToDoubleSelection=false;
    for (FunctionalBlock *next in nodes) {
        if(next.isDoubleSelected)nextToDoubleSelection=true;
    }
    
    if(nextToDoubleSelection){
        [n setIsDoubleSelected:true];
        [_selectedBlocks addObject:n];
    }else{
        for (FunctionalBlock *node in self.blocks) {
            if(n!=node)[node setIsSelected:false];
        }
        groupSelection=false;
    }
    
    //[self dragEnd:nil];
    
}

-(void)unselectNode:(FunctionalBlock *)n{
    if(!groupSelection)return;
    [_selectedBlocks removeObject:n];
    
    //[self dragEnd:nil];
    
}


-(void)dragStart:(FunctionalBlock *)n{
    
    if(!groupSelection&&n.isSelected&&!n.isDoubleSelected){
        if([n isAvailableForInsertion]){
            
            _insertableConnections=[[NSMutableArray alloc] init];
            
            for(Connection *c in self.connections) {
                if([c canInsertBlock:n]&&[c drawInsertArea:n]){
                    [_insertableConnections addObject:c];
                }
            }
            
        }
    }
}

-(void)drag:(FunctionalBlock *)n point:(CGPoint)p{
    
    if(_insertableConnections!=nil){
        for(Connection *c in _insertableConnections) {
            float distance=[c distanceToHoverArea:[c convertPoint:p fromView:self]];
            if(distance<0){
                
                if(c==_hoveringOver){
                    //do nothing.
                }else{
                    
                    if(_hoveringOver!=nil){
                        [_hoveringOver clearHoverArea:n];
                        _hoveringOver=nil;
                    }
                    
                    if([c drawHoverArea:n]){
                        _hoveringOver=c;
                    }
                }
            }else{
                
                if(c==_hoveringOver){
                    [_hoveringOver clearHoverArea:n];
                    _hoveringOver=nil;
                }
                
            }
        }
    }
    
}

-(void)clearDrag{
    _hoveringOver=nil;
    [self dragEnd:nil];
}
-(void)dragEnd:(FunctionalBlock *)n{
    
    if(_insertableConnections!=nil){
        
        for(Connection *c in _insertableConnections) {
            [c clearInsertArea:n];
        }
        _insertableConnections=nil;
        
        
        if(_hoveringOver&&n!=nil){
            [_hoveringOver clearHoverArea:n];
            
            [_hoveringOver insertBlock:n];
            _hoveringOver=nil;
            
        }
    }
    
}

-(void)groupSelectNode:(FunctionalBlock *)n{
    if(groupSelection)return;
    for (FunctionalBlock *node in self.blocks) {
        if(node!=n)[node setIsSelected:false];
    }
    _selectedBlocks=[[NSMutableArray alloc] initWithObjects:n, nil];
    groupSelection=true;
    
    
}


-(NSArray *) getSelected{
    if(!groupSelection)return nil;
    return [[NSArray alloc] initWithArray:_selectedBlocks];
}
-(NSArray *) getSelectedOffsetsFrom:(Block *)n{
    if(!groupSelection)return nil;
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (FunctionalBlock *node in _selectedBlocks) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(node.frame.origin.x-n.frame.origin.x, node.frame.origin.y-n.frame.origin.y)]];
    }
    
    return [[NSArray alloc] initWithArray:points];
}


-(bool)addBlock:(Block *)n;{
    
    
    
    
    if([self.blocks indexOfObject:n]==NSNotFound){
        [self.blocks addObject:n];
        if([n isKindOfClass:[ThreadStartBlock class]]){
            return [self addRootBlock:(ThreadStartBlock *)n];
        }
    }
    [n setFlow:self];
    [n setFlowViewController:self.delegate];
    
    if(n.superview!=self){
        
        //todo: calculate position
        
        [self addSubview:n];
        
    }
    
    
    
    
    return true;
}
-(bool)addConnection:(Connection *)c{
    if([self.connections indexOfObject:c]==NSNotFound)[self.connections addObject:c];
    if(c.superview!=self){
        
        //todo: calculate position
        [self insertSubview:c atIndex:0];
    }
    [c setDelegate:self.delegate];
    [c setDrawCtrlPoints:self.drawCtrlPoints];
    [c setDrawFrame:self.drawFrames];
    
    return true;
}

-(bool)deleteConnection:(Connection *)c{
    
    [self.connections removeObject:c];
    [c removeFromSuperview];
    [c deleteConnectionFromFlow:self]; //notification for self cleanup.
    [c setDestination:nil];
    [c setSource:nil];
    [c setDelegate:nil];
    
    
    return true;
}





-(bool)addRootBlock:(FunctionalBlock *)n{
    [self clearDrag];
    if([self.roots indexOfObject:n]==NSNotFound)[self.roots addObject:n];
    [self addBlock:n];
    return true;
}

-(bool)deleteBlock:(Block *)n{
    
    if([self.blocks indexOfObject:n]!=NSNotFound)[self.blocks removeObject:n];
    
    
    [n deleteBlockFromFlow:self]; //notification for self cleanup. loops can remove thier loopout
    
    [n setFlow:nil];
    [n setFlowViewController:nil];
    if(n.superview==self)[n removeFromSuperview];
    return true;
    
}


-(bool)sliceBlock:(FunctionalBlock *)n{
    
    if([n isKindOfClass:[ThreadStartBlock class]])return false;
    if([n isKindOfClass:[ThreadEndBlock class]])return false;
    
    FunctionalBlock *next=[n getNextBlock];
    FunctionalBlock *previous=[n getPreviousBlock];;
    
    
    if(previous&&next){
        Connection *c=n.primaryInputConnection;
        [c setCenterAlignOffsetDestination:n.primaryOutputConnection.centerAlignOffsetDestination];
        [self deleteConnection:n.primaryOutputConnection];
        [c connectNode:previous toNode:next];
        [c needsUpdate];
        
        
    }else if(previous){
        
    }else if (next){
        
    }
    
    
    [n setPrimaryInputConnection:nil];
    [n setPrimaryOutputConnection:nil];
    
    
    for (FunctionalBlock *node in self.blocks) {
        if(n!=node)[node setIsSelected:false];
    }
    
    return true;
}



-(void)prepareForAutolayout{
    /*
     NSMutableArray *no=[[NSMutableArray alloc] init];
     for (LogicBlock *n in self.blocks) {
     [no addObject:[NSValue valueWithCGPoint:CGPointMake(n.frame.origin.x, n.frame.origin.y)]];
     }
     
     _autolayoutNodeOrigins=[[NSArray alloc] initWithArray:no];
     */
}
-(void)reactToAutolayout{
    
    // double delayInSeconds = 0.0;
    //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    // dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    /*
     if(_autolayoutNodeOrigins==nil){
     return;
     }
     int i=0;
     for (NSValue *v in _autolayoutNodeOrigins) {
     CGPoint p=[v CGPointValue];
     LogicBlock *c=[self.blocks objectAtIndex:i];
     //CGPoint current=c.frame.origin;
     [c moveToPoint:p];
     i++;
     }
     _autolayoutNodeOrigins=nil;
     // });
     
     */
    
    
}

-(void)setDrawCtrlPoints:(bool)d{
    drawCtrlPoints=d;
    for (Connection *c in self.connections) {
        [c setDrawCtrlPoints:d];
        [c needsUpdate];
    }
    
}

-(void)setDrawFrames:(bool)d{
    drawFrames=d;
    for (Connection *c in self.connections) {
        [c setDrawFrame:d];
        [c needsUpdate];
    }
    
}

-(int)indexInBundle{
    return 6;
}

- (UIImage *)captureView {
    
    //hide controls if needed
    CGRect rect = [self bounds];
    
    
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
    
}
-(int)indexOfBlock:(Block *)block{
    return [self.blocks indexOfObject:block];
    
}
-(Block *)blockAtIndex:(int)index{
    if(self.blocks.count>index)return [self.blocks objectAtIndex:index];
    return nil;
}
-(int)indexOfConnection:(Connection *)connection{
    return [self.connections indexOfObject:connection];
    
}
-(Connection *)connectionAtIndex:(int)index{
    if(self.connections.count>index)return [self.connections objectAtIndex:index];
    return nil;
}
-(NSDictionary *)save{
    //[self.saveSpinner setHidden:false];
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.saveSpinner startAnimating];
     });
    
    NSMutableArray *connections=[[NSMutableArray alloc] init];
    for (Connection *c in self.connections) {
        NSDictionary *cdata=[c save];
        if(cdata!=nil)[connections addObject:cdata];
    }
    
    
    NSMutableArray *blocks=[[NSMutableArray alloc] init];
    for (Block *b in self.blocks) {
        [blocks addObject:[b save]];
    }
    
    NSDictionary *d=@{
             
             @"connections":connections,
             @"blocks":blocks,
             @"size":@[[NSNumber numberWithInt:self.frame.size.width], [NSNumber numberWithInt:self.frame.size.height]],
             @"delay":[NSNumber numberWithFloat:self.delay],
             @"name":self.name!=nil?self.name:@"My Flow",
             @"description":self.description!=nil?self.description:@"my first flowgram"
             
        };
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.saveSpinner stopAnimating];
    });
  
    //[self.saveSpinner setHidden:true];
    return d;
}

-(bool)restore:(NSDictionary *)state{
    //NSLog(@"%@",state);
    _isRestoring=true;
       
    
    
    
    NSArray *blockStates=(NSArray *)[state objectForKey:@"blocks"];
    NSArray *blocks=[Flowutils LoadFlowgramBlocks:blockStates withOwner:self.delegate];

    for(int i=0;i<blocks.count;i++){
        [self addBlock:[blocks objectAtIndex:i]];
    }
    
    for(int i=0;i<blockStates.count;i++){
        NSDictionary *blockState=[blockStates objectAtIndex:i];
        Block *current;
        if(self.blocks.count>i)current=[self.blocks objectAtIndex:i];
        if(current!=nil){
            [current restore:blockState];
        }else{
            
        }
    }
    
    [Flowutils ConnectFlowgramBlocks:self.blocks withConnections:[state objectForKey:@"connections"]];
    
    NSString *strName=[state objectForKey:@"name"];
    if(strName!=nil){
        self.name=strName;
    }else{
        self.name=@"My Flow";
    }

    
    NSString *strDesc=[state objectForKey:@"description"];
    if(strDesc!=nil){
        self.description=strDesc;
    }else{
        self.description=@"my first flowgram";
    }

    _isRestoring=false;
    return true;
}

-(void)setName:(NSString *)n{
    name=n;
    self.nameLabel.text=n;
}

-(void)setDescription:(NSString *)d{
    description=d;
    self.descriptionLabel.text=d;
}

@end
