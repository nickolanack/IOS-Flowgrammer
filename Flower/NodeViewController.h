//
//  NodeViewController.h
//  
//
//  Created by Nick Blackwell on 2/28/2014.
//
//

#import <UIKit/UIKit.h>
@class Block;

@interface NodeViewController : UIViewController

@property (strong, nonatomic) Block *block;
@property UIPopoverController *pvc;
- (IBAction)onCloseClick:(id)sender;
@end
