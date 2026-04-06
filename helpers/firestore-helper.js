import { getFirestore } from 'firebase-admin/firestore'
import { getTimestamp } from "./helper.js";



// DANGER: EDITING LIVE DATABASE //
export async function updateLiveOnWebpage() {

    const db = getFirestore();

    const snapshot = await db.collection("live_on_webpage")
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        const object = {
            _ID: post._ID,
            _STATUS: post._STATUS,
            chat_ids: post.chat_ids,
            full: post.full,
            host: post.host,
            last_chat_text: post.last_chat_text,
            last_chat_user_id: post.last_chat_user_id,
            last_chat_user_name: post.last_chat_user_name,
            last_live_timestamp: post.last_live_timestamp,
            last_post_timestamp: post.last_post_timestamp,
            num_currently_live: 0,
            num_posts: post.num_posts,
            path: post.path,
            prefix: post.prefix,
            timestamp: {
                archived: post.timestamp.archived,
                created: post.timestamp.created,
                deleted: post.timestamp.deleted,
                expired: post.timestamp.expired,
                updated: post.timestamp.updated
            },
            user_ids: [],
            user_timestamps: []
        }

        db.collection("live_on_webpage").doc(post._ID).set(object);
    });
};










export async function getUser(user_id) {

    const db = getFirestore();

    const snap = await db.collection("users").doc(user_id).get()
    if (!snap.exists) {
        console.log('No user exists for', user_id);
        return null;
    } else {
        return snap.data();
    }
};

export async function getDMGroup(group_id) {

    const db = getFirestore();

    const snap = await db.collection("groups").doc(group_id).get()
    if (!snap.exists) {
        console.log('No group exists for', group_id);
        return null;
    } else {
        return snap.data();
    }
};

export async function getPost(post_id) {

    const db = getFirestore();

    const snap = await db.collection("posts").doc(post_id).get()
    if (!snap.exists) {
        console.log('No post exists for', post_id);
        return null;
    } else {
        return snap.data();
    }
};

export async function getRequest(request_id) {

    const db = getFirestore();

    const snap = await db.collection("requests").doc(request_id).get()
    if (!snap.exists) {
        console.log('No request exists for', request_id);
        return null;
    } else {
        return snap.data();
    }
};

export async function getComment(comment_id) {

    const db = getFirestore();

    
    const snap = await db.collection("comments").doc(comment_id).get()
    if (!snap.exists) {
        console.log('No comment exists for', comment_id);
        return null;
    } else {
        return snap.data();
    }
};

export async function createDMGroup(u1, u2, group_id) {
    
    const object = {
        _ID: group_id,
        _STATUS: "ACTIVE",
        group_id: group_id,
        lastUpdated: getTimestamp(),
        member_ids: [ u1.user_id, u2.user_id ],
        members: [ {
            first_name: u1.name.first,
            last_accessed: getTimestamp(),
            user_id: u1.user_id 
        }, {
            first_name: u2.name.first,
            last_accessed: getTimestamp(),
            user_id: u2.user_id
        }],
        name: "<DM>",
        timestamp: {
            archived: 0,
            created: getTimestamp(),
            deleted: 0,
            expired: 0
        },
        user: {
            _ID: u1.user_id,
            email: u1.email,
            name: {
                first: u1.name.first,
                first_last: u1.name.first_last,
                last: u1.name.last
            },
            phone: u1.phone
        }
    };

    const db = getFirestore();

    return db.collection("groups").doc(group_id).set(object);

};

export async function reactivateDMGroup(group_doc) {
    
    var group = group_doc;

    group._STATUS = "ACTIVE";
    group.lastUpdated = getTimestamp();
    group.timestamp.archived = 0;

    const db = getFirestore();

    return db.collection("groups").doc(group._ID).update(group);

};

export async function deactivateDMGroup(group_doc) {
    
    var group = group_doc;

    group._STATUS = "DEACTIVATED";
    group.timestamp.archived = getTimestamp();

    const db = getFirestore();

    return db.collection("groups").doc(group._ID).update(group);
};

export async function addToPosts(uid1, uid2) {

    const db = getFirestore();

    const snapshot = await db.collection("posts") 
        .where("access.group", "==", "FOLLOWERS")
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        var addition = [uid2];
        const new_list = [...current_list, ...addition];
        
        if (!current_list.includes(uid2)) {
            post.access.list = new_list;

            
            db.collection("posts").doc(post._ID).update(post);
        }
    });

};

export async function addToRequests(uid1, uid2) {

    const db = getFirestore();

    const snapshot = await db.collection("requests") 
        .where("access.group", "==", "FOLLOWERS")
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        var addition = [uid2];
        const new_list = [...current_list, ...addition];
        
        if (!current_list.includes(uid2)) {
            post.access.list = new_list;

            db.collection("requests").doc(post._ID).update(post);
        }
    });

};

export async function addToCodes(uid1, uid2) {


    const db = getFirestore();
    
    const snapshot = await db.collection("referral_codes") 
        .where("access.group", "==", "FOLLOWERS")
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        var addition = [uid2];
        const new_list = [...current_list, ...addition];
        
        if (!current_list.includes(uid2)) {
            post.access.list = new_list;


            db.collection("referral_codes").doc(post._ID).update(post);
        }
    });
};

export async function removeFromPosts(uid1, uid2) {

    const db = getFirestore();

    const snapshot = await db.collection("posts") 
        .where("access.group", "==", "FOLLOWERS")
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        
        var filteredArray = current_list.filter(function(e) { return e !== uid2 });

        post.access.list = filteredArray;
        
        db.collection("posts").doc(post._ID).update(post);
    });

};

