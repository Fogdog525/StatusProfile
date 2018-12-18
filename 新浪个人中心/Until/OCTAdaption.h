//
//  OCTAdaption.h
//  SinaMVVM
//
//  Created by SD on 2018/11/5.
//  Copyright © 2018年 Mr.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef OCTAdaption_h
#define OCTAdaption_h

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
//参考尺寸  6s
#define REFERENCEWIDTH  375.f
#define REFERENCEHEIGHT 667.f

static inline CGFloat AAdaptionWidth() {
    return REFERENCEWIDTH/REFERENCEWIDTH;
}
static inline CGFloat AAdaption(CGFloat x) {
    return x * AAdaptionWidth();
}
static inline CGSize AAdaptionSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * AAdaptionWidth();
    CGFloat newHeight = height * AAdaptionWidth();
    return CGSizeMake(newWidth, newHeight);
}
static inline CGPoint AAadaptionPoint(CGFloat x, CGFloat y) {
    CGFloat newX = x * AAdaptionWidth();
    CGFloat newY = y * AAdaptionWidth();
    return  CGPointMake(newX, newY);
}
static inline CGRect AAdaptionRect(CGFloat x, CGFloat y, CGFloat width, CGFloat height){
    CGFloat newX = x*AAdaptionWidth();
    CGFloat newY = y*AAdaptionWidth();
    CGFloat newW = width*AAdaptionWidth();
    CGFloat newH = height*AAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}
static inline CGRect AAdaptionRectFromFrame(CGRect frame){
    CGFloat newX = frame.origin.x*AAdaptionWidth();
    CGFloat newY = frame.origin.y*AAdaptionWidth();
    CGFloat newW = frame.size.width*AAdaptionWidth();
    CGFloat newH = frame.size.height*AAdaptionWidth();
    return CGRectMake(newX, newY, newW, newH);
}
static inline UIFont * AAFont(CGFloat font){
    return [UIFont systemFontOfSize:font*AAdaptionWidth()];
}
static inline UIFont * AABoldFont(CGFloat font){
    return [UIFont boldSystemFontOfSize:font*AAdaptionWidth()];
}
#endif
