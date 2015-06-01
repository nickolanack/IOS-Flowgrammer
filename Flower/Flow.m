//
//  Flow.m
//  Flower
//
//  Created by Nick Blackwell on 2/24/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "Flow.h"
#import "Node.h"
#import "StartupNode.h"
#import "CompletionNode.h"
#import "Junction.h"

#import "Connection.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface Flow()

@property JSContext *currentContext;
@property NSMutableArray *nodes;
@property NSMutableArray *connections;
@property NSMutableArray *roots;
@property bool running;

@property NSMutableArray *selection;
@property NSMutableArray *insertableConnections;
@property Connection *hoveringOver;

@property dispatch_queue_t queue;

@property UIView *touch;


@property NSArray *autolayoutNodeOrigins;


@end

@implementation Flow



@synthesize delegate, delay, groupSelection;

-(id)initWithCoder:(NSCoder *)aDecoder{

    self=[super initWithCoder:aDecoder];
    if(self){
        
        self.delay=1.0f;
        
        self.nodes=[[NSMutableArray alloc] init];
        self.connections=[[NSMutableArray alloc] init];
        self.roots=[[NSMutableArray alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
        
        return self;
    }
    return nil;
}



-(void)setNSNumberDelay:(NSNumber *)n{
    self.delay=[n floatValue];
}

-(void)handleTap:(UIGestureRecognizer *)gesture{

    for (Node *node in self.nodes) {
         [node setSelected:false];
       }
    groupSelection=false;
    
    //[self touch:[gesture locationInView:self] duration:0.2 color:[UIColor lightGrayColor]];
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
    [self prepareForAutolayout];
    [self insertSubview:_touch atIndex:0];
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:d];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [_touch setBackgroundColor:[UIColor clearColor]];
    [UIView commitAnimations];

    return _touch;
}

-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    CGPoint p=[gesture locationInView:self];
    
    bool hover=false;
    Connection *over;
    for(Connection *c in self.connections) {
        float distance=[c distanceToHoverArea:[c convertPoint:p fromView:self]];
        if(distance<0){
            hover=true;
            over=c;
            p=[c convertPoint:c.c toView:self];
            
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
    
    
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    [menuController setMenuItems:@[[[UIMenuItem alloc] initWithTitle: hover?@"Insert Node":@"Place Node" action:@selector(handlePlaceNode)]]];
    [menuController setTargetRect:frame inView:self];
    // menuController.arrowDirection = UIMenuControllerArrowLeft;
    [self becomeFirstResponder];
    [menuController setMenuVisible:true animated:true];
    //[self resignFirstResponder];
    
    
    
}
-(void)willHideEditMenu:(id)object{
    [self clearTouch];
}
-(void)handlePlaceNode{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
-(BOOL)canBecomeFirstResponder{
    return true;
}
-(void)run{
    
        _queue = dispatch_queue_create("Flow Execution Thread", 0);
        _running=true;
    
        JSContext *context = [[JSContext alloc] initWithVirtualMachine:[[JSVirtualMachine alloc] init]];
        _currentContext=context;
        [context setExceptionHandler:^(JSContext * context, JSValue *value) {

            NSLog(@"Exception Handler %s %@", __PRETTY_FUNCTION__, value);

        }];
        
        for (Node *start in self.roots) {
            dispatch_async(_queue, ^{
                [self execute:start];
            });
        }
        
    
}

-(void)execute:(Node *)node{

    if(!_running)return;
    
    @try {
        
        [node prepareToExecute]; //any setup.
        [node execute:_currentContext];
        [node afterExecution]; //any cleanup.
        
        //chain execution.
        if(node.output!=nil&&node.output.next!=nil){
            double delayInSeconds = self.delay;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, _queue, ^(void){
                [self execute:[node nextExecutionNode]];
            });
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Caught Exception %s: %@",__PRETTY_FUNCTION__,exception);
    }
    @finally {
        
    }
}


-(void)selectNode:(Node *)n{


    NSArray *nodes=[n connectedNodes];
    bool nextToDoubleSelection=false;
    for (Node *next in nodes) {
        if(next.doubleSelected)nextToDoubleSelection=true;
    }
    
    if(nextToDoubleSelection){
        [n setDoubleSelected:true];
        [_selection addObject:n];
    }else{
        for (Node *node in self.nodes) {
            if(n!=node)[node setSelected:false];
        }
        groupSelection=false;
    }
    
    //[self dragEnd:nil];

}

-(void)unselectNode:(Node *)n{
    if(!groupSelection)return;
    [_selection removeObject:n];
    
    //[self dragEnd:nil];
    
}


-(void)dragStart:(Node *)n{

    if(!groupSelection&&n.selected&&!n.doubleSelected){
        Node *next=[n nextNode];
        Node *prev=[n previousNode];
        if(next==nil&&prev==nil){

            _insertableConnections=[[NSMutableArray alloc] init];
            
            for(Connection *c in self.connections) {
                if([c drawInsertArea:n]){
                    [_insertableConnections addObject:c];
                }
            }
            
        }
    }

}

-(void)drag:(Node *)n point:(CGPoint)p{

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

-(void)dragEnd:(Node *)n{
    
    if(_insertableConnections!=nil){
    
        for(Connection *c in _insertableConnections) {
            [c clearInsertArea:n];
        }
        _insertableConnections=nil;
        
        
        if(_hoveringOver&&n!=nil){
            [_hoveringOver clearHoverArea:n];
            [self prepareForAutolayout];
            [self insertNode:n at:_hoveringOver];
            _hoveringOver=nil;
        
        }
    }
    //[self prepareForAutolayout];
    
}

-(void)groupSelectNode:(Node *)n{
    if(groupSelection)return;
    for (Node *node in self.nodes) {
        if(node!=n)[node setSelected:false];
    }
    _selection=[[NSMutableArray alloc] initWithObjects:n, nil];
    groupSelection=true;
   

}


-(NSArray *) getSelected{
    if(!groupSelection)return nil;
    return [[NSArray alloc] initWithArray:_selection];
}
-(NSArray *) getSelectedOffsetsFrom:(Node *)n{
    if(!groupSelection)return nil;
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (Node *node in _selection) {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(node.frame.origin.x-n.frame.origin.x, node.frame.origin.y-n.frame.origin.y)]];
    }

    return [[NSArray alloc] initWithArray:points];
}


-(bool)addNode:(Node *)n;{

    if([self.nodes indexOfObject:n]==NSNotFound)[self.nodes addObject:n];
    [n setFlow:self];
    [n setDelegate:self.delegate];
    
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
    
    return true;
}

-(bool)deleteConnection:(Connection *)c{
    
    [self.connections removeObject:c];
    [c removeFromSuperview];
    [c setNext:nil];
    [c setPrevious:nil];
    [c setDelegate:nil];
    
    [c deleteConnectionFromFlow:self]; //notification for self cleanup.
    
    return true;
}

-(bool)insertNode:(Node *)n at:(Connection *)c{

    Node *next=c.next;
    
    [c connectNode:c.previous toNode:n];
    
    [self addNode:n];
    
    Connection *nextCon=[c getNextConnectionForSplit];
    [self addConnection:nextCon];
   
    [nextCon connectNode:n toNode:next];
    
    
    [c needsUpdate];
    [nextCon needsUpdate];
    
    
    
    return true;

}





-(bool)insertNode:(Node *)next afterNode:(Node *)prev{
    
    if(prev==nil)@throw [[NSException alloc] initWithName:@"Insert After Null" reason:@"Expected parent node to be a valid node" userInfo:nil];
    if([self.nodes indexOfObject:prev]==NSNotFound)@throw [[NSException alloc] initWithName:@"Insert Unkown Node" reason:@"Expected parent node to be in the current flow" userInfo:nil];

    Connection *c=prev.output;
    
    if(c!=nil)return [self insertNode:next at:c];
    
    [self addNode:next];
    
    c=[[Connection alloc] init];
    [self addConnection:c];
    
    [c connectNode:prev toNode:next];
    
    return true;
}

-(bool)addRootNode:(Node *)n{

    if([self.roots indexOfObject:n]==NSNotFound)[self.roots addObject:n];
    [self addNode:n];
    return true;
}

-(bool)deleteNode:(Node *)n{
    
    if([self.nodes indexOfObject:n]!=NSNotFound)[self.nodes removeObject:n];
    n.input=nil;
    n.output=nil;
    [n setFlow:nil];
    [n setDelegate:nil];
    if(n.superview==self)[n removeFromSuperview];
    [n deleteNodeFromFlow:self]; //notification for self cleanup.
    return true;
}






-(bool)sliceNode:(Node *)n{
    [self prepareForAutolayout];
    if([n isKindOfClass:[StartupNode class]])return false;
    if([n isKindOfClass:[CompletionNode class]])return false;

    Node *next=[n nextNode];
    Node *previous=[n previousNode];;
    
  
    if(previous&&next){
        [self deleteConnection:n.output];
        [n.input connectNode:previous toNode:next];
        
    }else if(previous){
        
    }else if (next){
        
    }
    
    
    [n setInput:nil];
    [n setOutput:nil];
    
    
    for (Node *node in self.nodes) {
        if(n!=node)[node setSelected:false];
    }

    return true;
}



-(void)prepareForAutolayout{
    
    NSMutableArray *no=[[NSMutableArray alloc] init];
    for (Node *n in self.nodes) {
        [no addObject:[NSValue valueWithCGPoint:CGPointMake(n.frame.origin.x, n.frame.origin.y)]];
    }
    
    _autolayoutNodeOrigins=[[NSArray alloc] initWithArray:no];
    
}
-(void)reactToAutolayout{
    
   // double delayInSeconds = 0.0;
   //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
   // dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if(_autolayoutNodeOrigins==nil)return;
        int i=0;
        for (NSValue *v in _autolayoutNodeOrigins) {
            CGPoint p=[v CGPointValue];
            Node *c=[self.nodes objectAtIndex:i];
            CGPoint current=c.frame.origin;
            [c moveToPoint:p];
            i++;
        }
        _autolayoutNodeOrigins=nil;
   // });
    
    
   
    
}


@end
