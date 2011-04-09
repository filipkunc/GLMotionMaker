//
//  FPTriangleMesh.mm
//  GLMotionMaker
//
//  Created by Filip Kunc on 10/16/10.
//  For license see LICENSE.TXT
//

#import "FPTriangleMesh.h"

FPVertex::FPVertex(float x, float y)
{
    this->x = x;
    this->y = y;
    this->dx = x;
    this->dy = y;
    this->selected = NO;
}

FPTriangleMesh::FPTriangleMesh()
{
    
}

FPTriangleMesh::~FPTriangleMesh()
{
    vertices.Iterate(^(VertexNode *node, bool *stop) { RemoveVertex(node); });
    triangles.Iterate(^(TriangleNode *node, bool *stop) { RemoveTriangle(node); });
    edges.Iterate(^(EdgeNode *node, bool *stop) { RemoveEdge(node); });
}

void FPTriangleMesh::CreateTriangleAtPoint(CGPoint point, float s)
{
    FPVertex *v1 = new FPVertex(point.x - s, point.y - s);
    VertexNode *vertexNode1 = vertices.Add(v1);
    
    FPVertex *v2 = new FPVertex(point.x + s, point.y - s);
    VertexNode *vertexNode2 = vertices.Add(v2);
    
    FPVertex *v3 = new FPVertex(point.x, point.y + s);
    VertexNode *vertexNode3 = vertices.Add(v3);

    FPTriangle *triangle = new FPTriangle();
    TriangleNode *triangleNode = triangles.Add(triangle);
    
    FPNode<TriangleNode *> *parentNode1 = v1->parentTriangles.Add(triangleNode);
    FPNode<TriangleNode *> *parentNode2 = v2->parentTriangles.Add(triangleNode);
    FPNode<TriangleNode *> *parentNode3 = v3->parentTriangles.Add(triangleNode);
    
    triangle->childVertices.Add(VertexTrianglePair(vertexNode1, parentNode1));
    triangle->childVertices.Add(VertexTrianglePair(vertexNode2, parentNode2));
    triangle->childVertices.Add(VertexTrianglePair(vertexNode3, parentNode3));
    
    FPEdge *edgeV1V2 = new FPEdge();
    EdgeNode *edgeV1V2Node = edges.Add(edgeV1V2);
    FPEdge *edgeV1V3 = new FPEdge();
    EdgeNode *edgeV1V3Node = edges.Add(edgeV1V3);
    FPEdge *edgeV2V3 = new FPEdge();
    EdgeNode *edgeV2V3Node = edges.Add(edgeV2V3);
    
    FPNode<EdgeNode *> *parentEdgeV1V2 = v1->parentEdges.Add(edgeV1V2Node);
    FPNode<EdgeNode *> *parentEdgeV1V3 = v1->parentEdges.Add(edgeV1V3Node);
    
    FPNode<EdgeNode *> *parentEdgeV2V3 = v2->parentEdges.Add(edgeV2V3Node);
    FPNode<EdgeNode *> *parentEdgeV2V1 = v2->parentEdges.Add(edgeV1V2Node);
    
    FPNode<EdgeNode *> *parentEdgeV3V1 = v3->parentEdges.Add(edgeV1V3Node);
    FPNode<EdgeNode *> *parentEdgeV3V2 = v3->parentEdges.Add(edgeV2V3Node);
    
    edgeV1V2->childVertices.Add(VertexEdgePair(vertexNode1, parentEdgeV1V2));
    edgeV1V2->childVertices.Add(VertexEdgePair(vertexNode2, parentEdgeV2V1));
    
    edgeV1V3->childVertices.Add(VertexEdgePair(vertexNode1, parentEdgeV1V3));
    edgeV1V3->childVertices.Add(VertexEdgePair(vertexNode3, parentEdgeV3V1));
    
    edgeV2V3->childVertices.Add(VertexEdgePair(vertexNode2, parentEdgeV2V3));
    edgeV2V3->childVertices.Add(VertexEdgePair(vertexNode3, parentEdgeV3V2));
}

