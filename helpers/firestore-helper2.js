import { getFirestore } from 'firebase-admin/firestore'
import { getTimestamp } from "./helper.js";
import { user } from "firebase-functions/v1/auth";
import { link } from "telegraf/format";


// export async function helper_updateUserSchemaWithNewField() {

//     const snapshot = await admin.firestore().collection("new_users").get();
        
//     snapshot.forEach(doc => {

//         var current_user_object = doc.data();

//         if (current_user_object.socials.shopmy == undefined) {
//             var new_user_object = current_user_object;

//             // Set the Followers, Following, requested_to_follow_you, you_sent_follow_request
//             new_user_object.socials = {
//                 "instagram": current_user_object.socials.instagram,
//                 "ltk": current_user_object.socials.ltk,
//                 "shopmy": "",
//                 "tiktok": current_user_object.socials.tiktok,
//                 "x": current_user_object.socials.x,
//                 "youtube": current_user_object.socials.youtube
//             };

//             return admin.firestore().collection("new_users").doc(current_user_object.user_id).set(new_user_object);
//         };
//     });

// };



// export async function helper_updatePostsSchemaWithImageURL() {

//     const snapshot = await admin.firestore().collection("new_posts").get();
        
//     snapshot.forEach(doc => {

//         var current_post_object = doc.data();

//         if (current_post_object.url.image_url == undefined) {
//             var new_post_object = current_post_object;

//             // Set the Followers, Following, requested_to_follow_you, you_sent_follow_request
//             new_post_object.url = {
//                 "full": current_post_object.url.full,
//                 "host": current_post_object.url.host,
//                 "image_url": "",
//                 "original": current_post_object.url.original,
//                 "page_title": current_post_object.url.page_title,
//                 "path": current_post_object.url.path,
//                 "prefix": current_post_object.url.prefix,
//                 "site_favicon": current_post_object.url.site_favicon,
//                 "site_id": current_post_object.url.site_id,
//                 "site_title": current_post_object.url.site_title,
//                 "type": current_post_object.url.type
//             };

//             return admin.firestore().collection("new_posts").doc(current_post_object._ID).set(new_post_object);
//         };
//     });

// };





// export async function helper_updatePostSchemaWithNewField() {

//     const snapshot = await admin.firestore().collection("new_posts").get();
        
//     snapshot.forEach(doc => {

//         var current_post = doc.data();

//         var new_post = current_post;

//         new_post.created_by_civilian = "";

//         return admin.firestore().collection("new_posts").doc(current_post._ID).set(new_post);
//     });
// };




// export async function helper_updateUserSchema() {

//     const snapshot = await admin.firestore().collection("users").get();
        
//     snapshot.forEach(doc => {

//         var old_user = doc.data();
        
//         const new_user = {
//             followers: {
//                 follow_requests: old_user.followers.follow_requests,
//                 list: old_user.followers.list,
//                 manually_accept_followers: old_user.followers.manually_accept_followers
//             },
//             following: {
//                 list: old_user.following.list,
//                 you_sent_follow_request: old_user.following.you_sent_follow_request
//             },
//             info: {
//                 bio: old_user.isDemoAccount ? old_user.phone : "",
//                 email: old_user.email,
//                 name: old_user.name.first_last,
//                 phone: old_user.phone,
//                 pic: old_user.user_id
//             },
//             settings: {
//                 device_token: old_user.device_token,
//                 isPublicAccount: old_user.isDemoAccount,
//                 timestamp: old_user.timestamp
//             },
//             socials: {
//                 instagram: old_user.instagram,
//                 ltk: old_user.twitter,
//                 tiktok: old_user.tiktok,
//                 x: "",
//                 youtube: ""
//             },
//             user_id: old_user.user_id
//         };

//         // Set the account type
//         // new_user_object.isDemoAccount = false;

//         return admin.firestore().collection("new_users").doc(old_user.user_id).set(new_user);
    
//     });

// };






// export async function helper_duplicateUsers() {

//     const snapshot = await admin.firestore().collection("users").get();
        
//     snapshot.forEach(doc => {

//         var current_user_object = doc.data();
//         var new_user_object = current_user_object;

//         return admin.firestore().collection("duplicated_users").doc(current_user_object.user_id).set(new_user_object);
    
//     });

// };





export async function helper_deleteSpecificPosts() {

    const db = getFirestore();

    const snapshot = await db.collection("posts")
        .where("user._ID", "==", "E22U3BQ2jycJ2WMnZIth7gVrIKL2")
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        if (post.timestamp.created < 1706795706) {
            return db.collection("posts").doc(post._ID).delete();
        } else {
            return;
        }
    });

};





// export async function helper_fixPosts() {

//     const snapshot = await admin.firestore().collection("posts")
//     .where("access.group", "==", "FRIENDS")
//     .get();
        
//     snapshot.forEach(doc => {

//         var current_post_object = doc.data();
//         var new_post_object = current_post_object;

//         // Set the Followers, Following, requested_to_follow_you, you_sent_follow_request
//         new_post_object.access = {
//             "list": new_post_object.access.list,
//             "is_private_account": new_post_object.access.is_private_account,
//             "group": "FOLLOWERS"
//         };

//         return admin.firestore().collection("posts").doc(new_post_object._ID).update(new_post_object);
    
//     });

// };






