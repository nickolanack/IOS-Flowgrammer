//
//  NodeLibraryViewController.m
//  Flower
//
//  Created by Nick Blackwell on 3/5/2014.
//  Copyright (c) 2014 Nick Blackwell. All rights reserved.
//

#import "NodeLibraryViewController.h"
#import "NodeViewCell.h"
#import "Node.h"

@interface NodeLibraryViewController ()

@property NSArray *library;

@end

@implementation NodeLibraryViewController
@synthesize delegate;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return [self getNodeLib].count;
}

-(NSArray*)getNodeLib{
    if(_library!=nil)return _library;
    NSBundle *b=[NSBundle mainBundle];
    NSArray *a=[b loadNibNamed:@"IpadNodeView" owner:self.delegate options:nil];
    _library=a;
    return a;
}

-(Node *)getLibraryNodeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int i=indexPath.item;
    return (Node *)[[self getNodeLib] objectAtIndex:i];

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    NodeViewCell *c=[collectionView dequeueReusableCellWithReuseIdentifier:@"nodeViewCell" forIndexPath:indexPath];
    if(c!=nil){
    
        [c setNode:[self getLibraryNodeForItemAtIndexPath:indexPath]];
        [c setDelegate:self];
        return c;
    }
    return nil;
}
- (void) selectFlowNode:(Node *)node{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(addNodeToFlow:)]){
            [self.delegate performSelector:@selector(addNodeToFlow:) withObject:node];
            [self dismissViewControllerAnimated:TRUE completion:^{
                
            }];
        }
    
    }

}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}
@end
