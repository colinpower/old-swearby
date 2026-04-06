import admin from "firebase-admin";
import functions from "firebase-functions";

const onCreateReply = functions.firestore
  .document('replies/{doc_id}')
  .onCreate(async (snap, context) => {

    // Grab the data
    const reply = snap.data();
    const reply_id = context.params.doc_id;

    // Check if the reply was directly to a post
    if (reply.linked_to.post_id != null) {

        // If so, grab the post_id
        const post_id = reply.linked_to.post_id;

        // Update the post
        return addReplyToPost(post_id, reply_id);
        
    } else {
        return;
    }
});

export default onCreateReply;




const addReplyToPost = async (post_id, reply_id) => {

    // Grab the post
    const snap = await admin.firestore().collection("posts").doc(post_id).get()
    const post = snap.data();

    // create the new list of replies
    var replies = post.replies;
    var addition = [reply_id];
    const new_replies = [...replies, ...addition];

    // update the post object
    post.replies = new_replies;

    // update Firebase
    return admin.firestore().collection("posts").doc(post_id).update(post);
};