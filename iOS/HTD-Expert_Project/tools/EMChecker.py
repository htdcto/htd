
# -*- coding: utf-8 -*-

__author__ = "xieyajie"

import os
import re

walk_path = '../'
# 规则和对应的警告
reg_dic = {
    #EMClient
    '\[EaseMob sharedInstance\]': 'Use EMClient',
    '.loginInfo': 'Use EMClient currentUsername',
    '.isAutoLoginEnabled': 'Use EMClient -options.isAutoLogin',
    '.isUseIp': 'Use EMClient -options.enableDnsConfig',
    '.isAutoDeleteConversationWhenLeaveGroup': '新版不再支持',
    '.sdkVersion': 'Use EMClient version',
    'setIsAutoFetchBuddyList:': '新版不再支持',
    'importDataToNewDatabase': 'Use EMClient -dataMigrationTo3',
    'loadDataFromDatabase': '新版不再支持',
    'registerNewAccount:': 'Use EMClient -registerWithUsername:password:',
    'asyncRegisterNewAccount:': 'Use EMClient -registerWithUsername:password:',
    'chatManager loginWithUsername:': 'Use EMClient -loginWithUsername:password:error:',
    'asyncLoginWithUsername:': 'Use EMClient -loginWithUsername:password:error:',
    'logoffWithUnbindDeviceToken:': 'Use EMClient -logout:',
    'asyncLogoffWithUnbindDeviceToken:': 'Use EMClient -logout:',
    'registerSDKWithAppKey:': 'Use EMClient -initializeSDKWithOptions:',
    'didRegisterNewAccount:': '新版不再支持,提供同步方法',
    'didLoginWithInfo:': '新版不再支持,提供同步方法',
    'didLogoffWithError:': '新版不再支持,提供同步方法',
    'willAutoLoginWithInfo:': '新版不再支持',
    'didAutoLoginWithInfo:': 'Use EMClientDelegate -didAutoLoginWithError:',
#    'didServersChanged': '新版不再支持',
#    'didAppkeyChanged': '新版不再支持',
    'willAutoReconnect': 'Use EMUtilDelegate -didConnectionStateChanged:',
    'didAutoReconnectFinishedWithError': 'Use EMUtilDelegate -didConnectionStateChanged:',
    'IEMMessageBody': 'Use EMMessageBody',
    'IEMFileMessageBody': 'Use EMFileMessageBody',
    'IEMChatObject': '新版不再支持',
    'IEMChatFile': '新版不再支持',
    'IChatImageOptions': '新版不再支持',
    'EMChatManagerDefs': '新版不再支持',
    'didRegisterForRemoteNotificationsWithDeviceToken:': 'Use EMClient -bindDeviceToken:',
    #Chat
    '.requireEncryption': '新版不再支持',
    '.isEncryptedOnServer': '新版不再支持',
    '.isOfflineMessage': '新版不再支持',
    '.isAnonymous': '新版不再支持',
    '.messageBodies': 'Use EMMessage body',
    'enableUnreadMessagesCountEvent': '新版不再支持',
    '.conversations': 'Use IEMChatManager -getAllConversations',
    'initWithReceiver:': 'Use EMMessage -initWithConversationID:from:to:body:ext:',
    'initMessageWithID:': 'Use EMMessage -initWithConversationID:from:to:body:ext:',
    'addMessageBody:': '新版不再支持',
    'removeMessageBody:': '新版不再支持',
    'updateMessageExtToDB': 'Use IEMChatManager -updateMessage:',
    'updateMessageDeliveryStateToDB': 'Use IEMChatManager -updateMessage:',
    'updateMessageBodiesToDB': 'Use IEMChatManager -updateMessage:',
    'updateMessageStatusFailedToDB': 'Use IEMChatManager -updateMessage:',
    'removeMessage:': 'Use EMConversation -deleteMessageWithId:',
    'removeMessagesWithIds:': 'Use EMConversation -deleteMessageWithId:',
    'markAllMessagesAsRead:': 'Use EMConversation -markAllMessagesAsRead',
    'markMessageWithId:': 'Use EMConversation -markMessageAsReadWithId:',
    'loadAllMessages': 'Use EMConversation -loadMoreMessagesFromId:limit:',
    'loadMessagesWithIds:': 'Use EMConversation -loadMessageWithId:',
    'loadNumbersOfMessages:': 'Use EMConversation -loadMoreMessagesFromId:limit:',
    'sendMessage:': 'Use IEMChatManager -asyncSendMessage:progress:completion:',
    'asyncSendMessage:': 'Use IEMChatManager -asyncSendMessage:progress:completion:',
    'resendMessage:': 'Use IEMChatManager -asyncResendMessage:progress:completion:',
    'asyncResendMessage:': 'Use IEMChatManager -asyncResendMessage:progress:completion:',
    'fetchMessageThumbnail:': 'Use IEMChatManager -asyncDownloadMessageThumbnail:progress:completion:',
    'asyncFetchMessageThumbnail:': 'Use IEMChatManager -asyncDownloadMessageThumbnail:progress:completion:',
    'fetchMessage:': 'Use IEMChatManager -asyncDownloadMessageAttachments:progress:completion:',
    'asyncFetchMessage:': 'Use IEMChatManager -asyncDownloadMessageAttachments:progress:completion:',
    'conversationForChatter:': 'Use IEMChatManager -getConversation:type:createIfNotExist:',
    'loadAllConversationsFromDatabaseWithAppend2Chat:': 'Use IEMChatManager -loadAllConversationsFromDB',
    'insertConversationToDB:': 'Use IEMChatManager -importConversations:',
    'insertConversationsToDB:': 'Use IEMChatManager -importConversations:',
    'removeConversationByChatter:': 'Use IEMChatManager -deleteConversations:deleteMessages:',
    'removeConversationsByChatters:': 'Use IEMChatManager -deleteConversation:deleteMessages:',
    'removeAllConversationsWithDeleteMessages:': 'Use IEMChatManager -deleteAllConversationsWithDeleteMessages:',
    'insertMessageToDB:': 'Use IEMChatManager -importMessages:',
    'insertMessageToDB:': 'Use IEMChatManager -importMessages:',
    'insertMessagesToDB:': 'Use IEMChatManager -importMessages:',
    'insertMessagesToDB:': 'Use IEMChatManager -importMessages:',
    'loadTotalUnreadMessagesCountFromDatabase': '新版不再支持',
    'unreadMessagesCountForConversation:': '新版不再支持',
    'searchMessagesWithCriteria:': '新版不再支持',
    'EMChatImage': '新版不再支持',
    'EMChatVoice': '新版不再支持',
    'EMChatText': '新版不再支持',
    'EMChatCommand': '新版不再支持',
    'EMChatLocation': '新版不再支持',
    'EMChatFile': '新版不再支持',
    'EMChatVideo': '新版不再支持',
    'EMReceipt': '新版不再支持',
    'willSendMessage:': '新版不再支持,提供block方法',
    'didSendMessage:': '新版不再支持,提供block方法',
    'didReceiveMessageId:': 'Use EMChatManagerDelegate -didMessageStatusChanged:error:',
    'didReceiveMessage:': 'Use EMChatManagerDelegate -didReceiveMessages:',
    'didReceiveCmdMessage:': 'Use EMChatManagerDelegate -didReceiveCmdMessages:',
    'didFetchingMessageAttachments:': '新版不再支持,提供block方法',
    'didFetchMessage:': '新版不再支持,提供block方法',
    'didFetchMessageThumbnail:': '新版不再支持,提供block方法',
    'didReceiveHasReadResponse:': 'Use EMChatManagerDelegate -didReceiveHasReadAcks:',
    'didReceiveHasDeliveredResponse:': 'Use EMChatManagerDelegate -didReceiveHasDeliveredAcks:',
    'didUnreadMessagesCountChanged': '新版不再支持',
    'willReceiveOfflineMessages': '新版不再支持',
    'didReceiveOfflineMessages:': 'Use EMChatManagerDelegate -didReceiveMessages:',
    'didReceiveOfflineCmdMessages:': 'Use EMChatManagerDelegate -didReceiveCmdMessages:',
    'didFinishedReceiveOfflineMessages': '新版不再支持',
    'didFinishedReceiveOfflineCmdMessages': '新版不再支持',
    #Contact
    'EMBuddy': '新版不再支持，请使用NSString',
    'buddyWithUsername:': '新版不再支持EMBuddy',
    '.followState': '新版不再支持EMBuddy',
    '.isPendingApproval': '新版不再支持EMBuddy',
    '.buddyList': '新版不再支持, 提供获取接口, 需自己维护',
    '.blockedList': '新版不再支持, 提供获取接口, 需自己维护',
    'EMBuddyFollowState': '新版不再支持, 新版不再支持EMBuddy',
    'eEMBuddyFollowState_NotFollowed': '新版不再支持, 新版不再支持EMBuddy',
    'eEMBuddyFollowState_Followed': '新版不再支持, 新版不再支持EMBuddy',
    'eEMBuddyFollowState_BeFollowed': '新版不再支持, 新版不再支持EMBuddy',
    'eEMBuddyFollowState_FollowedBoth': '新版不再支持, 新版不再支持EMBuddy',
    'EMRelationship': '新版不再支持',
    'eRelationshipBoth': '新版不再支持',
    'eRelationshipFrom': '新版不再支持',
    'eRelationshipTo': '新版不再支持',
    'fetchBuddyListWithError:': 'Use IEMContactManager -getContactsFromServerWithError:',
    'asyncFetchBuddyList': 'Use IEMContactManager -getContactsFromServerWithError:',
    'asyncFetchBuddyListWithCompletion:': 'Use IEMContactManager -getContactsFromServerWithError:',
    'addBuddy:': 'Use IEMContactManager -addContact:message:',
    'removeBuddy:': 'Use IEMContactManager -deleteContact:',
    'acceptBuddyRequest:': 'Use IEMContactManager -acceptInvitationForUsername:',
    'rejectBuddyRequest:': 'Use IEMContactManager -declineInvitationForUsername:',
    'fetchBlockedList:': 'Use IEMContactManager -getBlackListFromServerWithError:',
    'asyncFetchBlockedList': 'Use IEMContactManager -getBlackListFromServerWithError:',
    'asyncFetchBlockedListWithCompletion:': 'Use IEMContactManager -getBlackListFromServerWithError:',
    'blockBuddy:': 'Use IEMContactManager -addUserToBlackList:relationship:',
    'asyncBlockBuddy:': 'Use IEMContactManager -addUserToBlackList:relationship:',
    'unblockBuddy:': 'Use IEMContactManager -deleteContactFromBlackList:',
    'asyncUnblockBuddy:': 'Use IEMContactManager -deleteContactFromBlackList:',
    'didAcceptBuddySucceed:': 'Use EMContactManagerDelegate -didReceiveAddedFromUsernames:',
    'didUpdateBuddyList:': '新版不再支持, 提供获取好友接口',
    'didFetchedBuddyList:': '新版不再支持, 提供同步获取好友接口',
    'didUpdateBlockedList:': '新版不再支持, 提供获取黑名单接口',
    'didBlockBuddy:': '新版不再支持, 提供同步加黑名单接口',
    'didUnblockBuddy:': '新版不再支持, 提供同步减黑名单接口',
    #Group
    '.groupOnlineOccupantsCount': '新版不再支持',
    '.groupList': 'Use IEMGroupManager -loadAllMyGroupsFromDB',
    'occupantWithUsername:': '新版不再支持',
    'nicknameForAccount:': '新版不再支持',
    'loadAllMyGroupsFromDatabaseWithAppend2Chat:': 'Use IEMGroupManager -loadAllMyGroupsFromDB',
    'chatManager createGroupWithSubject:': 'Use IEMGroupManager -createGroupWithSubject:description:invitees:message:setting:error:',
    'asyncCreateGroupWithSubject:': 'Use IEMGroupManager -createGroupWithSubject:description:invitees:message:setting:error:',
    'createAnonymousGroupWithSubject:': '新版不再提供',
    'asyncCreateAnonymousGroupWithSubject:': '新版不再提供',
    'joinAnonymousPublicGroup:': '新版不再提供',
    'asyncJoinAnonymousPublicGroup:': '新版不再提供',
    'asyncLeaveGroup:': 'Use IEMGroupManager -leaveGroup:error:',
    'asyncDestroyGroup:': 'Use IEMGroupManager -leaveGroup:error:',
    'asyncAddOccupants:': 'Use IEMGroupManager -addOccupants:toGroup:welcomeMessage:error:',
    'asyncRemoveOccupants:': 'Use IEMGroupManager -removeOccupants:fromGroup:error:',
    'asyncBlockOccupants:': 'Use IEMGroupManager -blockOccupants:fromGroup:error:',
    'asyncUnblockOccupants:': 'Use IEMGroupManager -unblockOccupants:forGroup:error:',
    'asyncChangeGroupSubject:': 'Use IEMGroupManager -changeGroupSubject:forGroup:error:',
    'asyncChangeDescription:': 'Use IEMGroupManager -changeDescription:forGroup:error:',
    'acceptApplyJoinGroup:': 'Use IEMGroupManager -acceptJoinApplication:groupname:applicant:reason:',
    'asyncAcceptApplyJoinGroup:': 'Use IEMGroupManager -acceptJoinApplication:groupname:applicant:reason:',
    'chatManager fetchGroupInfo:': 'Use IEMGroupManager -fetchGroupInfo:includeMembersList:error:',
    'asyncFetchGroupInfo:': 'Use IEMGroupManager -fetchGroupInfo:includeMembersList:error:',
    'fetchOccupantList:': 'Use IEMGroupManager -fetchGroupInfo:includeMembersList:error:',
    'asyncFetchOccupantList:': 'Use IEMGroupManager -fetchGroupInfo:includeMembersList:error:',
    'asyncFetchGroupBansList:': 'Use IEMGroupManager -fetchGroupBansList:error:',
    'asyncFetchMyGroupsList': 'Use IEMGroupManager -getMyGroupsFromServerWithError:',
    'chatManager fetchPublicGroupsFromServerWithCursor:': 'Use IEMGroupManager -getPublicGroupsFromServerWithCursor:pageSize:error:',
    'asyncFetchPublicGroupsFromServerWithCursor:': 'Use IEMGroupManager -getPublicGroupsFromServerWithCursor:pageSize:error:',
    'fetchAllPublicGroupsWithError:': 'Use IEMGroupManager -getPublicGroupsFromServerWithCursor:pageSize:error:',
    'asyncFetchAllPublicGroups': 'Use IEMGroupManager -getPublicGroupsFromServerWithCursor:pageSize:error:',
    'asyncJoinPublicGroup:': 'Use IEMGroupManager -joinPublicGroup:error:',
    'chatManager applyJoinPublicGroup:': 'Use IEMGroupManager -applyJoinPublicGroup:groupSubject:message:error:',
    'asyncApplyJoinPublicGroup:': 'Use IEMGroupManager -applyJoinPublicGroup:groupSubject:message:error:',
    'asyncSearchPublicGroupWithGroupId:': 'Use IEMGroupManager -searchPublicGroupWithId:error:',
    'asyncBlockGroup:': 'Use IEMGroupManager -ignoreGroupPush:ignore:',
    'asyncUnblockGroup:': 'Use IEMGroupManager -ignoreGroupPush:ignore:',
    'rejectApplyJoinGroup:': 'Use IEMGroupManager -declineApplication:groupname:applicant:reason:',
    ' didCreateWithError:': '新版不再支持，提供同步接口',
    ' didLeave:': 'Use EMGroupManagerDelegate -didReceiveLeavedGroup:reason:',
    'groupDidUpdateInfo:': '新版不再支持，提供同步接口',
    'didAcceptInvitationFromGroup:': 'Use EMGroupManagerDelegate -didJoinedGroup:inviter:message:',
    'didReceiveGroupInvitationFrom:': 'Use EMGroupManagerDelegate -didReceiveGroupInvitation:inviter:message:',
    'didReceiveGroupRejectFrom:': 'Use EMGroupManagerDelegate -didReceiveDeclinedGroupInvitation:invitee:reason:',
    'didReceiveApplyToJoinGroup:': 'Use EMGroupManagerDelegate -didReceiveJoinGroupApplication:applicant:reason:',
    'didReceiveRejectApplyToJoinGroupFrom:': 'Use EMGroupManagerDelegate -didReceiveDeclinedJoinGroup:reason:',
    'didReceiveAcceptApplyToJoinGroup:': 'Use EMGroupManagerDelegate -didReceiveAcceptedJoinGroup:',
    'didAcceptApplyJoinGroup:': '新版不再支持',
    'didUpdateGroupList:': 'Use EMGroupManagerDelegate -didUpdateGroupList:',
    'didFetchAllPublicGroups:': '新版不再支持',
    'didFetchGroupInfo:': '新版不再支持',
    'didFetchGroupOccupantsList:': '新版不再支持',
    'didFetchGroupBans:': '新版不再支持',
    'didJoinPublicGroup:': '新版不再支持',
    'didApplyJoinPublicGroup:': '新版不再支持',
    #ChatRoom
    ' occupantDidJoin:': 'Use EMChatroomManagerDelegate -didReceiveUserJoinedChatroom:username:',
    ' occupantDidLeave:': 'Use EMChatroomManagerDelegate -didReceiveUserLeavedChatroom:username:',
    'joinChatroom:': 'Use IEMChatroomManager -joinChatroom:error:',
    'asyncJoinChatroom:': 'Use IEMChatroomManager -joinChatroom:error:',
    'leaveChatroom:': 'Use IEMChatroomManager -leaveChatroom:error:',
    'asyncLeaveChatroom:': 'Use IEMChatroomManager -leaveChatroom:error:',
    'fetchChatroomsFromServerWithCursor:': '新版不再支持',
    'asyncFetchChatroomsFromServerWithCursor:': '新版不再支持',
    'fetchChatroomInfo:': '新版不再支持',
    'asyncFetchChatroomInfo:': '新版不再支持',
    'fetchOccupantsForChatroom:': '新版不再支持',
    'asyncFetchOccupantsForChatroom:': '新版不再支持',
    #Call
    'callSessionStatusChanged:': '请使用EMCallManagerDelegate中的新版回调',
    'initWithSessionId:': '新版不再支持，不允许用户自己创建通话实例',
    'asyncMakeVoiceCall:': 'Use IEMCallManager -makeVoiceCall:error:',
    'asyncMakeVideoCall:': 'Use IEMCallManager -makeVideoCall:error:',
    #Apns
    'didUpdatePushOptions:': '新版不再支持,提供同步方法',
    'didIgnoreGroupPushNotification:': '新版不再支持,提供同步方法',
    #Error
    'errorWithCode:': 'Use EMError +errorWithDomain:code:',
    'errorWithNSError:': 'Use EMError +errorWithDomain:code:',
}

def log_warning(file_path, line_number, description):
    print '{0}:{1}: error: {2}'.format(file_path, line_number, description)

def check_main(root_path):
    for root, dirs, files in os.walk(root_path):
        for file_path in files:
            if file_path.endswith('.m'):
                full_path = os.path.join(root, file_path)

                # 不检查 pod 第三方库
                if 'Pods/' in full_path:
                    break

                fr = open(full_path, 'r')
                content = fr.read()
                fr.close()

                for key in reg_dic:
                    match = re.search(key, content)
                    if match:
                        substring = content[:match.regs[0][1]]
                        line_match = re.findall('\n', substring)
                        line_number = len(line_match) + 1
                        log_warning(full_path, line_number, reg_dic[key])

if __name__ == '__main__':
    check_main(walk_path)