void FPTriangleMesh::CreateQuadAtPoint(CGPoint point, float s)
{
    FPVertex *v1 = new FPVertex(point.x - s, point.y - s);
    VertexNode *vertexNode1 = vertices.Add(v1);
    
    FPVertex *v2 = new FPVertex(point.x - s, point.y + s);
    VertexNode *vertexNode2 = vertices.Add(v2);
    
    FPVertex *v3 = new FPVertex(point.x + s, point.y - s);
    VertexNode *vertexNode3 = vertices.Add(v3);
    
    FPVertex *v4 = new FPVertex(point.x + s, point.y + s);
    VertexNode *vertexNode4 = vertices.Add(v4);

    FPTriangle *triangle1 = new FPTriangle();
    FPTriangle *triangle2 = new FPTriangle();
    TriangleNode *triangleNode1 = triangles.Add(triangle1);
    TriangleNode *triangleNode2 = triangles.Add(triangle2);    
    
    FPNode<TriangleNode *> *parentNode11 = v1->parentTriangles.Add(triangleNode1);
    FPNode<TriangleNode *> *parentNode12 = v2->parentTriangles.Add(triangleNode1);
    FPNode<TriangleNode *> *parentNode13 = v3->parentTriangles.Add(triangleNode1);
    
    FPNode<TriangleNode *> *parentNode22 = v2->parentTriangles.Add(triangleNode2);
    FPNode<TriangleNode *> *parentNode23 = v3->parentTriangles.Add(triangleNode2);
    FPNode<TriangleNode *> *parentNode24 = v4->parentTriangles.Add(triangleNode2);
    
    triangle1->childVertices.Add(VertexTrianglePair(vertexNode1, parentNode11));
    triangle1->childVertices.Add(VertexTrianglePair(vertexNode2, parentNode12));
    triangle1->childVertices.Add(VertexTrianglePair(vertexNode3, parentNode13));
   
    triangle2->childVertices.Add(VertexTrianglePair(vertexNode2, parentNode22));
    triangle2->childVertices.Add(VertexTrianglePair(vertexNode3, parentNode23));
    triangle2->childVertices.Add(VertexTrianglePair(vertexNode4, parentNode24));
    
    FPEdge *edgeV1V2 = new FPEdge();
    EdgeNode *edgeV1V2Node = edges.Add(edgeV1V2);
    FPEdge *edgeV1V3 = new FPEdge();
    EdgeNode *edgeV1V3Node = edges.Add(edgeV1V3);
    FPEdge *edgeV2V3 = new FPEdge();
    EdgeNode *edgeV2V3Node = edges.Add(edgeV2V3);
    FPEdge *edgeV3V4 = new FPEdge();
    EdgeNode *edgeV3V4Node = edges.Add(edgeV3V4);
    FPEdge *edgeV2V4 = new FPEdge();
    EdgeNode *edgeV2V4Node = edges.Add(edgeV2V4);
    
    FPNode<EdgeNode *> *parentEdgeV1V2 = v1->parentEdges.Add(edgeV1V2Node);
    FPNode<EdgeNode *> *parentEdgeV1V3 = v1->parentEdges.Add(edgeV1V3Node);
    
    FPNode<EdgeNode *> *parentEdgeV2V3 = v2->parentEdges.Add(edgeV2V3Node);
    FPNode<EdgeNode *> *parentEdgeV2V1 = v2->parentEdges.Add(edgeV1V2Node);
    
    FPNode<EdgeNode *> *parentEdgeV3V1 = v3->parentEdges.Add(edgeV1V3Node);
    FPNode<EdgeNode *> *parentEdgeV3V2 = v3->parentEdges.Add(edgeV2V3Node);
    
    FPNode<EdgeNode *> *parentEdgeV3V4 = v3->parentEdges.Add(edgeV3V4Node);
    FPNode<EdgeNode *> *parentEdgeV4V3 = v4->parentEdges.Add(edgeV3V4Node);
    
    FPNode<EdgeNode *> *parentEdgeV2V4 = v2->parentEdges.Add(edgeV2V4Node);
    FPNode<EdgeNode *> *parentEdgeV4V2 = v4->parentEdges.Add(edgeV2V4Node);
    
    edgeV1V2->childVertices.Add(VertexEdgePair(vertexNode1, parentEdgeV1V2));
    edgeV1V2->childVertices.Add(VertexEdgePair(vertexNode2, parentEdgeV2V1));
    
    edgeV1V3->childVertices.Add(VertexEdgePair(vertexNode1, parentEdgeV1V3));
    edgeV1V3->childVertices.Add(VertexEdgePair(vertexNode3, parentEdgeV3V1));
    
    edgeV2V3->childVertices.Add(VertexEdgePair(vertexNode2, parentEdgeV2V3));
    edgeV2V3->childVertices.Add(VertexEdgePair(vertexNode3, parentEdgeV3V2));
    
    edgeV3V4->childVertices.Add(VertexEdgePair(vertexNode3, parentEdgeV3V4));
    edgeV3V4->childVertices.Add(VertexEdgePair(vertexNode4, parentEdgeV4V3));
    
    edgeV2V4->childVertices.Add(VertexEdgePair(vertexNode2, parentEdgeV2V4));
    edgeV2V4->childVertices.Add(VertexEdgePair(vertexNode4, parentEdgeV4V2));
}

