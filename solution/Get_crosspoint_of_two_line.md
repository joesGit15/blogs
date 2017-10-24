### Get Two Line Crosspoint

#### Result Type

```
typedef enum CROSS_POINT_TYPE
{
    CPT_NO_CROSSPOINT = 0,          /* Two lines may be parallel or overlapped */

    CPT_WITHIN_L1 = 0x2,            /* The crosspoint is within the FIRST line segment */
    CPT_WITHIN_L2 = 0x4,            /* The crosspoint is within the SECOND line segment */ 

    /* The crosspoint is within the TWO line segments */
    CPT_WITHIN_L1_L2 = (CPT_WITHIN_L1|CPT_WITHIN_L2),  
    /* The crosspoint is WITHOUT the TWO line segments */
    CPT_WITHOUT_L1_L2 = 0x10,  
}CROSS_POINT_TYPE;
```

#### Description

Get the crosspoint of two lines which represented by their two endpoints;

RETURN : < 0, no crosspoint exists because the two lines may be parallel or overlapped

##### Algorithm description:

Given two point P0(x0,y0) P1(x1,y1), the line's parametric equation can be represented as
```
X = x0 + (x1 - x0) t
Y = y0 + (y1 - y0) t
```

where t is the parameter, for line segment P0P1, the corresponding range of t is [0, 1], For other case, refer to the following illustration
```
		       +
		     +    ------ t > 1
		   +
		P1
	     * 
	  *  ------------------- 0<= t <= 1 
      P0
    -
  -    -------------------------- t < 0
-
```

Given two parametric line equations

L1 : 
```
X = Ax0 + (Ax1 - Ax0) At 
Y = Ay0 + (Ay1 - Ay0) At
```

L2 : 
```
X = Bx0 + (Bx1 - Bx0) Bt 
Y = By0 + (By1 - By0) Bt
```

Eliminate X,Y and write it as
```
(Ax1 - Ax0) At + (Bx0 - Bx1) Bt = Bx0 - Ax0
(Ay1 - Ay0) At + (By0 - By1) Bt = By0 - Ay0
OR 
( a11  a12 ) ( At )     ( b1 )
(          ) (    )  =  (    )
( a21  a22 ) ( Bt )     ( b2 )
```

To solve the above equation set, compute

```
D =  |(Ax1 - Ax0)   (Bx0 - Bx1)| = |a11 a12|              (1)
     |(Ay1 - Ay0)   (By0 - By1)|   |a21 a22|         

D_At =  |(Bx0 - Ax0)  (Bx0 - Bx1)| = |b1 a12|             (2)
        |(By0 - Ay0)  (By0 - By1)|   |b2 a22|

D_Bt =  |(Ax1 - Ax0)  (Bx0 - Ax0)| = |a11 b1|             (3) 
        |(Ay1 - Ay0)  (By0 - Ay0)|   |a12 b2|

At = D_At / D                                             (4)
Bt = D_Bt / D
```

NOTE: If D = 0, the input two lines are parallel or overlapped

#### Code Snippet

```
CROSS_POINT_TYPE GetTwoLineCrosspoint(const int pnAx[2], const int pnAy[2],///< lineA
                                      const int pnBx[2], const int pnBy[2],///< lineB
                                      float o_pfCross[2])
{
    CROSS_POINT_TYPE Ret = CPT_NO_CROSSPOINT;

    int a11, a12, a21, a22, b1, b2;
    int D, D_At, D_Bt;
    float At, Bt;    

    /* Init axx and bx by equation (1) */
    a11 = pnAx[1] - pnAx[0];
    a12 = pnBx[0] - pnBx[1];    
    a21 = pnAy[1] - pnAy[0];
    a22 = pnBy[0] - pnBy[1];
    b1  = pnBx[0] - pnAx[0];
    b2  = pnBy[0] - pnAy[0];

    /* D : Equation (1) */
    D = a11 * a22 - a12 * a21;
    if(D == 0){
        return CPT_NO_CROSSPOINT;
    }

    /* D_At, D_Bt : Equation (2), (3) */
    D_At = b1 * a22 - a12 * b2;
    D_Bt = a11 * b2 - b1 * a21;

    /* At, Bt by equation (4) */
    At = (float)D_At / D;
    Bt = (float)D_Bt / D;

    /* Get the crosspoint location */
    if(0 <= At && At <= 1){    
        Ret = CPT_WITHIN_L1;
    }
    
    if(0 <= Bt && Bt <= 1){
        Ret |= CPT_WITHIN_L2;
    }
    
    if(Ret == CPT_NO_CROSSPOINT){
        Ret = CPT_WITHOUT_L1_L2;
    }

    /* Compute the cross points */
#if 1
    o_pfCross[0] = pnAx[0] + (pnAx[1] - pnAx[0]) * At;
    o_pfCross[1] = pnAy[0] + (pnAy[1] - pnAy[0]) * At;
#else
    o_pfCross[0] = pnBx[0] + (pnBx[1] - pnBx[0]) * Bt;
    o_pfCross[1] = pnBy[0] + (pnBy[1] - pnBy[0]) * Bt;
#endif

    return Ret;
}
```

---
