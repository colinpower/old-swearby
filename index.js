import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';
//import 'firebase-functions/v1';
//admin.initializeApp();

import { initializeApp } from 'firebase-admin/app';
initializeApp();


// ----- CALLABLE -----

// ----- HTTPS -----
// import createNewUser from "./auth-createNewUser.js";
// import backendTrigger from "./backend-trigger.js";
// import backendTrigger2 from "./backend-trigger2.js";

// export const create_new_user = createNewUser;
// export const backend_trigger = backendTrigger;
// export const backend_trigger2 = backendTrigger2;

export { createNewUser } from "./auth-createNewUser.js";
export { backendTrigger } from "./backend-trigger.js";
export { backendTrigger2 } from "./backend-trigger2.js";


//import sendMagicLink from "./auth-sendMagicLink.js";
//import sendNotification from "./notification-noti.js";
//import sendChatNotification from "./notification-message.js";
//import sendCommentNotification from "./notification-comment.js";
//import sendFriendRequestNotification from "./notification-friend-request.js";

//import onCreateReply from "./on-create-reply.js";

//export const send_magic_link = sendMagicLink;

//export const send_notification = sendNotification;
//export const send_chat_notification = sendChatNotification;
//export const send_comment_notification = sendCommentNotification;
//export const send_friend_request_notification = sendFriendRequestNotification;

//export const on_create_reply = onCreateReply;

// ----- API -----
//import express_app from "./endpoint.js";
//export const api = functions.https.onRequest(express_app);


// import express_api from "./alchemy-api.js";
// export const event = functions.https.onRequest(express_api);
