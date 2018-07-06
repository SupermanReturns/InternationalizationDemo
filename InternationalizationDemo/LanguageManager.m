//
//  LanguageManager.m
//  InternationalizationDemo
//
//  Created by Superman on 2018/7/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "LanguageManager.h"

#define NSLocalizedStringTableName @"Localizable"
#define UserLanguage @"userLanguage"

@interface LanguageManager ()

@property (nonatomic,strong) NSBundle *bundle;

@end


@implementation LanguageManager


+(instancetype)shareInstance{
    static LanguageManager *_manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _manager=[[self alloc]init];
    });
    return _manager;
}

-(void)initUserLanguage{
    NSString *currentLanguage=[self currentLanguage];
    if (currentLanguage.length==0) {
        NSArray *languages=[NSLocale preferredLanguages];
        currentLanguage=[languages objectAtIndex:0];
        [self saveLanguage:currentLanguage];
    }
    [self changeBundle:currentLanguage];
}
//设置语言
-(void)setUserlanguage:(NSString *)language{
    if (![[self currentLanguage] isEqualToString:language]) {
        [self saveLanguage:language];
        
        [self changeBundle:language];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ChangeLanguageNotificationName object:nil];
        if (_completion) {
            _completion(language);
        }
    }
}
//语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
-(NSString *)languageFormat:(NSString *)language{
    if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        return @"zh-Hans";
    }
    else if ([language rangeOfString:@"zh-Hant"].location != NSNotFound){
        return @"zh-Hant";
    }else{
        if ([language rangeOfString:@"-"].location !=NSNotFound) {
            NSArray *ary=[language componentsSeparatedByString:@"-"];
            if (ary.count >1) {
                NSString *str=ary[0];
                return str;
            }
        }
    }
    return language;
}

- (void)changeBundle:(NSString *)language {
    NSString *path=[[NSBundle mainBundle]pathForResource:[self languageFormat:language] ofType:@"lproj"];
    _bundle=[NSBundle bundleWithPath:path];
}

//保存语言
- (void)saveLanguage:(NSString *)language {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:language forKey:UserLanguage];
    [defaults synchronize];
}
//获取语言
- (NSString *)currentLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaults objectForKey:UserLanguage];
    return language;
}

//获取当前语种下的内容
-(NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value{
    if (!_bundle) {
        [self initUserLanguage];
    }
    
    if (key.length >0) {
        if (_bundle) {
            NSString *str=NSLocalizedStringFromTableInBundle(key, NSLocalizedStringTableName, _bundle, value);
            if (str.length>0) {
                return str;
            }
        }
    }
    return @"";
}
-(UIImage *)ittemInternationalImageWithName:(NSString *)name{
    NSString *selectedLanguage=[self languageFormat:[self currentLanguage]];
    UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",name,selectedLanguage]];
    return image;
}
@end


































