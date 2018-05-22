//
//  DDChatToolBar.m
//  DDChatToolBar
//
//  Created by wuqh on 2018/5/22.
//  Copyright © 2018年 wuqh. All rights reserved.
//

#import "DDChatToolBar.h"
#import "DDChatToolBarCommon.h"
#import "DDPressToTalkButton.h"
#import "UIButton+Extensions.h"

@interface DDChatToolBar()<UITextViewDelegate>
{
    UIImage *kVoiceImage;
    UIImage *kVoiceImageHL;
    UIImage *kEmojiImage;
    UIImage *kEmojiImageHL;
    UIImage *kMoreImage;
    UIImage *kMoreImageHL;
    UIImage *kKeyboardImage;
    UIImage *kKeyboardImageHL;
}
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, strong) DDPressToTalkButton *pressToTalkButton;
@property (nonatomic, strong) UIButton *emojiButton;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation DDChatToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initImage];
        [self setupUI];
    }
    return self;
}

#pragma mark - Action
- (void)voiceButtonClick:(UIButton* )button {
    if (self.status == DDChatToolBarStatusVoice) {
    //文字输入
        [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
        self.pressToTalkButton.hidden = YES;
        
        [self.inputTextView becomeFirstResponder];
        self.status = DDChatToolBarStatusKeyboard;
        
    }else {
    //语音
        if (self.status == DDChatToolBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImageHL imageHL:kEmojiImageHL];
        }else if (self.status == DDChatToolBarStatusKeyboard) {
            [self.inputTextView resignFirstResponder];
        }
        self.pressToTalkButton.hidden = NO;
        [self.voiceButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        self.status = DDChatToolBarStatusVoice;
    }
}
- (void)emojiButtonClick:(UIButton *)button {
    
}
- (void)moreButtonClick:(UIButton *)button {
    
}

#pragma mark - UI
- (void)setupUI {
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
    [self.voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceButton];
    
    self.inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.inputTextView.font = [UIFont systemFontOfSize:16];
    self.inputTextView.returnKeyType = UIReturnKeySend;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.layer.borderWidth = BORDER_WIDTH_1PX;
    self.inputTextView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
    self.inputTextView.layer.cornerRadius = 4.0f;
    self.inputTextView.delegate = self;
    [self addSubview:self.inputTextView];

    
    
    self.pressToTalkButton = [[DDPressToTalkButton alloc] init];
    self.pressToTalkButton.hidden = YES;
    [self addSubview:self.pressToTalkButton];
    
    self.emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
    [self.emojiButton addTarget:self action:@selector(emojiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emojiButton];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
    [self.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    
    //constraint
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.height.width.equalTo(@35);
        make.left.equalTo(self.mas_left).offset(7);
    }];
    
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left).offset(-7);
        make.centerY.equalTo(self.voiceButton);
        make.width.height.equalTo(@35);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voiceButton);
        make.right.equalTo(self).offset(-7);
        make.width.height.equalTo(@35);
    }];
    
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).mas_offset(-7);
        make.left.equalTo(self.voiceButton.mas_right).offset(7);
        make.right.equalTo(self.emojiButton.mas_left).offset(-7);
        make.height.equalTo(@35);
    }];
    
    [self.pressToTalkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.inputTextView);
    }];
}

#pragma mark - Override
#pragma mark firstResponder
- (BOOL)resignFirstResponder {
    if (self.inputTextView.isFirstResponder) {
        [self.inputTextView resignFirstResponder];
    }
    return [super resignFirstResponder];
}

- (BOOL)isFirstResponder {
    
    return (self.status == DDChatToolBarStatusKeyboard || self.status == DDChatToolBarStatusEmoji || self.status == DDChatToolBarStatusMore);
    
}

#pragma mark - Private
- (void)initImage
{
    kVoiceImage = [UIImage imageNamed:@"chat_toolbar_voice"];
    kVoiceImageHL = [UIImage imageNamed:@"chat_toolbar_voice_HL"];
    kEmojiImage = [UIImage imageNamed:@"chat_toolbar_emotion"];
    kEmojiImageHL = [UIImage imageNamed:@"chat_toolbar_emotion_HL"];
    kMoreImage = [UIImage imageNamed:@"chat_toolbar_more"];
    kMoreImageHL = [UIImage imageNamed:@"chat_toolbar_more_HL"];
    kKeyboardImage = [UIImage imageNamed:@"chat_toolbar_keyboard"];
    kKeyboardImageHL = [UIImage imageNamed:@"chat_toolbar_keyboard_HL"];
}


@end