// export async function newFollower_AddToReferralCodes(new_follower_id, user_id) {

//     const snapshot = await admin.firestore().collection("referral_codes")
//     .where("access.group", "in", ["FOLLOWERS", "PUBLIC"])
//     .where("user._ID", "==", user_id)
//     .get();
        
//     snapshot.forEach(doc => {

//         var code = doc.data();

//         return updateDocWithNewFollowerID("codes", code, new_follower_id);
//     });
// };



export async function helper_fixUsers() {

    const db = getFirestore();

    const snapshot = await db.collection("users").get();
        
    snapshot.forEach(doc => {

        var current_user_object = doc.data();
        var new_user_object = current_user_object;

        // Set the Followers, Following, requested_to_follow_you, you_sent_follow_request
        new_user_object.followers = {
            "list": current_user_object.friends_list,
            "follow_requests": current_user_object.friend_requests,
            "manually_accept_followers": true
        };

        new_user_object.following = {
            "list": current_user_object.friends_list,
            "you_sent_follow_request": current_user_object.friends_added
        };

        new_user_object.socials = {
            "twitter": "",
            "instagram": "",
            "tiktok": "",
            "ltk": "",
            "youtube": "",
            "website": "",
            "link_in_bio": ""
        }

        new_user_object.pic = ""


        // const object = {
        //     _ID: post._ID,
        //     _STATUS: post._STATUS,
        //     chat_ids: post.chat_ids,
        //     full: post.full,
        //     host: post.host,
        //     last_chat_text: post.last_chat_text,
        //     last_chat_user_id: post.last_chat_user_id,
        //     last_chat_user_name: post.last_chat_user_name,
        //     last_live_timestamp: post.last_live_timestamp,
        //     last_post_timestamp: post.last_post_timestamp,
        //     num_currently_live: 0,
        //     num_posts: post.num_posts,
        //     path: post.path,
        //     prefix: post.prefix,
        //     timestamp: {
        //         archived: post.timestamp.archived,
        //         created: post.timestamp.created,
        //         deleted: post.timestamp.deleted,
        //         expired: post.timestamp.expired,
        //         updated: post.timestamp.updated
        //     },
        //     user_ids: [],
        //     user_timestamps: []
        // }

        // Set the account type
        new_user_object.isDemoAccount = false;

        return db.collection("new_users").doc(current_user_object.user_id).set(new_user_object);
    
    });

};



export async function movePostsToArchive() {

    const db = getFirestore();

    const snapshot = await db.collection("posts").get();
        
    snapshot.forEach(doc => {

        var current_post = doc.data();

        var new_post = current_post;

        return db.collection("zz_archive_posts").doc(current_post._ID).set(new_post);
    });
};

export async function moveUsersToArchive() {

    const db = getFirestore();

    const snapshot = await db.collection("users").get();
        
    snapshot.forEach(doc => {

        var current_user = doc.data();

        var new_user = current_user;

        return db.collection("zz_archive_users").doc(current_user.user_id).set(new_user);
    });
};



export async function updatePostsSchema() {

    const db = getFirestore();

    const snapshot = await db.collection("new_posts").get();
        
    snapshot.forEach(doc => {

        var old_post = doc.data();

        const new_post = {
            post_id: old_post._ID,
            upvotes: [],
            downvotes: [],
            clicks: 0,
            photo: "",
            discount: {
                code: old_post.referral.code,
                isLink: false,
                expiration: old_post.referral.expiration,
                for_new_customers_only: old_post.referral.for_new_customers_only,
                for_this_page_only: false,
                minimum_spend: old_post.referral.minimum_spend,
                type: old_post.referral.offer_type,
                value: old_post.referral.offer_value,
                simple_description: ""
            },
            text: old_post.text,
            timestamp: {
                archived: old_post.timestamp.archived,
                created: old_post.timestamp.created,
                deleted: old_post.timestamp.deleted
            },
            url: {
                full: old_post.url.full,
                host: old_post.url.host,
                path: old_post.url.path,
                prefix: old_post.url.prefix,
                site_title: old_post.url.site_title,
                site_id: ""
            },
            creator: {
                user_id: "",
                name: "",
                handle: "",
                social_platform: "",
                pic: ""
            },
            user: {
                user_id: old_post.user._ID,
                name: old_post.user.name,
                handle: old_post.user.socials.instagram,
                social_platform: "INSTAGRAM",
                pic: "",
                isAnonymous: false
            }
        };

        return db.collection("posts").doc(old_post._ID).set(new_post);
    
    });

};




export async function updateUsersSchema() {

    const db = getFirestore();

    const snapshot = await db.collection("new_users").get();
        
    snapshot.forEach(doc => {

        var old_user = doc.data();

        const new_entry = {
            user_id: old_user.user_id,
            name: old_user.info.name,
            info: {
                phone: old_user.info.phone,
                total_upvotes: 0,
                created_timestamp: old_user.settings.timestamp,
                isVIP: false
            },
            settings: {
                device_token: old_user.settings.device_token,
                pic: old_user.info.pic,
                onboardingComplete: false,
                email: old_user.info.email
            },
            socials: {
                instagram: old_user.socials.instagram,
                ltk: old_user.socials.ltk,
                shopmy: old_user.socials.shopmy,
            }        
        };
        return db.collection("users").doc(old_user.user_id).set(new_entry);
    
    });

};