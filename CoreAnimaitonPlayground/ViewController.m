//
//  ViewController.m
//  CoreAnimaitonPlayground
//
//  Created by ys on 2017/5/15.
//  Copyright © 2017年 ys. All rights reserved.
//

#import "ViewController.h"

#define buttonName @[@"位移",@"缩放",@"透明度",@"旋转",@"圆角",@"srping动画",@"values晃动",@"path位移",@"转场动画",@"动画组"]

@interface ViewController ()<CAAnimationDelegate>
@property(nonatomic,strong)CALayer *aniLayer;
//
@property(nonatomic,strong)CADisplayLink *displayLink;
@end

@implementation ViewController{
    NSInteger _transtionIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.aniLayer = [[CALayer alloc] init];
    _aniLayer.bounds = CGRectMake(0, 0, 100, 100);
    _aniLayer.position = self.view.center;
    _aniLayer.backgroundColor = [UIColor redColor].CGColor;
    _aniLayer.contents = (id)[UIImage imageNamed:@"1.jpg"].CGImage;
    _transtionIndex = 1;
    [self.view.layer addSublayer:_aniLayer];
    //
    for (int i = 0; i < 10; i++) {
        UIButton *aniButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aniButton.tag = i;
        [aniButton setTitle:buttonName[i] forState:UIControlStateNormal];
        aniButton.exclusiveTouch = YES;
        aniButton.frame = CGRectMake(10, 50 + 60 * i, 100, 50);
        aniButton.backgroundColor = [UIColor blueColor];
        [aniButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aniButton];
    }
    //
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    _displayLink.frameInterval = 30;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)tapAction:(UIButton*)button{
    if (button.tag == 5) {
        [self springAnimation];
    }else if (button.tag >=0 && button.tag <= 4){
        [self basicAnimationWithTag:button.tag];
    }else if(button.tag > 5 && button.tag < 8){
        [self keyframeAnimationWithTag:button.tag];
    }else if (button.tag == 8){
        [self transitionAnimation];
    }else if (button.tag == 9){
        [self animationGroup];
    }
}

-(void)handleDisplayLink:(CADisplayLink *)displayLink{
    NSLog(@"modelLayer_%@,presentLayer_%@",[NSValue valueWithCGPoint:_aniLayer.position],[NSValue valueWithCGPoint:_aniLayer.presentationLayer.position]);
}

-(void)basicAnimationWithTag:(NSInteger)tag{
    CABasicAnimation *basicAni = nil;
    switch (tag) {
        case 0:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"position"];
            //到达位置
            basicAni.byValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
            break;
        case 1:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            //到达缩放
            basicAni.toValue = @(0.1f);
            break;
        case 2:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
            //透明度
            basicAni.toValue=@(0.1f);
            break;
        case 3:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"transform"];
            //3D
            basicAni.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2+M_PI_4, 1, 1, 0)];
            break;
        case 4:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            //圆角
            basicAni.toValue=@(50);
            break;
            
        default:
            break;
    }
    
    //设置代理
    basicAni.delegate = self;
    //延时执行
    //basicAni.beginTime = CACurrentMediaTime() + 2;
    //动画时间
    basicAni.duration = 1;
    //动画节奏
    basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画速率
    //basicAni.speed = 0.1;
    //图层是否显示执行后的动画执行后的位置以及状态
    basicAni.removedOnCompletion = NO;
    basicAni.fillMode = kCAFillModeForwards;
    //动画完成后是否以动画形式回到初始值
    //basicAni.autoreverses = YES;
    //动画时间偏移
    //basicAni.timeOffset = 0.5;
    //添加动画
    [_aniLayer addAnimation:basicAni forKey:NSStringFromSelector(_cmd)];
}

-(void)transformAnimation{
    //绕z轴旋转的动画
    CABasicAnimation * transformAni = [CABasicAnimation animationWithKeyPath:@"transform"];
    //从0度开始
    transformAni.fromValue = @0;
    //旋转到180度
    transformAni.toValue = [NSNumber numberWithFloat:M_PI];
    //duration
    transformAni.duration = 1;
    //设置valueFunction
    transformAni.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    //添加动画
    [_aniLayer addAnimation:transformAni forKey:@"transformAnimation"];
}

