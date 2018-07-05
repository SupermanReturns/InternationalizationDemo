//
//  LanguageManager.h
//  InternationalizationDemo
//
//  Created by Superman on 2018/7/4.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ChangeLanguageNotificationName @"changeLanguage"
#define kLocalizedString(key, comment) [LanguageManager localizedStringForKey:key value:comment]

@interface LanguageManager : NSObject

@property (nonatomic,copy) void (^completion)(NSString *currentLanguage);

- (NSString *)currentLanguage; //当前语言
- (NSString *)languageFormat:(NSString*)language;
- (void)setUserlanguage:(NSString *)language;//设置当前语言

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

- (UIImage *)ittemInternationalImageWithName:(NSString *)name;

+ (instancetype)shareInstance;

#define LanguageManager [LanguageManager shareInstance]


@end