VertexNode *FPTriangleMesh::GetHighlightedVertex(CGPoint location, bool deform, float viewZoom)
{
    float s = 8.0f / sqrtf(viewZoom);
    CGRect mouseRect = CGRectMake(location.x - s, location.y - s, s * 2.0f, s * 2.0f);
    
    __block VertexNode *highlighted = NULL;
    
    vertices.Iterate(^(VertexNode *node, bool *stop) 
    {
        CGPoint point;
        if (deform)
            point = CGPointMake(node->data->dx, node->data->dy);
        else
            point = CGPointMake(node->data->x, node->data->y);

        if (CGRectContainsPoint(mouseRect, point))
        {
            highlighted = node;
            *stop = true;
        }
    });
    
    return highlighted;
}

void FPTriangleMesh::Draw(VertexNode *highlightedVertexNode, float width, float height, bool textured)
{
    if (textured)
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    else
        glColor4f(1.0f, 1.0f, 1.0f, 0.2f);

    glBegin(GL_TRIANGLES);
    
    triangles.Iterate(^(TriangleNode *triNode, bool *triStop)
    {
        triNode->data->childVertices.Iterate(^(FPNode<VertexTrianglePair> *pairNode, bool *pairStop)
        {
            FPVertex *vertex = pairNode->data.first->data;
            if (textured)
            {
                glTexCoord2f(vertex->x / width, vertex->y / height);
                glVertex2f(vertex->dx, vertex->dy);
            }
            else
            {
                glVertex2f(vertex->x, vertex->y);
            }
        });
    });
    
    glEnd();
    
    glDisable(GL_TEXTURE_2D);
    
    glColor4f(1.0f, 1.0f, 1.0f, 0.6f);
    
    edges.Iterate(^(EdgeNode *edgeNode, bool *eStop) 
    { 
        glBegin(GL_LINES);
        
        edgeNode->data->childVertices.Iterate(^(FPNode<VertexEdgePair> *pairNode, bool *pairStop) 
        {  
            FPVertex *vertex = pairNode->data.first->data;
            if (textured)
                glVertex2f(vertex->dx, vertex->dy);
            else
                glVertex2f(vertex->x, vertex->y);
        });
        
        glEnd();
    });
    
    glPointSize(6.0f);
    glBegin(GL_POINTS);
    
    vertices.Iterate(^(VertexNode *vertexNode, bool *vStop) 
    {
        CGPoint point;
        if (textured)
            point = CGPointMake(vertexNode->data->dx, vertexNode->data->dy);
        else
            point = CGPointMake(vertexNode->data->x, vertexNode->data->y);
     
        if (vertexNode == highlightedVertexNode)
            glColor4f(1.0f, 1.0f, 0.0f, 1.0f);
        else if (vertexNode->data->selected)
            glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
        else
            glColor4f(0.0f, 0.6f, 1.0f, 1.0f);
     
        glVertex2f(point.x, point.y);
    });
    
    glEnd();
}

