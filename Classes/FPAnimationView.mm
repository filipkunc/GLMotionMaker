//
//  FPAnimationView.mm
//  GLMotionMaker
//
//  Created by Filip Kunc on 9/29/10.
//  For license see LICENSE.TXT
//

#import "FPAnimationView.h"
#import "NSOpenGLViewCategory.h"

@implementation FPAnimationView

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
    if (self) 
	{
		[self setupSharedContext];
		glClearColor(0.4f, 0.4f, 0.4f, 1.0f);
		glEnable(GL_TEXTURE_2D);
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        texture = [[FPTexture alloc] initWithFile:@"STEELMAN.png" convertToAlpha:NO];
        font = [[FPFont alloc] initWithFile:@"AndaleMono.png" tileSize:32 spacing:13.0f];
        triangleMesh = new FPTriangleMesh();
        lastMouseLocation = CGPointZero;
        mouseDownLocation = CGPointZero;
        editorMode = MMEditorModeTriangles;
        selecting = NO;
        rotating = NO;
        highlightedVertexNode = NULL;
        viewOffset = CGPointMake(0.0f, 0.0f);
        viewZoom = 1.0f;
    }
    return self;
}

- (void)dealloc
{
    [texture release];
    [font release];
	[super dealloc];
}

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (void)awakeFromNib
{
	NSWindow *window = [self window];
	[window setAcceptsMouseMovedEvents:YES];
}

- (BOOL)isFlipped
{
	return YES;
}

- (void)reshape
{
	[self setNeedsDisplay:YES];
}

- (MMEditorMode)editorMode
{
    return editorMode;
}

- (void)setEditorMode:(MMEditorMode)value
{
    editorMode = value;
    if (value == MMEditorModeDeform)
        triangleMesh->ResetDeformed();
    [self setNeedsDisplay:YES];
}

