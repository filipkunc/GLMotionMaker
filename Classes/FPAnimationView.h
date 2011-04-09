//
//  FPAnimationView.h
//  GLMotionMaker
//
//  Created by Filip Kunc on 9/29/10.
//  For license see LICENSE.TXT
//

#import "FPFont.h"
#import "FPTriangleMesh.h"

@interface FPAnimationView : NSOpenGLView 
{
    FPTriangleMesh *triangleMesh;
    FPTexture *texture;
    FPFont *font;
    CGPoint lastMouseLocation;
    CGPoint mouseDownLocation;
    BOOL selecting;
    BOOL rotating;
    MMEditorMode editorMode;
    FPNode<FPVertex *> *highlightedVertexNode;
    CGPoint viewOffset;
    float viewZoom;    
}

@property (readwrite, assign) MMEditorMode editorMode;

- (CGPoint)offsetAndZoomLocation:(CGPoint)location;
- (void)collapseSelected;
- (void)breakVertex;

@end
