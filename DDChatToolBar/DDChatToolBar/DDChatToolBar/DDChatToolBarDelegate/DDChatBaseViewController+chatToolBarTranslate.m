//
//  DDChatBaseViewController+chatToolBarTranslate.m
//  DDChatToolBar
//
//  Created by wuqh on 2018/5/22.
//  Copyright © 2018年 wuqh. All rights reserved.
//

#import "DDChatBaseViewController+chatToolBarTranslate.h"
#import "DDChatEmojiKeyboard.h"

@implementation DDChatBaseViewController (chatToolBarTranslate)

- (void)chatBar:(DDChatToolBar *)chatBar changeStatusFrom:(DDChatToolBarStatus)fromStatus to:(DDChatToolBarStatus)toStatus {
    
    //状态相同 返回
    if (curStatus == toStatus) return;
    
    NSLog(@"%s",__FUNCTION__);
    
    lastStatus = fromStatus;
    curStatus = toStatus;
    
    if (toStatus == DDChatToolBarStatusEmoji) {
        [self.emojiKeyboard showInView:self.view withAnimation:YES];
    } else if (toStatus == DDChatToolBarStatusVoice) {
        if (fromStatus == DDChatToolBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }else if (DDChatToolBarStatusMore) {
            
        }
    } 
}

@end
