//
//  MMDocument.h
//  GLMotionMaker
//
//  Created by Filip Kunc on 9/29/10.
//  For license see LICENSE.TXT
//

#import <Cocoa/Cocoa.h>
#import "FPAnimationView.h"

@interface MMDocument : NSDocument 
{
    IBOutlet FPAnimationView *animationView;
}

- (IBAction)selectedModeChanged:(id)sender;
- (IBAction)collapseSelected:(id)sender;
- (IBAction)breakVertex:(id)sender;

@end
