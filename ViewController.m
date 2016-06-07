//
//  ViewController.m
//  animation_demo
//
//  Created by t00javateam@gmail.com on 2016/6/7.
//  Copyright © 2016年 t00javateam@gmail.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic)UIButton *button;
@property (strong, nonatomic) CALayer *aLayer;
@property (assign, nonatomic) BOOL isGreen;
@property (nonatomic) BOOL isAdd;
@property (nonatomic) UIView *subView;
@property (nonatomic) UIView *rotationView;
@end

@implementation ViewController

-(UIButton*)button{
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button addTarget:self action:@selector(toggleColor:) forControlEvents:UIControlEventTouchUpInside];
        [_button setFrame:CGRectMake(CGRectGetMaxX(self.view.frame)-200,CGRectGetMaxY(self.view.frame)-40 , 150, 35)];
        [_button setExclusiveTouch:YES];
        [_button setTitle:@"CHANGE_ANIMATION" forState:UIControlStateNormal];
    }
    return _button;
}

-(CALayer*)aLayer{
    if(!_aLayer){
        _aLayer = [[CALayer alloc] init];
        _aLayer.frame = CGRectMake(50, 50, 100, 100);
        _aLayer.backgroundColor = [UIColor redColor].CGColor;
    }
    return _aLayer;
}

-(UIView*)subView{
    if(!_subView){
        _subView = [[UIView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.aLayer.frame)+10, 100, 100)];
        _subView.backgroundColor = [UIColor blueColor];
    }
    return _subView;
}

-(UIView*)rotationView{
    if(!_rotationView){
        _rotationView = [[UIView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.subView.frame)+10, 100, 100)];
        _rotationView.backgroundColor = [UIColor grayColor];
    }
    return _rotationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    [self.view.layer addSublayer:self.aLayer];
    [self.view addSubview:self.rotationView];
    
    /* CAPropertyAnimation
       對某個 layer 加入了 CAPropertyAnimation 之後，雖然會產生動畫，但是就只有產生動畫而已， layer 屬性原本的值並不會因此改變
       CAPropertyAnimation 是一層介面，我們通常使用的是 CAPropertyAnimation 的 subclass CABasicAnimation
     */
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = @0.0f;
    rotateAnimation.toValue = @(M_PI * 2);
    rotateAnimation.autoreverses = YES;
    rotateAnimation.repeatCount = NSUIntegerMax;
    rotateAnimation.duration = 2.0;
    [self.rotationView.layer addAnimation:rotateAnimation forKey:@"x"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleColor:(id)sender{
    self.isGreen = !self.isGreen;
    self.aLayer.backgroundColor = self.isGreen ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.aLayer addAnimation:transition forKey:@"transition"];
     
   
    /*subView 增加/刪除的動畫*/
    self.isAdd = !self.isAdd;
   
    /*subView 要先新增到superview 上 然後再跑動畫 (如果沒先新增,在跑動畫的時候看不到東西) */
    if(self.isAdd == YES)
        [self.view addSubview:self.subView];
    
    CATransition *subtransition = [[CATransition alloc] init];
    subtransition.type = kCATransitionPush;
    subtransition.subtype = kCATransitionFromRight;
    /* 預設動畫時間都是0.25秒 */
    [subtransition setDuration:0.8];
    
    /* 刪除時要使用這個block,動畫跑完後才做刪除的動作,和新增相反 */
    [CATransaction setCompletionBlock:^{
        
        if(self.isAdd == NO)
            [self.subView removeFromSuperview];
            
        
    }];
    /* 將設定好的動畫加入到subview的layer上面 */
    [self.subView.layer addAnimation:subtransition forKey:@"transition"];
    
    
  
    
}

@end
