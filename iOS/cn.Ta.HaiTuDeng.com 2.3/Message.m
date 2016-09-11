//
//  HeartClickViewController.m
//  cn.Ta.HaiTuDeng.com
//
//  Created by htd on 16/8/25.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import "Message.h"
#import "Constant.h"


@interface Message ()

@end

@implementation Message


-(void)createCmdMessage:(NSString *const)cmd{
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"Ttel"];
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc]initWithAction:cmd];
    NSString *from = [[EMClient sharedClient]currentUsername];
    EMMessage *message = [[EMMessage alloc]initWithConversationID:user from:from to:user body:body ext:nil];
    message.chatType =  EMChatTypeChat;
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (error) {
            NSLog(@"message error");
        }
    }];
}

-(void)UpdateLocalDBAndServer
{
    NSLog(@"sdfsdfsdfsdfsd");
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