void FPTriangleMesh::DeselectAll()
{
    vertices.Iterate(^(VertexNode *vertexNode, bool *vStop) 
    {
        vertexNode->data->selected = NO;
    });
}

void FPTriangleMesh::Select(MMSelectionMode selectionMode, CGRect rect, bool deform, float viewZoom)
{
    float s = 8.0f / sqrtf(viewZoom);
    CGRect mouseRect = CGRectMake(rect.origin.x - s, rect.origin.y - s, s * 2.0f, s * 2.0f);
    
    bool selectOne = false;
    
    if (rect.size.width < s || rect.size.height < s)
    {
        rect = mouseRect;
        selectOne = true;
    }
    
    if (selectionMode == MMSelectionModeSingle)
        DeselectAll();
    
    vertices.Iterate(^(VertexNode *vertexNode, bool *vStop) 
    {
        FPVertex *vertex = vertexNode->data;
         
        CGPoint point;
        if (deform)
            point = CGPointMake(vertex->dx, vertex->dy);
        else
            point = CGPointMake(vertex->x, vertex->y);

        if (CGRectContainsPoint(rect, point))
        {
            if (selectionMode == MMSelectionModeToggle)
                vertex->selected = !vertex->selected;
            else
                vertex->selected = true;

            if (selectOne)
                *vStop = true;
        }
    });
}

void FPTriangleMesh::MoveSelectedVertices(CGPoint offset, bool deform)
{
    vertices.Iterate(^(VertexNode *vertexNode, bool *vStop) 
    {
        FPVertex *vertex = vertexNode->data;
        if (vertex->selected)
        {
            if (deform)
            {
                vertex->dx += offset.x;
                vertex->dy += offset.y;
            }
            else
            {
                vertex->x += offset.x;
                vertex->y += offset.y;
            }
        }
    });
}

void FPTriangleMesh::ResetDeformed()
{
    vertices.Iterate(^(VertexNode *vertexNode, bool *vStop) 
    {
        FPVertex *vertex = vertexNode->data;
        vertex->dx = vertex->x;
        vertex->dy = vertex->y;
    });
}

void FPTriangle::RemoveFromVertices()
{
    childVertices.Iterate(^(FPNode<VertexTrianglePair> *pairNode, bool *pairStop)
    { 
        pairNode->data.first->data->parentTriangles.Remove(pairNode->data.second);
    });
    
    childVertices.RemoveAll();
}

void FPEdge::RemoveFromVertices()
{
    childVertices.Iterate(^(FPNode<VertexEdgePair> *pairNode, bool *pairStop) 
    { 
        pairNode->data.first->data->parentEdges.Remove(pairNode->data.second);
    });
    
    childVertices.RemoveAll();
}

void FPTriangle::RemoveVertex(FPVertex *vertex)
{
    childVertices.Iterate(^(FPNode<VertexTrianglePair> *pairNode, bool *pairStop)
    {
        VertexTrianglePair pair = pairNode->data;
        if (pair.first->data != vertex)
            return;
        
        childVertices.Remove(pairNode);
        *pairStop = true;
    });
}

