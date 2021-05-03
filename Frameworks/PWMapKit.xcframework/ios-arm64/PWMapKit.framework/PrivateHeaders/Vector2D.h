//
//  Vector2D.h
//  PWMapKit
//
//  Created by Sam Odom on 8/27/14.
//  Copyright (c) 2014 Phunware. All rights reserved.
//

typedef struct {
    double x;
    double y;
} Vector2D;


Vector2D Vector2DMake(double x, double y);

Vector2D Vector2DAdd(Vector2D vector1, Vector2D vector2);
Vector2D Vector2DSubtract(Vector2D vector1, Vector2D vector2);
Vector2D Vector2DMultiply(Vector2D vector, double scalar);

double Vector2DLength(Vector2D vector);
double Vector2DDotProduct(Vector2D vector1, Vector2D vector2);


