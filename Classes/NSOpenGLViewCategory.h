//
//  NSOpenGLViewCategory.h
//  GLMotionMaker
//
//  Created by Filip Kunc on 9/29/10.
//  For license see LICENSE.TXT
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

@interface NSOpenGLView (NSOpenGLViewCategory)

+ (NSOpenGLPixelFormat *)sharedPixelFormat;
+ (NSOpenGLContext *)sharedContext;
- (void)setupSharedContext;
- (CGSize)reshapeFlippedOrtho2D;
- (CGPoint)locationFromNSEvent:(NSEvent *)e;
- (CGRect)boundsCG;
- (CGPoint)middlePoint;

@end