export async function removeFromRequests(uid1, uid2) {

    const db = getFirestore();

    const snapshot = await db.collection("requests") 
        .where("access.group", "==", "FOLLOWERS")
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        
        var filteredArray = current_list.filter(function(e) { return e !== uid2 });

        post.access.list = filteredArray;
        
        db.collection("requests").doc(post._ID).update(post);
    });

};

export async function removeFromCodes(uid1, uid2) {

    const db = getFirestore();

    const snapshot = await db.collection("referral_codes") 
        .where("access.group", "==", "FOLLOWERS")
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        
        var filteredArray = current_list.filter(function(e) { return e !== uid2 });

        post.access.list = filteredArray;
        
        db.collection("referral_codes").doc(post._ID).update(post);
    });

};

export async function removeUserFromGroup(uid1, group) {

    var new_group = group;

    var member_ids = new_group.member_ids;
    var filteredArray = member_ids.filter(function(e) { return e !== uid1 });
    new_group.member_ids = filteredArray;

    for (var i = 0; i < new_group.members.length; i++) {
        if (new_group.members[i].user_id === uid1) {
            new_group.members.splice(i, 1);
        }
    }

    const db = getFirestore();
    
    db.collection("groups").doc(group._ID).update(new_group);

};

export async function removeFromGroupPosts(uid1, group) {

    const db = getFirestore();

    const snapshot = await db.collection("posts") 
        .where("access.group", "==", group._ID)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        
        var filteredArray = current_list.filter(function(e) { return e !== uid1 });

        post.access.list = filteredArray;
        
        db.collection("posts").doc(post._ID).update(post);
    });

};

export async function removeFromGroupRequests(uid1, group) {

    const db = getFirestore();

    const snapshot = await db.collection("requests") 
        .where("access.group", "==", group._ID)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        
        var filteredArray = current_list.filter(function(e) { return e !== uid1 });

        post.access.list = filteredArray;
        
        db.collection("requests").doc(post._ID).update(post);
    });

};

export async function removeFromGroupCodes(uid1, group) {

    const db = getFirestore();

    const snapshot = await db.collection("referral_codes") 
        .where("access.group", "==", group._ID)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        var current_list = post.access.list;
        
        var filteredArray = current_list.filter(function(e) { return e !== uid1 });

        post.access.list = filteredArray;
        
        db.collection("referral_codes").doc(post._ID).update(post);
    });

};

export async function deleteGroupPosts(uid1, group) {

    const db = getFirestore();

    const snapshot = await db.collection("posts") 
        .where("access.group", "==", group._ID)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        
        db.collection("posts").doc(post._ID).update(post);
    });

};

export async function deleteGroupRequests(uid1, group) {

    const db = getFirestore();

    const snapshot = await db.collection("requests") 
        .where("access.group", "==", group._ID)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        
        db.collection("requests").doc(post._ID).update(post);
    });

};

export async function deleteGroupCodes(uid1, group) {

    const db = getFirestore();

    const snapshot = await db.collection("referral_codes") 
        .where("access.group", "==", group._ID)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        
        db.collection("referral_codes").doc(post._ID).update(post);
    });

};

export async function deleteMyPosts(uid1) {

    const db = getFirestore();

    const snapshot = await db.collection("posts") 
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        post.user.email = "deleted";
        post.user.name.first = "deleted";
        post.user.name.first_last = "deleted";
        post.user.name.last = "deleted";
        post.user.phone = "deleted";
        post.user._ID = uid1;
        
        db.collection("posts").doc(post._ID).update(post);
    });

};

export async function deleteMyRequests(uid1) {

    const db = getFirestore();

    const snapshot = await db.collection("requests") 
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        post.user.email = "deleted";
        post.user.name.first = "deleted";
        post.user.name.first_last = "deleted";
        post.user.name.last = "deleted";
        post.user.phone = "deleted";
        
        db.collection("requests").doc(post._ID).update(post);
    });

};

export async function deleteMyCodes(uid1) {

    const db = getFirestore();

    const snapshot = await db.collection("referral_codes") 
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        post.user.email = "deleted";
        post.user.name.first = "deleted";
        post.user.name.first_last = "deleted";
        post.user.name.last = "deleted";
        post.user.phone = "deleted";
        
        db.collection("referral_codes").doc(post._ID).update(post);
    });

};

export async function deleteMyComments(uid1) {

    const db = getFirestore();

    const snapshot = await db.collection("comments") 
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        post.user.email = "deleted";
        post.user.name.first = "deleted";
        post.user.name.first_last = "deleted";
        post.user.name.last = "deleted";
        post.user.phone = "deleted";
        
        db.collection("comments").doc(post._ID).update(post);
    });

};

export async function deleteMyMessages(uid1) {

    const db = getFirestore();

    const snapshot = await db.collection("messages") 
        .where("user._ID", "==", uid1)
        .get();

    snapshot.forEach(doc => {

        var post = doc.data();

        post.timestamp.deleted = getTimestamp();
        post.user.email = "deleted";
        post.user.name.first = "deleted";
        post.user.name.first_last = "deleted";
        post.user.name.last = "deleted";
        post.user.phone = "deleted";
        
        db.collection("messages").doc(post._ID).update(post);
    });

};

export async function cleanseUserDoc(user_doc) {

    const db = getFirestore();
    
    var user = user_doc;

    user.email = "";
    user.name.first = "";
    user.name.first_last = "";
    user.name.last = "";
    user.phone = "";
    user.device_token = "";

    return db.collection("users").doc(user_doc.user_id).update(user);

};
