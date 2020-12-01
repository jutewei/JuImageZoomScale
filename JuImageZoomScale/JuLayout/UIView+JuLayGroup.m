//
//  UIView+JuLayoutFrame.m
//  JuLayout
//
//  Created by Juvid on 16/7/17.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "UIView+JuLayGroup.h"
#import "JuLayoutFrame.h"
@implementation UIView(JuLayGroup)

-(void(^)(UIView *view))juOriginEqual{
    return ^(UIView *view){
        self.juLead.toView(view).equal(0);
        self.juTop.toView(view).equal(0);
    };
}
-(void(^)(UIView *view))juSizeEqual{
    return ^(UIView *view){
        self.juWidth.toView(view).equal(0);
        self.juHeight.toView(view).equal(0);
    };
}
-(void(^)(UIView *view))juFrameEqual{
    return ^(UIView *view){
        self.juOriginEqual(view);
        self.juSizeEqual(view);
    };
}

-(void(^)(CGPoint origin))juOrigin{
    return ^(CGPoint origin){
        if(origin.x>0) {
            self.juLead.equal(origin.x);
        }else if(origin.x<0){
            self.juTrail.equal(-origin.x);
        }else{
            self.juCenterX.equal(0);
        }
        if(origin.y>0) {
            self.juTop.equal(origin.y);
        }else if(origin.y<0){
            self.juBottom.equal(-origin.y);
        }else{
            self.juCenterY.equal(0);
        }
    };
}
-(void(^)(CGPoint origin))juSafeOrigin{
    return ^(CGPoint origin){
        if(origin.x>0) {
            self.juLead.safe.equal(origin.x);
        }else if(origin.x<0){
            self.juTrail.safe.equal(-origin.x);
        }else{
            self.juCenterX.equal(0);
        }
        if(origin.y>0) {
            self.juTop.safe.equal(origin.y);
        }else if(origin.y<0){
            self.juBottom.safe.equal(-origin.y);
        }else{
            self.juCenterY.equal(0);
        }
    };
}
-(void(^)(CGSize size))juSize{
    return ^(CGSize size){
        self.juWidth.equal(size.width);
        self.juHeight.equal(size.height);
    };
}
-(void(^)(CGRect frame))juFrame{
    return ^(CGRect frame){
        self.juOrigin(frame.origin);
        self.juSize(frame.size);
    };
}
-(void(^)(CGRect frame))juSafeFrame{
    return ^(CGRect frame){
        self.juSafeOrigin(frame.origin);
        self.juSize(frame.size);
    };
}
-(void(^)(UIEdgeInsets edge))juEdge{
    return ^(UIEdgeInsets edge){
        self.juEdgeTo(edge,nil);
    };
}
-(void(^)(UIEdgeInsets edge))juSafeEdge{
    return ^(UIEdgeInsets edge){
        self.juLead.safe.equal(edge.left);
        self.juTrail.safe.equal(edge.right);
        self.juTop.safe.equal(edge.top);
        self.juBottom.safe.equal(edge.bottom);
    };
}
-(void(^)(UIEdgeInsets edge,UIView *view))juEdgeTo{
    return ^(UIEdgeInsets edge,UIView *view){
        self.juLead.toView(view).equal(edge.left);
        self.juTrail.toView(view).equal(edge.right);
        self.juTop.toView(view).equal(edge.top);
        self.juBottom.toView(view).equal(edge.bottom);
    };
}

-(void(^)(JuLayEdgeHeight juEdgeH))juEdgeH{
    return ^(JuLayEdgeHeight juEdgeH){
        self.juEdgeHTo(juEdgeH,nil);
    };
}

-(void(^)(JuLayEdgeHeight juEdgeH))juSafeEdgeH{
    return ^(JuLayEdgeHeight juEdgeH){
        self.juLead.safe.equal(juEdgeH.lead);
        self.juTrail.safe.equal(juEdgeH.trail);
        if(juEdgeH.y>0) {
            self.juTop.safe.equal(juEdgeH.y);
        }else if(juEdgeH.y==0){
            self.juCenterY.equal(juEdgeH.y);
        }else{
            self.juBottom.safe.equal(-juEdgeH.y);
        }
        if(juEdgeH.height>0) {
            self.juHeight.equal(juEdgeH.height);
        }

    };

}

-(void(^)(JuLayEdgeHeight juEdgeH,UIView *view))juEdgeHTo{
    return ^(JuLayEdgeHeight juEdgeH,UIView *view){
        self.juLead.toView(view).equal(juEdgeH.lead);
        self.juTrail.toView(view).equal(juEdgeH.trail);
        if(juEdgeH.y>0) {
            self.juTop.toView(view).equal(juEdgeH.y);
        }else if(juEdgeH.y==0){
            self.juCenterY.toView(view).equal(juEdgeH.y);
        }else{
            self.juBottom.toView(view).equal(-juEdgeH.y);
        }
        if(juEdgeH.height>0) {
            self.juHeight.toView(view).equal(juEdgeH.height);
        }

    };

}
-(void(^)(JuLayEdgeWidth juEdgeW))juEdgeW{
    return ^(JuLayEdgeWidth juEdgeW){
        self.juEdgeWTo(juEdgeW,nil);
    };

}
-(void(^)(JuLayEdgeWidth juEdgeW))juSafeEdgeW{
    return ^(JuLayEdgeWidth juEdgeW){
        self.juTop.safe.equal(juEdgeW.top);
        self.juBottom.safe.equal(juEdgeW.bottom);

        if(juEdgeW.x>0) {
            self.juLead.safe.equal(juEdgeW.x);
        }else if(juEdgeW.x==0){
            self.juCenterX.equal(juEdgeW.x);
        }else{
            self.juTrail.safe.equal(-juEdgeW.x);
        }
        if(juEdgeW.width>0) {
            self.juWidth.equal(juEdgeW.width);
        }
    };

}
-(void(^)(JuLayEdgeWidth juEdgeW,UIView *view))juEdgeWTo{
    return ^(JuLayEdgeWidth juEdgeW,UIView *view){
        self.juTop.toView(view).equal(juEdgeW.top);
        self.juBottom.toView(view).equal(juEdgeW.bottom);

        if(juEdgeW.x>0) {
            self.juLead.toView(view).equal(juEdgeW.x);
        }else if(juEdgeW.x==0){
            self.juCenterX.toView(view).equal(juEdgeW.x);
        }else{
            self.juTrail.toView(view).equal(-juEdgeW.x);
        }
        if(juEdgeW.width>0) {
            self.juWidth.toView(view).equal(juEdgeW.width);
        }
    };

}


@end
