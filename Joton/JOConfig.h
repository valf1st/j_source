//
//  JOConfig.h
//  Joton
//
//  Created by Val F on 12/12/04.
//  Copyright (c) 2012年 ****. All rights reserved.
//


#define MAIN_URL @"http://joton.jp"
//アイコン
#define URL_ICON [NSString stringWithFormat:@"%@/iconimgs", MAIN_URL]
//画像
#define URL_IMAGE [NSString stringWithFormat:@"%@/images", MAIN_URL]
//web
#define URL_WEB [NSString stringWithFormat:@"%@/web_item/detail?item_id=", MAIN_URL]

//ログイン
#define URL_LOGIN [NSString stringWithFormat:@"%@/user/login", MAIN_URL]
//新規登録
#define URL_REGISTER [NSString stringWithFormat:@"%@/user/register_user", MAIN_URL]
//立ち上げたときにユーザーの最新情報をとってきてlast_accessを更新する
#define URL_LAUNCHED_DEVICE [NSString stringWithFormat:@"%@/user/launch_device", MAIN_URL]
//立ち上げたときにユーザーの最新情報をとってきてlast_accessを更新する(device_tokenなし)
#define URL_LAUNCHED [NSString stringWithFormat:@"%@/user/launch", MAIN_URL]
//browseページ表示
#define URL_ITEMS [NSString stringWithFormat:@"%@/item/get_items", MAIN_URL]
//パスワード忘れ
#define URL_REMINDER [NSString stringWithFormat:@"%@/user/reminder", MAIN_URL]
//退会
#define URL_RESIGN [NSString stringWithFormat:@"%@/user/resign", MAIN_URL]
//ユーザーデータをとってくる
#define URL_USER [NSString stringWithFormat:@"%@/user/get_user", MAIN_URL]
//ユーザーデータをfb, tw含めてとってくる
#define URL_USER_CONNECT [NSString stringWithFormat:@"%@/user/get_user_connect", MAIN_URL]
//FBデータを追加
#define URL_ADD_FB [NSString stringWithFormat:@"%@/user/add_user_fb", MAIN_URL]
//TWデータを追加
#define URL_ADD_TW [NSString stringWithFormat:@"%@/user/add_user_tw", MAIN_URL]
//ユーザー情報編集
#define URL_USER_UPDATE [NSString stringWithFormat:@"%@/user/update_user", MAIN_URL]
//パスワード更新
#define URL_USER_PASS [NSString stringWithFormat:@"%@/user/update_pass", MAIN_URL]
//郵便番号
#define URL_POSTCODE [NSString stringWithFormat:@"%@/user/postcode", MAIN_URL]
//プッシュ通知編集
#define URL_USER_PUSH [NSString stringWithFormat:@"%@/user/update_user_push", MAIN_URL]
//現金履歴
#define URL_USER_MONEY [NSString stringWithFormat:@"%@/user/user_money", MAIN_URL]
//コイン履歴
#define URL_USER_COIN [NSString stringWithFormat:@"%@/user/user_coin", MAIN_URL]
//コインと交換
#define URL_COIN_EXCHANGE [NSString stringWithFormat:@"%@/user/exchange_coin", MAIN_URL]
//振り込み情報取得
#define URL_USER_BANK [NSString stringWithFormat:@"%@/user/user_bank", MAIN_URL]
//お振り込み
#define URL_MONEY_BANK [NSString stringWithFormat:@"%@/user/money_bank", MAIN_URL]
//譲渡履歴
#define URL_USER_HISTORY [NSString stringWithFormat:@"%@/user/my_history", MAIN_URL]
//譲渡履歴
#define URL_USER_HISTORY2 [NSString stringWithFormat:@"%@/user/ur_history", MAIN_URL]
//マイページの情報
#define URL_MY_ITEMS [NSString stringWithFormat:@"%@/user/get_my_items", MAIN_URL]
//マイページの情報もっととってくる
#define URL_MY_MOREITEMS [NSString stringWithFormat:@"%@/user/get_my_more", MAIN_URL]
//他人ユーザーページの情報
#define URL_USER_ITEMS [NSString stringWithFormat:@"%@/user/get_user_items", MAIN_URL]
#define URL_UR_MOREITEMS [NSString stringWithFormat:@"%@/user/get_ur_more", MAIN_URL]
#define URL_MY_COIN [NSString stringWithFormat:@"%@/user/coin_history", MAIN_URL]
#define URL_MY_MONEY [NSString stringWithFormat:@"%@/user/money_history", MAIN_URL]
//他人の出品のnego情報(sendページ)
#define URL_FIND_NEGO [NSString stringWithFormat:@"%@/negotiation/find_nego", MAIN_URL]
//自分の出品のnego情報(sendページ)
#define URL_FIND_MYNEGO [NSString stringWithFormat:@"%@/negotiation/find_my_nego", MAIN_URL]
//メッセージもっと
#define URL_MORE_MSG [NSString stringWithFormat:@"%@/negotiation/more_message", MAIN_URL]
//運営からのお知らせ
#define URL_NEWS [NSString stringWithFormat:@"%@/user/get_news", MAIN_URL]