bool FPTriangle::ContainsVertex(FPVertex *vertex)
{
    __block bool contains = false;
    
    childVertices.Iterate(^(FPNode<VertexTrianglePair> *pairNode, bool *pairStop)
    {
        VertexTrianglePair pair = pairNode->data;
        if (pair.first->data != vertex)
            return;
        
        contains = true;
        *pairStop = true;
    });
    
    return contains;
}

void FPEdge::RemoveVertex(FPVertex *vertex)
{
    childVertices.Iterate(^(FPNode<VertexEdgePair> *pairNode, bool *pairStop)
    {
        VertexEdgePair pair = pairNode->data;
        if (pair.first->data != vertex)
            return;
        
        childVertices.Remove(pairNode);
        *pairStop = true;
    });
}

bool FPEdge::ContainsVertex(FPVertex *vertex)
{
    __block bool contains = false;
    
    childVertices.Iterate(^(FPNode<VertexEdgePair> *pairNode, bool *pairStop)
    {
        VertexEdgePair pair = pairNode->data;
        if (pair.first->data != vertex)
            return;
        
        contains = true;
        *pairStop = true;
    });
    
    return contains;
}

VertexNode *FPEdge::OtherVertex(FPVertex *vertex)
{
    __block VertexNode *otherVertex = NULL;
    
    childVertices.Iterate(^(FPNode<VertexEdgePair> *node, bool *stop) 
    {
        if (node->data.first->data != vertex)
        {
            otherVertex = node->data.first;
            *stop = true;
        }        
    });
    
    return otherVertex;
}

void FPTriangleMesh::CollapseToVertex(VertexNode *vertexNode, VertexNode *collapsedNode)
{
    vertexNode->data->parentTriangles.Iterate(^(FPNode<TriangleNode *> *triNodeNode, bool *triStop)
    {
        TriangleNode *triNode = triNodeNode->data;    
        triNode->data->RemoveVertex(vertexNode->data);        
        if (triNode->data->childVertices.Count() > 1)
            collapsedNode->data->parentTriangles.Add(triNode);
    });
    
    vertexNode->data->parentEdges.Iterate(^(FPNode<EdgeNode *> *edgeNodeNode, bool *eStop) 
    {
        EdgeNode *edgeNode = edgeNodeNode->data;
        VertexNode* otherNode = edgeNode->data->OtherVertex(vertexNode->data);        
        edgeNode->data->RemoveFromVertices();
        RemoveEdge(edgeNode);
        
        if (otherNode == collapsedNode)
            return;
        
        if (otherNode->data->parentEdges.Last()->data->data->OtherVertex(otherNode->data) == collapsedNode)
            return;
        
        FPEdge *newEdge = new FPEdge();
        EdgeNode *newNode = edges.Add(newEdge);
        FPNode<EdgeNode *> *otherEdgeNode = otherNode->data->parentEdges.Add(newNode);
        FPNode<EdgeNode *> *collapsedEdgeNode = collapsedNode->data->parentEdges.Add(newNode);        
        
        newEdge->childVertices.Add(VertexEdgePair(otherNode, otherEdgeNode));
        newEdge->childVertices.Add(VertexEdgePair(collapsedNode, collapsedEdgeNode));        
    });
    
    RemoveVertex(vertexNode);
}

