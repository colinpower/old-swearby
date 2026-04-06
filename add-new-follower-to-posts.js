// #region Import and Setup
import admin from "firebase-admin";
import functions from "firebase-functions";
import {newFollower_AddToPosts} from "./helpers/firestore-helper2.js";
// #endregion

const addNewFollowerToPosts = functions.firestore
  .document('users/{doc_id}')
  .onUpdate(async (change, context) => {

    const doc_before = change.before.data();
    const doc_after = change.after.data();
    
    // Get list of followers before and after
    let followers_before = doc_before.followers.list;
    let followers_after = doc_after.followers.list;

    // Get the ID of the new follower, if it exists
    let new_follower_id = followers_after.filter(x => followers_before.indexOf(x) === -1);
    let user_id = doc_after.user._ID;

    // if it doesn't exist, return
    if (new_follower_id.length == 0) {
        return;
    }
    // else, add the new follower to all PUBLIC and FOLLOWERS posts, codes, requests
    else {
        await newFollower_AddToPosts(new_follower_id, user_id);

        return;
    }
});


export default addNewFollowerToPosts;