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

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [self initWithFrame:CGRectZero]) {
        if (!self.superview) {
            [tableView.superview  addSubview:self];
        }
        [tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self.superview);
        }];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@49);
            make.left.right.and.bottom.equalTo(self.superview);
            make.top.equalTo(tableView.mas_bottom);
        }];
    }
    return self;
}

#pragma mark - Action
- (void)voiceButtonClick:(UIButton* )button {
    if (self.status == DDChatToolBarStatusVoice) {
    //文字键盘
        [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
        self.pressToTalkButton.hidden = YES;
        
        [self.inputTextView becomeFirstResponder];
        self.status = DDChatToolBarStatusKeyboard;
        
    }else {
    //展示发送语音按钮
        if (self.status == DDChatToolBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
            if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
                [self.translateDelegate chatBar:self changeStatusFrom:DDChatToolBarStatusEmoji to:DDChatToolBarStatusVoice];
            }
        } else if (self.status == DDChatToolBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
            if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
                [self.translateDelegate chatBar:self changeStatusFrom:DDChatToolBarStatusMore to:DDChatToolBarStatusVoice];
            }
        } else if (self.status == DDChatToolBarStatusKeyboard) {
            [self.inputTextView resignFirstResponder];
        }
        self.pressToTalkButton.hidden = NO;
        [self.voiceButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        self.status = DDChatToolBarStatusVoice;
    }
}
- (void)emojiButtonClick:(UIButton *)button {
    if (self.status == DDChatToolBarStatusEmoji) {
    //->文字键盘
        [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        
        //移除emojiKeyboard 设置代理的作用是，viewController才能拿到emojiKeyboard
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.translateDelegate chatBar:self changeStatusFrom:DDChatToolBarStatusEmoji to:DDChatToolBarStatusKeyboard];
        }
        //inputTextView 在这个方法里面统一处理，因为inputTextView这个属性在此类里面，处理比较方面。不需要translateDelegate处理
        [self.inputTextView becomeFirstResponder];
        //修改status
        self.status = DDChatToolBarStatusKeyboard;
        
    }else {
    //->表情键盘
        if (self.status == DDChatToolBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
            self.pressToTalkButton.hidden = YES;
        }
        [self.emojiButton setImage:kKeyboardImage imageHL:kKeyboardImageHL];
        
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)] ) {
            [self.translateDelegate chatBar:self changeStatusFrom:self.status to:DDChatToolBarStatusEmoji];
        }
        
        if (self.status == DDChatToolBarStatusKeyboard) {
            [self.inputTextView resignFirstResponder];
        }
        self.status = DDChatToolBarStatusEmoji;
    }
}
- (void)moreButtonClick:(UIButton *)button {
    
    if (self.status == DDChatToolBarStatusMore) {
    //-> 文字输入
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.translateDelegate chatBar:self changeStatusFrom:DDChatToolBarStatusMore to:DDChatToolBarStatusKeyboard];
        }
        [self.inputTextView becomeFirstResponder];
        self.status = DDChatToolBarStatusKeyboard;
    }else {
    //-> more键盘
        if (self.status == DDChatToolBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHL:kVoiceImageHL];
            self.pressToTalkButton.hidden = YES;
        }
        if (self.status == DDChatToolBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }
        [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.translateDelegate chatBar:self changeStatusFrom:self.status to:DDChatToolBarStatusMore];
        }
        if (self.status == DDChatToolBarStatusKeyboard) {
            [self.inputTextView resignFirstResponder];
        }
        self.status = DDChatToolBarStatusMore;
    }
    
}

#pragma mark - UI
- (void)setupUI {
    
    self.backgroundColor = HexColor(0xF2F2F5);
    
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
//    self.inputTextView.textContainer.maximumNumberOfLines = 3;
  
//    self.inputTextView.linkTextAttributes
    self.inputTextView.showsVerticalScrollIndicator = NO;
    self.inputTextView.bounces = NO;
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
        make.top.equalTo(self).mas_offset(7);
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
    if (self.status == DDChatToolBarStatusEmoji) {
        [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.translateDelegate chatBar:self changeStatusFrom:DDChatToolBarStatusEmoji to:DDChatToolBarStatusInit];
        }
        self.status = DDChatToolBarStatusInit;
    }else if (self.status == DDChatToolBarStatusMore) {
//        [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.translateDelegate chatBar:self changeStatusFrom:DDChatToolBarStatusMore to:DDChatToolBarStatusInit];
        }
        self.status = DDChatToolBarStatusInit;
    }
    return [super resignFirstResponder];
}

- (BOOL)isFirstResponder {
    
    return (self.status == DDChatToolBarStatusKeyboard || self.status == DDChatToolBarStatusEmoji || self.status == DDChatToolBarStatusMore);
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.3].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, [UIScreen mainScreen].bounds.size.width, 0);
    CGContextMoveToPoint(context, 0, 49);
    CGContextAddLineToPoint(context, [UIScreen mainScreen].bounds.size.width, 49);
    CGContextStrokePath(context);
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

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
//    CGFloat height = [self heightForTextView:textView WithText:textView.text];
//    height = height < 35 ? 35 : height;
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(height));
//        }];
//        [self layoutIfNeeded];
//    }];
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.status != DDChatToolBarStatusKeyboard) {
        if ([self.translateDelegate respondsToSelector:@selector(chatBar:changeStatusFrom:to:)]) {
            [self.translateDelegate chatBar:self changeStatusFrom:self.status to:DDChatToolBarStatusKeyboard];
        }
        if (self.status == DDChatToolBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHL:kEmojiImageHL];
        }
        else if (self.status == DDChatToolBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHL:kMoreImageHL];
        }
        self.status = DDChatToolBarStatusKeyboard;
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSLog(@"text:%@",text);
    NSLog(@"textView:%@",textView.text);
    float height;
    if ([text isEqual:@""]) {

        if (![textView.text isEqualToString:@""]) {
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];

        }else{

            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{

        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    if (height > 112.f) {
        return YES;
    }
    
    height = height < 35 ? 35 : height;

    [UIView animateWithDuration:0.3 animations:^{
        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(height));
        }];
        [self layoutIfNeeded];
    }];

    return YES;
    
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{

    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [strText boundingRectWithSize: CGSizeMake(textView.contentSize.width-textView.textContainer.lineFragmentPadding * 2, CGFLOAT_MAX)
                                          options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;
    
    
    float textHeight = ceil(size.height)+16;
    return textHeight;
}

@end