void FPTriangleMesh::CollapseSelectedVertices()
{
    NSLog(@"Collapse");
    
    __block int count = 0;
    FPVertex *collapsedVertex = new FPVertex(0.0f, 0.0f);
    VertexNode *collapsedNode = vertices.Add(collapsedVertex);    
    
    vertices.Iterate(^(VertexNode *vertexNode, bool *vStop)
    {
        FPVertex *vertex = vertexNode->data;
        if (!vertex->selected)
            return;
         
        collapsedVertex->x += vertex->x;
        collapsedVertex->y += vertex->y;
        count++;
        
        CollapseToVertex(vertexNode, collapsedNode);
    });
    
    float div = count;
    
    collapsedVertex->x /= div;
    collapsedVertex->y /= div;
    
    collapsedVertex->dx = collapsedVertex->x;
    collapsedVertex->dy = collapsedVertex->y;
    
    collapsedVertex->parentTriangles.Iterate(^(FPNode<TriangleNode *> *triNodeNode, bool *triStop) 
    {
        FPTriangle *triangle = triNodeNode->data->data;
        if (triangle->childVertices.Count() < 2)
        {
            triangle->childVertices.Iterate(^(FPNode<VertexTrianglePair> *pairNode, bool *pairStop)
            {
                triangle->RemoveFromVertices();
                VertexNode *pairVertexNode = pairNode->data.first;
                if (pairVertexNode->data->parentTriangles.Count() <= 0)
                {
                    pairVertexNode->data->parentEdges.Iterate(^(FPNode<EdgeNode *> *edgeNodeNode, bool *eStop) 
                    {
                        EdgeNode *edgeNode = edgeNodeNode->data;
                        edgeNode->data->RemoveFromVertices();
                        RemoveEdge(edgeNode);
                    });
                    RemoveVertex(pairVertexNode);
                }                
            });
            RemoveTriangle(triNodeNode->data);
            collapsedVertex->parentTriangles.Remove(triNodeNode);
        }
        else
        {
            triangle->childVertices.Add(VertexTrianglePair(collapsedNode, triNodeNode));
        }
    });
    
    if (collapsedVertex->parentTriangles.Count() == 0)
        RemoveVertex(collapsedNode);
}

void FPTriangleMesh::RemoveVertex(VertexNode *vertexNode)
{
    delete vertexNode->data;
    vertexNode->data = NULL;
    vertices.Remove(vertexNode);
}

void FPTriangleMesh::RemoveTriangle(TriangleNode *triangleNode)
{
    delete triangleNode->data;
    triangleNode->data = NULL;
    triangles.Remove(triangleNode);
}

void FPTriangleMesh::RemoveEdge(EdgeNode *edgeNode)
{
    delete edgeNode->data;
    edgeNode->data = NULL;
    edges.Remove(edgeNode);
}

void FPTriangleMesh::BreakVertex(VertexNode *vertexNode)
{
    FPVertex *vertex = vertexNode->data;
    
    if (vertex->parentTriangles.Count() < 2)
        return;

    vertex->parentTriangles.Iterate(^(FPNode<TriangleNode *> *triNodeNode, bool *triStop) 
    { 
        FPTriangle *triangle = triNodeNode->data->data;
        FPVertex *newVertex = new FPVertex(vertex->x, vertex->y);        
        VertexNode *newVertexNode = vertices.Add(newVertex);
        
        triangle->RemoveVertex(vertex);
        
        vertex->parentEdges.Iterate(^(FPNode<EdgeNode *> *edgeNodeNode, bool *edgeStop) 
        {  
            FPEdge *edge = edgeNodeNode->data->data;
            VertexNode *otherVertexNode = edge->OtherVertex(vertex);
            FPVertex *otherVertex = otherVertexNode->data;
            
            if (triangle->ContainsVertex(otherVertex))
            {
                FPEdge *newEdge = new FPEdge();
                EdgeNode *newEdgeNode = edges.Add(newEdge);
                
                FPNode<EdgeNode *> *newEdgeNodeNode = newVertex->parentEdges.Add(newEdgeNode);
                FPNode<EdgeNode *> *otherEdgeNodeNode = otherVertex->parentEdges.Add(newEdgeNode);
                
                newEdge->childVertices.Add(VertexEdgePair(newVertexNode, newEdgeNodeNode));
                newEdge->childVertices.Add(VertexEdgePair(otherVertexNode, otherEdgeNodeNode));
            }
        });
        
        triangle->childVertices.Add(VertexTrianglePair(newVertexNode, triNodeNode));
        newVertex->parentTriangles.Add(triNodeNode->data);
    });
    
    vertex->parentEdges.Iterate(^(FPNode<EdgeNode *> *edgeNodeNode, bool *edgeStop) 
    { 
        EdgeNode *edgeNode = edgeNodeNode->data;
        edgeNode->data->RemoveFromVertices();
        RemoveEdge(edgeNode);
    });
    
    RemoveVertex(vertexNode);
}

