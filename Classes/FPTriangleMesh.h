//
//  FPTriangleMesh.h
//  GLMotionMaker
//
//  Created by Filip Kunc on 10/16/10.
//  For license see LICENSE.TXT
//

#import <utility>
#import "FPList.h"

typedef enum
{
    MMEditorModeTriangles = 0,
    MMEditorModeQuads = 1,
    MMEditorModeRig = 2,
    MMEditorModeDeform = 3,
} MMEditorMode;

typedef enum
{
    MMSelectionModeSingle = 0,
    MMSelectionModeToggle = 1,
    MMSelectionModeAdd = 2,
} MMSelectionMode;

class FPVertex;
class FPTriangle;
class FPEdge;

typedef FPNode<FPVertex *> VertexNode;
typedef FPNode<FPTriangle *> TriangleNode;
typedef FPNode<FPEdge *> EdgeNode;

typedef std::pair<VertexNode *, FPNode<TriangleNode *> *> VertexTrianglePair;
typedef std::pair<VertexNode *, FPNode<EdgeNode *> *> VertexEdgePair;

class FPVertex
{
public:
    float x, y;
    float dx, dy;
    FPList<TriangleNode *> parentTriangles;
    FPList<EdgeNode *> parentEdges;
    
    bool selected;
    
    FPVertex(float x, float y);
};

class FPTriangle
{
public:
    FPList<VertexTrianglePair> childVertices;
    
    void RemoveFromVertices();
    void RemoveVertex(FPVertex *vertex);
    bool ContainsVertex(FPVertex *vertex);
};

class FPEdge
{
public:
    FPList<VertexEdgePair> childVertices;
    
    void RemoveFromVertices();
    void RemoveVertex(FPVertex *vertex);
    bool ContainsVertex(FPVertex *vertex);
    VertexNode *OtherVertex(FPVertex *vertex); 
};

class FPTriangleMesh
{
public:
    FPList<FPVertex *> vertices;
    FPList<FPTriangle *> triangles;
    FPList<FPEdge *> edges;
public:
    FPTriangleMesh();
    ~FPTriangleMesh();
    
    void CreateTriangleAtPoint(CGPoint point, float s);
    void CreateQuadAtPoint(CGPoint point, float s);
    void Draw(VertexNode *highlightedVertexNode, float width, float height, bool textured);
    void DeselectAll();
    void Select(MMSelectionMode selectionMode, CGRect rect, bool deform, float viewZoom);
    void MoveSelectedVertices(CGPoint offset, bool deform);
    VertexNode *GetHighlightedVertex(CGPoint location, bool deform, float viewZoom);
    void ResetDeformed();
    void CollapseToVertex(VertexNode *vertexNode, VertexNode *collapsedNode);
    void CollapseSelectedVertices();
    
    void RemoveVertex(VertexNode *vertexNode);
    void RemoveTriangle(TriangleNode *triangleNode);
    void RemoveEdge(EdgeNode *edgeNode);

    bool GetRotationToolCenterAndSize(bool deform, CGPoint &toolCenter, float &toolSize);
    void DrawRotationTool(bool highlighted, bool deform);
    bool IsNearRotationTool(CGPoint location, bool deform);
    void RotateSelectedVertices(CGPoint lastLocation, CGPoint currentLocation, bool deform);
    
    void BreakVertex(VertexNode *vertexNode);
};
