import admin from "firebase-admin";

// Receive the object as { post_id: "1234", user_id: "abc" }
export async function like_post(o) {

    // the API will receive the POST_ID and the USER_ID
    const post_id = o.post_id;
    const user_id = o.user_id;

    // get the latest version of the post
    const snap = await admin.firestore().collection("posts").doc(post_id).get()
    const post = snap.data();

    console.log(post);

    // check that the likes array is not empty
    if (post.likes == null) {
        post.likes = [user_id];
    } else if (post.likes.length == 0) {
        post.likes = [user_id];
    } else if (!post.likes.includes(user_id)) {

        const likes = post.likes;
        const addition = [user_id];
        const new_likes = [...likes, ...addition];

        post.likes = new_likes;
        
    } else {
        return;
    }

    // update Firebase
    return admin.firestore().collection("posts").doc(post_id).update(post);
};


// Receive the object as { reply_id: "1234", user_id: "abc" }
export async function like_reply(o) {

    // the API will receive the REPLY_ID and the USER_ID
    const reply_id = o.reply_id;
    const user_id = o.user_id;

    // get the latest version of the post
    const snap = await admin.firestore().collection("replies").doc(reply_id).get()
    const reply = snap.data();

    // create the new list of likes
    var likes = reply.likes;
    var addition = [user_id];
    const new_likes = [...likes, ...addition];
    
    // check if the user has already liked the post
    if (!likes.includes(user_id)) {

        // update the post object
        reply.likes = new_likes;

        // update Firebase
        return admin.firestore().collection("replies").doc(reply_id).update(reply);
    }
};