//弹簧动画
-(void)springAnimation{
    CASpringAnimation *springAni = [CASpringAnimation animationWithKeyPath:@"position"];
    springAni.damping = 2;
    springAni.delegate = self;
    springAni.stiffness = 50;
    springAni.mass = 1;
    springAni.initialVelocity = 10;
    springAni.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 400)];
    springAni.duration = springAni.settlingDuration;
    [_aniLayer addAnimation:springAni forKey:@"springAnimation"];
}
//关键帧动画
-(void)keyframeAnimationWithTag:(NSInteger)tag{
    CAKeyframeAnimation *keyFrameAni = nil;
    if (tag == 6) {
        //晃动
        keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        keyFrameAni.duration = 0.3;
        keyFrameAni.values = @[@(-(4) / 180.0*M_PI),@((4) / 180.0*M_PI),@(-(4) / 180.0*M_PI)];
        keyFrameAni.repeatCount=MAXFLOAT;
    }else if (tag == 7){
        //曲线位移
        keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:_aniLayer.position];
        [path addCurveToPoint:CGPointMake(300, 500) controlPoint1:CGPointMake(100, 400) controlPoint2:CGPointMake(300, 450)];
        keyFrameAni.path = path.CGPath;
        //keyFrameAni.rotationMode = kCAAnimationRotateAutoReverse;
        keyFrameAni.duration = 1;
        
    }
    keyFrameAni.delegate = self;
    [_aniLayer addAnimation:keyFrameAni forKey:@"keyFrameAnimation"];
}
//转场动画
-(void)transitionAnimation{
    CATransition *transtion = [CATransition animation];
    transtion.type = @"rippleEffect";
    transtion.subtype = kCATransitionFromLeft;//kCATransitionFromLeft  kCATransitionFromRight
    transtion.duration = 1;
    _transtionIndex++;
    if (_transtionIndex > 4) {
        _transtionIndex = 1;
    }
    _aniLayer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",@(_transtionIndex)]].CGImage;
    [_aniLayer addAnimation:transtion forKey:@"transtion"];
}

//动画组
-(void)animationGroup{
    //晃动动画
    CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    keyFrameAni.values = @[@(-(4) / 180.0*M_PI),@((4) / 180.0*M_PI),@(-(4) / 180.0*M_PI)];
    //每一个动画可以单独设置时间和重复次数,在动画组的时间基础上,控制单动画的效果
    keyFrameAni.duration = 0.3;
    keyFrameAni.repeatCount=MAXFLOAT;
    keyFrameAni.delegate = self;
    //
    //位移动画
    CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"position"];
    //到达位置
    basicAni.byValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    //
    basicAni.duration = 1;
    basicAni.repeatCount = 1;
    //
    basicAni.removedOnCompletion = NO;
    basicAni.fillMode = kCAFillModeForwards;
    //设置代理
    basicAni.delegate = self;
    //动画时间
    basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = @[keyFrameAni,basicAni];
    aniGroup.autoreverses = YES;
    //动画的表现时间和重复次数由动画组设置的决定
    aniGroup.duration = 3;
    aniGroup.repeatCount=MAXFLOAT;
    //
    [_aniLayer addAnimation:aniGroup forKey:@"groupAnimation"];
}

//暂停动画
-(void)animationPause{
    //获取当前layer的动画媒体时间
    CFTimeInterval interval = [_aniLayer convertTime:CACurrentMediaTime() toLayer:nil];
    //设置时间偏移量,保证停留在当前位置
    _aniLayer.timeOffset = interval;
    //暂定动画
    _aniLayer.speed = 0;
}
//恢复动画
-(void)animationResume{
    //获取暂停的时间
    CFTimeInterval beginTime = CACurrentMediaTime() - _aniLayer.timeOffset;
    //设置偏移量
    _aniLayer.timeOffset = 0;
    //设置开始时间
    _aniLayer.beginTime = beginTime;
    //开始动画
    _aniLayer.speed = 1;
}
//停止动画
-(void)animationStop{
    //[_aniLayer removeAllAnimations];
    //[_aniLayer removeAnimationForKey:@"groupAnimation"];
}

#pragma mark - CAAnimationDelegate
-(void)animationDidStart:(CAAnimation *)anim{
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
