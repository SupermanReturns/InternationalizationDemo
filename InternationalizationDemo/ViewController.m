//
//  ViewController.m
//  InternationalizationDemo
//
//  Created by Superman on 2018/7/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "ViewController.h"
#import "LanguageManager.h"
#import "PreferenceViewController.h"


@interface ViewController ()
@property (weak, nonatomic)  UIImageView *worldImageView;
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UIImageView *icoImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2,100 ,100 ,25 )];
    [self.view addSubview:titleLabel];
    _titleLabel=titleLabel;
    
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLanguage) name:ChangeLanguageNotificationName object:nil];
    [self changeLanguage];
}
//改变语言界面刷新
- (void)changeLanguage {
    self.title = kLocalizedString(@"home",@"首页");
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:kLocalizedString(@"preference",@"偏好") style:UIBarButtonItemStyleDone target:self action:@selector(gotoPreferenceViewController)];
    self.navigationItem.rightBarButtonItem = item;
    
    _titleLabel.text = kLocalizedString(@"welcome",@"你好 世界!");
}
//去偏好设置界面
- (void)gotoPreferenceViewController {
    PreferenceViewController *vc = [PreferenceViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:ChangeLanguageNotificationName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
