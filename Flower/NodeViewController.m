//
//  NodeViewController.m
//  
//
//  Created by Nick Blackwell on 2/28/2014.
//
//

#import "NodeViewController.h"

@implementation NodeViewController

@synthesize block, pvc;


- (IBAction)onCloseClick:(id)sender {
    
    if(self.pvc!=nil){
        [self.pvc dismissPopoverAnimated:true];
    }else{
    
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
    }
 
}
@end
