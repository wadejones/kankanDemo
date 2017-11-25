//
//  ViewController.m
//  瞰看DEMO
//
//  Created by ZJM on 2017/11/14.
//  Copyright © 2017年 ZJM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIImageView  *quartrImage;//大厅背景
@property(nonatomic,strong)NSMutableArray *quartArray;//大厅素材组合
@property(nonatomic,strong)NSMutableArray *lightArray;//灯的组合
@property(nonatomic,strong)UIScrollView   *quartListView;//大厅的背景view
@property(nonatomic,strong)UIScrollView   *lightView;//灯的容器
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self initView];
}

- (void)initData
{
    _quartArray = [[NSMutableArray alloc]init];
    _lightArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 5; i++) {
        UIImageView  *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *quartGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quartFunc:)];
        [imageView addGestureRecognizer:quartGes];
        [_quartArray addObject:imageView];
    }
    
    for (int i = 1; i <= 10; i++) {
        UIImageView  *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"图层-%d.png",i]]];
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.tag = i - 1;
        //平移手势
        UITapGestureRecognizer *pan =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        //添加到指定视图
        [imageView addGestureRecognizer:pan];

        
        [_lightArray addObject:imageView];
    }
}

- (void)initView
{
    _quartrImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    _quartrImage.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    _quartrImage.userInteractionEnabled = YES;
    _quartrImage.image = ((UIImageView *)_quartArray[0]).image;
    [self.view addSubview:_quartrImage];
    
    _quartListView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20,self.view.frame.size.width, self.view.frame.size.height / 4)];
    [self setFrameForQuart];
    [self.view addSubview:_quartListView];

    _lightView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _quartrImage.frame.origin.y + _quartrImage.frame.size.height,self.view.frame.size.width,self.view.frame.size.height / 4)];
    [self setFrameForLights];
    [self.view addSubview:_lightView];

}

- (void)setFrameForQuart
{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < _quartArray.count; i++) {
            
            UIImageView *imageView = _quartArray[i];
            imageView.frame = CGRectMake((_quartListView.frame.size.height + 10) * i, 0, _quartListView.frame.size.height, _quartListView.frame.size.height);
            [_quartListView addSubview:imageView];
            _quartListView.contentSize = CGSizeMake(imageView.frame.origin.x + imageView.frame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setFrameForLights
{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < _lightArray.count; i++) {
            
            UIImageView *imageView = _lightArray[i];
            imageView.frame = CGRectMake((_lightView.frame.size.height/2 + 10) * i, 0, _lightView.frame.size.height/2, _lightView.frame.size.height/2);
            [_lightView addSubview:imageView];
            _lightView.contentSize = CGSizeMake(imageView.frame.origin.x + imageView.frame.size.width, 0);
        }

    } completion:^(BOOL finished) {
        
    }];
}

- (void)quartFunc:(UITapGestureRecognizer *)ges
{
    _quartrImage.image = ((UIImageView *)ges.view).image;
}


//创建平移事件
-(void)panAction:(UITapGestureRecognizer *)pan
{
    
    UIImageView *iamgeView = [UIImageView new];
    iamgeView.frame = CGRectMake(0, 0, pan.view.frame.size.width * 2, pan.view.frame.size.height * 2);
    iamgeView.userInteractionEnabled = YES;
    iamgeView.image = ((UIImageView *)pan.view).image;
    [_quartrImage addSubview:iamgeView];
    
    UIPanGestureRecognizer *panok =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panActionOK:)];
    panok.delegate = self;
    //添加到指定视图
    [iamgeView addGestureRecognizer:panok];
    
    //捏合手势
    UIPinchGestureRecognizer *pinch =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    pinch.delegate = self;
    //添加到指定视图
    [iamgeView addGestureRecognizer:pinch];
    
    //旋转手势
    UIRotationGestureRecognizer *rotation =[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction:)];
            rotation.delegate = self;
            //添加到指定的视图
    [iamgeView addGestureRecognizer:rotation];
    
    NSLog(@"平移");
    
}

//创建平移事件
-(void)panActionOK:(UIPanGestureRecognizer *)pan
{
    
    CGPoint  point = [pan locationInView:_quartrImage];
    pan.view.center = point;
    
}

//添加捏合事件
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    
    //通过 transform(改变) 进行视图的视图的捏合
    pinch.view.transform =CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    //设置比例 为 1
    pinch.scale = 1;
    NSLog(@"捏合");
}

//旋转事件

-(void)rotationAction:(UIRotationGestureRecognizer *)rote
{
    
    //通过transform 进行旋转变换
    rote.view.transform = CGAffineTransformRotate(rote.view.transform, rote.rotation);
    //将旋转角度 置为 0
    rote.rotation = 0;
    NSLog(@"旋转");
}


//手势代理事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    //  only _longPressGestureRecognizer and _panGestureRecognizer can recognize simultaneously
//    if ([_longPressRecognizer isEqual:gestureRecognizer]) {
//        return [_panRecognizer isEqual:otherGestureRecognizer];
//    }
//
//    if ([_panRecognizer isEqual:gestureRecognizer]) {
//        return [_longPressRecognizer isEqual:otherGestureRecognizer];
//    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        return YES;
    }

    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return YES;
    }

    
    return NO;
}


@end
