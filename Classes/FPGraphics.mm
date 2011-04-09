/*
 *  FPGraphics.mm
 *  IronJump
 *
 *  Created by Filip Kunc on 5/30/10.
 *  For license see LICENSE.TXT
 *
 */

#import "FPGraphics.h"

FPAtlasVertex globalVertexBuffer[kMaxVertices];

CGRect CGRectMakeFromPoints(CGPoint a, CGPoint b)
{
	CGFloat x1 = MIN(a.x, b.x);
	CGFloat y1 = MIN(a.y, b.y);
	CGFloat x2 = MAX(a.x, b.x);
	CGFloat y2 = MAX(a.y, b.y);
	
	return CGRectMake(x1, y1, x2 - x1, y2 - y1);
}

CGPoint CGRectMiddlePoint(CGRect rect)
{
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


