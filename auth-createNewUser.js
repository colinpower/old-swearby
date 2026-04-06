// #region Import and Setup
//import * as admin from "firebase-admin";
import { getFirestore } from 'firebase-admin/firestore'
import { getTimestamp } from "./helpers/helper.js";
import * as functions from 'firebase-functions/v1';
// #endregion

export const createNewUser = functions.auth.user().onCreate(async (user) => {
        return createUsersDocument(user);
});

//export default createNewUser;

// #region createUsersDocument(user)
const createUsersDocument = async (user) => {

    const new_user = {
        followers: {
            follow_requests: [],
            list: [],
            manually_accept_followers: false
        },
        following: {
            list: [],
            you_sent_follow_request: []
        },
        info: {
            bio: "",
            email: (user.email) ? user.email : "",
            name: "",
            phone: (user.phoneNumber) ? user.phoneNumber : "",
            pic: ""
        },
        settings: {
            device_token: "",
            isPublicAccount: false,
            timestamp: getTimestamp()
        },
        socials: {
            instagram: "",
            ltk: "",
            shopmy: "",
            tiktok: "",
            x: "",
            youtube: ""
        },
        user_id: user.uid
    };

    const db = getFirestore();

    return db.collection("new_users").doc(user.uid).set(new_user);
};
// #endregion