- (CGPoint)offsetAndZoomLocation:(CGPoint)location
{
    location.x -= viewOffset.x;
    location.y -= viewOffset.y;
    location.x /= viewZoom;
    location.y /= viewZoom;
    return location;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    mouseDownLocation = [self locationFromNSEvent:theEvent];
    CGPoint location = [self offsetAndZoomLocation:mouseDownLocation];
    
    switch (editorMode)
    {
        case MMEditorModeTriangles:
            triangleMesh->CreateTriangleAtPoint(location, 50.0f / viewZoom);
            break;
        case MMEditorModeQuads:
            triangleMesh->CreateQuadAtPoint(location, 50.0f / viewZoom);
            break;
        case MMEditorModeRig:
        case MMEditorModeDeform:
            if (!rotating && highlightedVertexNode == NULL)
                selecting = YES;
            else if (!rotating && !highlightedVertexNode->data->selected)
                triangleMesh->Select(MMSelectionModeSingle, CGRectMake(location.x, location.y, 1.0f, 1.0f), editorMode == MMEditorModeDeform, viewZoom);
            break;
    }
	[self setNeedsDisplay:YES];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    lastMouseLocation = [self locationFromNSEvent:theEvent];
    CGPoint location = [self offsetAndZoomLocation:lastMouseLocation];
    if (editorMode == MMEditorModeDeform || editorMode == MMEditorModeRig)
    {
        highlightedVertexNode = triangleMesh->GetHighlightedVertex(location, editorMode == MMEditorModeDeform, viewZoom);
        if (highlightedVertexNode == NULL)
            rotating = triangleMesh->IsNearRotationTool(location, editorMode == MMEditorModeDeform);
        else
            rotating = NO;
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    CGPoint currentLocation = [self locationFromNSEvent:theEvent];
    if (!selecting)
    {
        if (rotating)
        {
            CGPoint first = [self offsetAndZoomLocation:lastMouseLocation];
            CGPoint second = [self offsetAndZoomLocation:currentLocation];
            triangleMesh->RotateSelectedVertices(first, second, editorMode == MMEditorModeDeform);
        }
        else
        {
            CGPoint diff = CGPointMake(currentLocation.x - lastMouseLocation.x, currentLocation.y - lastMouseLocation.y);
            diff.x /= viewZoom;
            diff.y /= viewZoom;
            triangleMesh->MoveSelectedVertices(diff, editorMode == MMEditorModeDeform);
        }
    }    
    lastMouseLocation = currentLocation;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (selecting)
    {
        lastMouseLocation = [self locationFromNSEvent:theEvent];
        CGRect rect = CGRectMakeFromPoints([self offsetAndZoomLocation:mouseDownLocation],
                                           [self offsetAndZoomLocation:lastMouseLocation]);        
        
        NSUInteger flags = [theEvent modifierFlags];
        MMSelectionMode mode = MMSelectionModeSingle;
        if ((flags & NSCommandKeyMask) == NSCommandKeyMask)
            mode = MMSelectionModeToggle;
        else if ((flags & NSShiftKeyMask) == NSShiftKeyMask)
            mode = MMSelectionModeAdd;
        triangleMesh->Select(mode, rect, editorMode == MMEditorModeDeform, viewZoom);
    }
    
    selecting = NO;
    rotating = NO;
    [self setNeedsDisplay:YES];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    float delta = [theEvent deltaY] * 0.05f;
    CGPoint center = [self middlePoint];
    
    if (viewZoom + delta < 0.5f)
        delta = 0.5f - viewZoom;
    
    float offsetDelta = delta / viewZoom;
    
    viewZoom += delta;
    viewOffset.x += (viewOffset.x - center.x) * offsetDelta;
    viewOffset.y += (viewOffset.y - center.y) * offsetDelta;
        
    [self setNeedsDisplay:YES];
}

- (void)otherMouseDown:(NSEvent *)theEvent
{
    mouseDownLocation = [self locationFromNSEvent:theEvent];
    lastMouseLocation = mouseDownLocation;
}

- (void)otherMouseDragged:(NSEvent *)theEvent
{
    CGPoint location = [self locationFromNSEvent:theEvent];
    float diffX = location.x - lastMouseLocation.x;
    float diffY = location.y - lastMouseLocation.y;
    viewOffset.x += diffX;
    viewOffset.y += diffY;
    [self setNeedsDisplay:YES];
    lastMouseLocation = location;
}

- (void)drawRect:(NSRect)dirtyRect 
{
	[self reshapeFlippedOrtho2D];
	
    glClear(GL_COLOR_BUFFER_BIT);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    glEnable(GL_TEXTURE_2D);
    
    glPushMatrix();
    glTranslatef(viewOffset.x, viewOffset.y, 0.0f);
    glScalef(viewZoom, viewZoom, 1.0f);    
    
    if (editorMode == MMEditorModeDeform)
    {
        glBindTexture(GL_TEXTURE_2D, [texture textureID]);
        triangleMesh->Draw(highlightedVertexNode, [texture width], [texture height], true);
        triangleMesh->DrawRotationTool(rotating, true);
    }
    else
    {
        [texture draw];
        glDisable(GL_TEXTURE_2D);
        triangleMesh->Draw(highlightedVertexNode, [texture width], [texture height], false);
        triangleMesh->DrawRotationTool(rotating, false);
    }    
   
    glPopMatrix();    
    
    if (selecting)
    {
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		glColor4f(1, 1, 1, 0.2f);
		glRectf(mouseDownLocation.x, mouseDownLocation.y, lastMouseLocation.x, lastMouseLocation.y);
		glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		glColor4f(1, 1, 1, 0.9f);
		glRectf(mouseDownLocation.x, mouseDownLocation.y, lastMouseLocation.x, lastMouseLocation.y);
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }
    
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
                    
	[[self openGLContext] flushBuffer];
}

- (void)collapseSelected
{
    triangleMesh->CollapseSelectedVertices();
    [self setNeedsDisplay:YES];
}

- (void)breakVertex
{
    triangleMesh->vertices.Iterate(^(VertexNode *node, bool *stop) 
    {  
        if (node->data->selected)
        {
            triangleMesh->BreakVertex(node);
            *stop = true;
        }
    });
    [self setNeedsDisplay:YES];
}

@end
