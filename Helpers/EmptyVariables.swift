//
//  EmptyVariables.swift
//  SwearBy
//
//  Created by Colin Power on 3/4/23.
//

import Foundation

class EmptyVariables {
    
    //var empty_access = Access(group: "", list: [], is_private_account: false)
    
    //var empty_live_on_webpage = LiveOnWebpage(_ID: "", _STATUS: "", host: "", path: "", prefix: "", full: "", user_ids: [], user_timestamps: [], last_chat_text: "", last_chat_user_id: "", last_chat_user_name: "", num_currently_live: 0, last_live_timestamp: 0, num_posts: 0, last_post_timestamp: 0, timestamp: NewTimestamps(archived: 0, created: 0, deleted: 0, expired: 0, updated: 0), chat_ids: [])
    
//    var empty_new_post = NewPosts(_ID: "", _STATUS: "", access: Access(group: "", list: [], is_private_account: false), image_url: "", isSwornBy: false, likes: [], override_url: "", photos: [], poll: Poll_Struct(prompt: "", text1: "", text2: "", text3: "", text4: "", votes1: [], votes2: [], votes3: [], votes4: [], expiration: 0), referral: Referral_Struct(code: "", link: "", commission_value: "", commission_type: "", offer_value: "", offer_type: "", for_new_customers_only: false, minimum_spend: "", expiration: 0), replies: [], title: "", text: "", timestamp: NewTimestamps(archived: 0, created: 0, deleted: 0, expired: 0, updated: 0), url: Url_Struct(host: "", path: "", prefix: "", full: "", original: "", type: "", page_title: "", site_title: "", site_favicon: "", site_id: ""), user: User_Snippet(_ID: "", name: Struct_Profile_Name(first: "", last: "", first_last: ""), email: "", phone: ""))
    
//    var empty_user = Users(device_token: "", email: "", email_verified: false, followers: Struct_Profile_Followers(follow_requests: [], list: [], manually_accept_followers: true), following: Struct_Profile_Following(list: [], you_sent_follow_request: []), friend_requests: [], friends_added: [], friends_invited: [], friends_list: [], instagram: "", isDemoAccount: false, lastNotificationSeen: 0, name: Struct_Profile_Name(first: "", last: "", first_last: ""), phone: "", phone_verified: false, tiktok: "", timestamp: 0, twitter: "", user_id: "")
    
    var empty_new_post = NewPosts(_ID: "", created_by_civilian: "", likes: [], photo: "", referral: Struct_Posts_Referral(clicks: [], code: "", link: "", expiration: 0, for_new_customers_only: false, for_this_page_only: false, minimum_spend: "", offer_value: "", offer_type: ""), isPublicPost: false, text: "", timestamp: Struct_Posts_Timestamps(archived: 0, created: 0, deleted: 0, expired: 0, updated: 0), url: Struct_Posts_URL(host: "", path: "", prefix: "", full: "", original: "", image_url: "", type: "", page_title: "", site_title: "", site_favicon: "", site_id: ""), user: Struct_Posts_User(_ID: "", name: "", pic: "", socials: Struct_User_Socials(instagram: "", ltk: "", shopmy: "", tiktok: "", x: "", youtube: ""), isPublicAccount: false))
    
    var empty_user = Users(followers: Struct_User_Followers(follow_requests: [], list: [], manually_accept_followers: false), following: Struct_User_Following(list: [], you_sent_follow_request: []), info: Struct_User_Info(bio: "", email: "", name: "", phone: "", pic: ""), settings: Struct_User_Settings(device_token: "", isPublicAccount: false, timestamp: 0), socials: Struct_User_Socials(instagram: "", ltk: "", shopmy: "", tiktok: "", x: "", youtube: ""), user_id: "")
    
    var empty_user_snippet = Struct_Posts_User(_ID: "", name: "", pic: "", socials: Struct_User_Socials(instagram: "", ltk: "", shopmy: "", tiktok: "", x: "", youtube: ""), isPublicAccount: false)
    
    //var empty_user_snippet = User_Snippet(_ID: "", name: Struct_Profile_Name(first: "", last: "", first_last: ""), email: "", phone: "")
    
    
//    var empty_main_webview_content = MainWebViewContent(webviewSwitcher: .none, showWebView: false, initial_url: "", currentWebViewURL: "", new_product: EmptyVariables().empty_products)
    
}