bool FPTriangleMesh::GetRotationToolCenterAndSize(bool deform, CGPoint &toolCenter, float &toolSize)
{
    __block CGPoint center = CGPointZero;
    __block int count = 0;
    
    vertices.Iterate(^(VertexNode *node, bool *stop) 
    { 
        FPVertex *vertex = node->data;
        if (vertex->selected)
        {
            if (!deform)
            {
                center.x += vertex->x;
                center.y += vertex->y;
            }
            else
            {
                center.x += vertex->dx;
                center.y += vertex->dy;
            }
            count++;
        }
    });
    
    if (count <= 1)
        return false;
    
    center.x /= (float)count;
    center.y /= (float)count;
    
    toolCenter = center;
    toolSize = 60.0f;
    
    return true;
}

void FPTriangleMesh::DrawRotationTool(bool highlighted, bool deform)
{
    CGPoint center;
    float size;
    
    if (!GetRotationToolCenterAndSize(deform, center, size))
        return;
    
    glDisable(GL_TEXTURE_2D);
    if (highlighted)
        glColor4f(1.0f, 1.0f, 0.0f, 1.0f);
    else
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    
    const int steps = 32;
    
    glPushMatrix();
    glTranslatef(center.x, center.y, 0.0f);
    glBegin(GL_LINE_LOOP);
    
    const float step = (M_PI * 2.0f) / (float)steps;
    
    for (int i = 0; i < steps; i++)
    {
        float x = sinf(step * (float)i) * size;
        float y = cosf(step * (float)i) * size;
        
        glVertex2f(x, y);
    }
    
    glEnd();
    glPopMatrix();
}

bool FPTriangleMesh::IsNearRotationTool(CGPoint location, bool deform)
{
    CGPoint center;
    float size;
    
    if (!GetRotationToolCenterAndSize(deform, center, size))
        return false;

    center.x -= location.x;
    center.y -= location.y;
    
    float squaredSize = center.x * center.x + center.y * center.y;
    if (fabsf(squaredSize - size * size) < 800.0f)
        return true;
    return false;
}

CGPoint RotatePoint(CGPoint point, float angle)
{
    CGPoint rotated = point;
    float sin = sinf(angle);
    float cos = cosf(angle);
    rotated.x = point.x * cos - point.y * sin;
    rotated.y = point.x * sin + point.y * cos;
    return rotated;
}

void FPTriangleMesh::RotateSelectedVertices(CGPoint lastLocation, CGPoint currentLocation, bool deform)
{
    CGPoint center;
    float size;
    
    if (!GetRotationToolCenterAndSize(deform, center, size))
        return;
    
    lastLocation.x -= center.x;
    lastLocation.y -= center.y;
    currentLocation.x -= center.x;
    currentLocation.y -= center.y;
    
    float angle = atan2f(currentLocation.y, currentLocation.x) - atan2f(lastLocation.y, lastLocation.x);
    
    vertices.Iterate(^(VertexNode *node, bool *stop) 
    {  
        FPVertex *vertex = node->data;
        if (vertex->selected)
        {
            if (deform)
            {
                CGPoint rotated = RotatePoint(CGPointMake(vertex->dx - center.x, vertex->dy - center.y), angle);
                vertex->dx = rotated.x + center.x;
                vertex->dy = rotated.y + center.y;                
            }
            else
            {
                CGPoint rotated = RotatePoint(CGPointMake(vertex->x - center.x, vertex->y - center.y), angle);
                vertex->x = rotated.x + center.x;
                vertex->y = rotated.y + center.y;
            }
        }
    });
}
