import admin from "firebase-admin";

// Receive the object as { post_id: "1234", user_id: "abc" }
export async function unlike_post(o) {

    // the API will receive the POST_ID and the USER_ID
    const post_id = o.post_id;
    const user_id = o.user_id;

    // get the latest version of the post
    const snap = await admin.firestore().collection("posts").doc(post_id).get()
    const post = snap.data();

    // get the current likes 
    var likes = post.likes;

    // remove this user_id and update the post object
    var new_likes = likes.filter(function(e) { return e !== user_id });
    post.likes = new_likes;
    
    // update Firebase
    return admin.firestore().collection("posts").doc(post_id).update(post);
    
};

// Receive the object as { reply_id: "1234", user_id: "abc" }
export async function unlike_reply(o) {

    // the API will receive the REPLY_ID and the USER_ID
    const reply_id = o.reply_id;
    const user_id = o.user_id;

    // get the latest version of the post
    const snap = await admin.firestore().collection("replies").doc(reply_id).get()
    const reply = snap.data();

    // get the current likes 
    var likes = reply.likes;

    // remove this user_id and update the post object
    var new_likes = likes.filter(function(e) { return e !== user_id });
    reply.likes = new_likes;
    
    // update Firebase
    return admin.firestore().collection("replies").doc(reply_id).update(reply);
};
