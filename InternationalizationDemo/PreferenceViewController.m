//
//  PreferenceViewController.m
//  InternationalizationDemo
//
//  Created by Superman on 2018/7/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "PreferenceViewController.h"
#import "LanguageManager.h"

@interface PreferenceViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,copy) NSString *searchText;//搜索词
@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor whiteColor];
     _dataAry=[NSMutableArray new];
    
    [self addSearchBar];
    
    [self changeLanguage];
}
- (void)addSearchBar {
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    searchBar.placeholder=kLocalizedString(@"search", @"搜索");
    searchBar.delegate=self;
    self.tableView.tableHeaderView=searchBar;
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf =self;
    LanguageManager.completion = ^(NSString *currentLanguage){
        __strong __typeof(self)self =weakSelf;
        [self changeLanguage];
    };
}
-(NSArray *)languageAry{
    return @[@"zh-Hans-CN", //中文简体
             @"zh-Hant-CN", //中文繁体
             @"en-CN", //英语
             @"ko-CN", //韩语
             @"ja-CN" //日语
             ];
}
- (void)changeLanguage {
    self.title=kLocalizedString(@"preference", @"偏好");
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:kLocalizedString(@"cancel",@"取消") style:UIBarButtonItemStyleDone target:self action:@selector(cancleButtonAction:)];
    self.navigationItem.leftBarButtonItem=item;
    
    [self.tableView reloadData];
}
////对应国家的语言
- (NSString *)ittemCountryLanguage:(NSString *)lang {
    NSString *language=[LanguageManager languageFormat:lang];
    NSString *countryLanguage=[[[NSLocale alloc]initWithLocaleIdentifier:language]displayNameForKey:NSLocaleIdentifier value:language];
    return countryLanguage;
}
////当前语言下的对应国家语言翻译
- (NSString *)ittemCurrentLanguageName:(NSString *)lang {
    NSString *language=[LanguageManager languageFormat:lang];
    
    NSString *currentLanguage=LanguageManager.currentLanguage;
    NSString *currentLanguageName=[[[NSLocale alloc]initWithLocaleIdentifier:currentLanguage] displayNameForKey:NSLocaleIdentifier value:language];
    return currentLanguageName;
}
-(NSArray *)dataAry{
    if (_searchText.length >0) {
        return _dataAry;
    }else{
        return self.languageAry;
    }
}
#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    NSString *language = [LanguageManager languageFormat:self.dataAry[indexPath.row]];
    //对应国家的语言
    NSString *countryLanguage = [self ittemCountryLanguage:self.dataAry[indexPath.row]];
    //当前语言下的对应国家语言翻译
    NSString *currentLanguageName = [self ittemCurrentLanguageName:self.dataAry[indexPath.row]] ;
    
    cell.textLabel.text = countryLanguage;
    cell.detailTextLabel.text = currentLanguageName;
    
    if (_searchText.length > 0) {
        cell.textLabel.attributedText = [self searchTitle:countryLanguage key:_searchText keyColor:[UIColor redColor]];
        cell.detailTextLabel.attributedText = [self searchTitle:currentLanguageName key:_searchText keyColor:[UIColor redColor]];
    } else {
        cell.textLabel.text = countryLanguage;
        cell.detailTextLabel.text = currentLanguageName;
    }
    
    //当前语言
    NSString *currentLanguage = LanguageManager.currentLanguage;
    
    if([currentLanguage rangeOfString:language].location != NSNotFound)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *language=self.dataAry[indexPath.row];
    [LanguageManager setUserlanguage:language];
    
    [self  cancleButtonAction:nil];
}
//取消按钮
- (void)cancleButtonAction:(UIButton *)button {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBar Delegate
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton=YES;
    [self changeSearchBarCancleText:searchBar];
    self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 252);
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchText = searchText;
    [self ittemSearchResultsDataAryWithSearchText:searchText];
    
    [self.tableView reloadData];
}
//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [LanguageManager setUserlanguage:searchBar.text];
//    self searchBarCancelButtonClicked:
    searchBar.showsCancelButton =NO;
    _searchText=nil;
    searchBar.text=nil;
    [self.view endEditing:YES];
    self.tableView.frame=[UIScreen mainScreen].bounds;
    [self.tableView reloadData];
}
//搜索结果按钮点击的回调
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    [LanguageManager setUserlanguage:searchBar.text];
    [self cancleButtonAction:nil];
}
//修改searchBar中的文字为多语言
- (void)changeSearchBarCancleText:(UISearchBar *)searchBar {
    
}
#pragma mark - 自定义方法
//根据搜索词来查找符合的数据
- (void)ittemSearchResultsDataAryWithSearchText:(NSString *)searchText {
    [_dataAry removeAllObjects];
    [self.languageAry enumerateObjectsUsingBlock:^(NSString *lang, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *countryLanguage=[self ittemCountryLanguage:lang];
        NSString *currentLanguageName=[self ittemCurrentLanguageName:lang];
        
        if ([countryLanguage rangeOfString:_searchText options:NSCaseInsensitiveSearch].location !=NSNotFound || [currentLanguageName rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [_dataAry addObject:lang];
        }
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

























/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