#define URL_MESSAGE [NSString stringWithFormat:@"%@/negotiation/send_message", MAIN_URL]
#define URL_MYMESSAGE [NSString stringWithFormat:@"%@/negotiation/my_message", MAIN_URL]
//アドレス登録&送信
#define URL_MSG_ADDRESS [NSString stringWithFormat:@"%@/negotiation/send_address", MAIN_URL]
#define URL_NEGO_LIST [NSString stringWithFormat:@"%@/negotiation/get_negos", MAIN_URL]
//リクエスト送信，キャンセル
#define URL_REQ_ACTION [NSString stringWithFormat:@"%@/negotiation/send_request", MAIN_URL]
//発送，到着
#define URL_DISPATCH [NSString stringWithFormat:@"%@/negotiation/req_dispatch", MAIN_URL]
#define URL_GET_MESSAGES [NSString stringWithFormat:@"%@/negotiation/get_messages", MAIN_URL]
//他人の出品へのメッセージ
#define URL_REQ_MESSAGES [NSString stringWithFormat:@"%@/negotiation/req_messages", MAIN_URL]
//自分の出品へのメッセージ
#define URL_REQ_MYMESSAGES [NSString stringWithFormat:@"%@/negotiation/req_mymessages", MAIN_URL]
//通報
#define URL_ITEM_DOB [NSString stringWithFormat:@"%@/item/dob_item", MAIN_URL]
//出品
#define URL_ITEM_SUBMIT [NSString stringWithFormat:@"%@/item/submit_item", MAIN_URL]
//出品情報更新
#define URL_ITEM_UPDATE [NSString stringWithFormat:@"%@/item/update_item", MAIN_URL]
#define URL_ITEMS [NSString stringWithFormat:@"%@/item/get_items", MAIN_URL]
//品物情報取得（detail表示）
#define URL_ITEM [NSString stringWithFormat:@"%@/item/get_item", MAIN_URL]

#define URL_ITEM_LIST [NSString stringWithFormat:@"%@/item/search_list", MAIN_URL]
//キーワード検索
#define URL_ITEM_SEARCH [NSString stringWithFormat:@"%@/item/get_search_item", MAIN_URL]
//出品取り消し
#define URL_ITEM_DELETE [NSString stringWithFormat:@"%@/item/delete_item", MAIN_URL]
//掘り出し
#define URL_ITEM_BARGAIN [NSString stringWithFormat:@"%@/item/find_item", MAIN_URL]
//近くの出品
#define URL_ITEM_NEAR [NSString stringWithFormat:@"%@/item/near_item", MAIN_URL]
#define URL_ITEM_NEGO [NSString stringWithFormat:@"%@/item/item_nego", MAIN_URL]

#define URL_REQUEST_CANCEL [NSString stringWithFormat:@"%@/negotiation/cancel_negotiation", MAIN_URL]
#define URL_NEGOITEM_CANCEL [NSString stringWithFormat:@"%@/negotiation/cancel_negoitem", MAIN_URL]

#define URL_MY_NOTIFICATION [NSString stringWithFormat:@"%@/negotiation/get_notification", MAIN_URL]
#define URL_NEGOTIATION [NSString stringWithFormat:@"%@/negotiation/get_negotiation", MAIN_URL]
#define URL_ITEM_MESSAGE [NSString stringWithFormat:@"%@/negotiation/find_message", MAIN_URL]
#define URL_NEGO_DONE [NSString stringWithFormat:@"%@/negotiation/negotiation_done", MAIN_URL]
#define URL_ITEM_RECEIVED [NSString stringWithFormat:@"%@/negotiation/item_received", MAIN_URL]
