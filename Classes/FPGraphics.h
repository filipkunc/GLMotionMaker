/*
 *  FPGraphics.h
 *  IronJump
 *
 *  Created by Filip Kunc on 5/30/10.
 *  For license see LICENSE.TXT
 *
 */

#if TARGET_OS_IPHONE

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#else

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

#endif

typedef struct
{
	GLfloat x, y;
	GLshort s, t;
} FPShortVertex;

typedef struct
{
	GLfloat x, y;
	GLfloat s, t;
} FPAtlasVertex;

#define kMaxVertices 8192

extern FPAtlasVertex globalVertexBuffer[kMaxVertices];

CGRect CGRectMakeFromPoints(CGPoint a, CGPoint b);
CGPoint CGRectMiddlePoint(CGRect rect);
