import admin from "firebase-admin";
import express from "express";
import bodyParser from "body-parser";
import { v4 as uuidv4 } from 'uuid';
import { helper_updatePostSchemaWithNewField, helper_updatePostsSchemaWithImageURL } from "./helpers/firestore-helper2.js";
import { createNewUser } from "./endpoint/createNewUser.js";
import { createNewPost } from "./endpoint/createNewPost.js";


// Set up Express app
const express_app = express();
express_app.use(bodyParser.json());
express_app.use(bodyParser.urlencoded({
    extended: true,
}));






// 3 main functions: create user, create post, check if user exists

express_app.post('/user/create', async (req, res) => {
    const o = req.body;
  
    // Ensure there is at least one social field provided
    if (!o.socials || (!o.socials.instagram && !o.socials.tiktok && !o.socials.ltk)) {
      return res.status(400).send("At least one social field is required.");
    }
  
    try {
      // Create an array to hold the query promises
      const queries = [];
  
      // Build queries only for the provided fields
      if (o.socials.instagram) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.instagram", "==", o.socials.instagram)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      if (o.socials.tiktok) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.tiktok", "==", o.socials.tiktok)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      if (o.socials.ltk) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.ltk", "==", o.socials.ltk)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      // Run all provided queries concurrently
      const results = await Promise.all(queries);
  
      // Check if any query returned a non-empty snapshot (i.e., an existing user)
      const userExists = results.some(snapshot => !snapshot.empty);
  
      if (userExists) {
        return res.status(400).send("User already exists");
      }
  
      // Create a new UUID
      const user_id = uuidv4();
      
      // Create the user in Firestore
      await createNewUser(o, user_id);

      // Return a success response
      return res.status(201).send("Created user " + user_id);

    } catch (error) {

      console.error("Error creating user:", error);
      return res.status(500).send("Internal server error");
    }
  });


  express_app.post('/user/exists', async (req, res) => {
    const o = req.body;
  
    // Ensure there is at least one social field provided
    if (!o.socials || (!o.socials.instagram && !o.socials.tiktok && !o.socials.ltk)) {
      return res.status(400).send("At least one social field is required.");
    }
  
    try {
      // Create an array to hold the query promises
      const queries = [];
  
      // Build queries only for the provided fields
      if (o.socials.instagram) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.instagram", "==", o.socials.instagram)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      if (o.socials.tiktok) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.tiktok", "==", o.socials.tiktok)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      if (o.socials.ltk) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.ltk", "==", o.socials.ltk)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      // Run all provided queries concurrently
      const results = await Promise.all(queries);
  
      // Check if any query returned a non-empty snapshot (i.e., an existing user)
      const userExists = results.some(snapshot => !snapshot.empty);
  
      if (userExists) {  

        return res.status(200).send("Public user exists with these socials");
      } else {

        // If no user, return 200
        return res.status(200).send("No Public User Found");

      }
    } catch (error) {
      console.error("Error checking for user:", error);
      return res.status(500).send("Internal server error checking for user");
    }
  });







express_app.post('/post/create', async (req, res) => {

    // Grab the JSON from the request
    const o = req.body;
  
    // Ensure there is at least one social field provided
    if (!o.socials || (!o.socials.instagram && !o.socials.tiktok && !o.socials.ltk)) {
      return res.status(400).send("At least one social field is required.");
    }
  
    try {
      // Create an array to hold the query promises
      const queries = [];
  
      // Build queries only for the provided fields
      if (o.socials.instagram) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.instagram", "==", o.socials.instagram)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      if (o.socials.tiktok) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.tiktok", "==", o.socials.tiktok)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      if (o.socials.ltk) {
        queries.push(
          admin.firestore().collection("new_users")
            .where("socials.ltk", "==", o.socials.ltk)
            .where("settings.isPublicAccount", "==", true)
            .get()
        );
      }
  
      // Run all provided queries concurrently
      const results = await Promise.all(queries);
  
      // Check if any query returned a non-empty snapshot (i.e., an existing user)
      const userExists = results.some(snapshot => !snapshot.empty);
  
      if (userExists) {

        const found_user = !results[0].empty ? results[0].docs[0].data() : !results[1].empty ? results[1].docs[0].data() : results[2].docs[0].data();
        
        // Grab the fields for the new post
        const user_id = found_user.user_id;
        const name = found_user.info.name;
        const pic = found_user.info.pic;
        const instagram = found_user.socials.instagram;
        const ltk = found_user.socials.ltk;
        const shopmy = found_user.socials.shopmy;
        const tiktok = found_user.socials.tiktok;
        const x = found_user.socials.x;
        const youtube = found_user.socials.youtube;
        const post_id = uuidv4();

        // Need to get host, path, prefix, full, image_url, page_title


        // Create the new post
        await createNewPost(o, user_id, name, pic, instagram, ltk, shopmy, tiktok, x, youtube, post_id);

        // Return 201 for the post, and note whether a user was created
        return res.status(201).send("Created post " + post_id + " for found user " + found_user.info.name + " with uuid " + found_user.user_id);

      } else {

        // Return 201 for the post, and note whether a user was created
        return res.status(400).send("User does not exist");

      }
  
    } catch (error) {
      console.error("Error creating post:", error);
      return res.status(500).send("Internal server error");
    }
});



export default express_app;


// express_app.post('/post/updateSchemaImageURL', async (req, res) => {

//   await helper_updatePostsSchemaWithImageURL();    

//   return res.sendStatus(201);
// });



// express_app.post('/post/updateSchemaWithNewField', async (req, res) => {

//     await helper_updatePostSchemaWithNewField();    

//     return res.sendStatus(201);
// });






// This actually works, but Instagram limits web crawling
// express_app.post('/user/test', async (req, res) => {
  
//   // Grab the picture of the user
//   try {
//     //const test_url = "https://www.instagram.com/katiejanehughes"
//     const test_url = "https://www.gymshark.com/products/gymshark-gfx-t-reps-crew-3pk-white-aw24"

    

//     const pic = await getPageImage(test_url);
//     console.log("Image URL:", pic);

//     const title = await getPageTitle(test_url);
//     console.log("Page title:", title);

//     return res.status(200).send("Title " + title + " and image " + pic);

//     } catch (error) {

//       console.error("Error retrieving page image:", error);
//       return res.status(500).send("Error retrieving page image");
//   } 


// });




// express_app.post('/post/updateSchemaWithNewField', async (req, res) => {

//     await helper_updatePostSchemaWithNewField();    

//     return res.sendStatus(201);
// });



// express_app.post('/user/updateSchema', async (req, res) => {

//     await helper_updateUserSchema();    

//     return res.sendStatus(201);
// });

// express_app.post('/post/updateSchema', async (req, res) => {

//     await helper_updatePostsSchema();    

//     return res.sendStatus(201);
// });



// express_app.post('/user/createPublicUser', async (req, res) => {

//     const o = req.body;

//     // Check if the user exists

//     // Check instagram
//     if (o.socials.instagram != "") {
//         const user_insta = await admin.firestore().collection("new_users").where("socials.instagram", "==", o.socials.instagram).where("settings.isPublicAccount", "==", true).get();

//         if (!user_insta.empty) {
//             const found_user = user_insta.docs[0].data();
//             return res.status(400).send("User already exists: " + found_user.user_id);
//         }
//     } 
    
//     if (o.socials.ltk != "") {
//         const user_ltk = await admin.firestore().collection("new_users").where("socials.tiktok", "==", o.socials.tiktok).where("settings.isPublicAccount", "==", true).get();

//         if (!user_ltk.empty) {
//             const found_user = user_ltk.docs[0].data();
//             return res.status(400).send("User already exists: " + found_user.user_id);
//         }
//     } 
    
//     if (o.socials.tiktok != "") {
//         const user_tiktok = await admin.firestore().collection("new_users").where("socials.ltk", "==", o.socials.ltk).where("settings.isPublicAccount", "==", true).get();

//         if (!user_tiktok.empty) {
//             const found_user = user_tiktok.docs[0].data();
//             return res.status(400).send("User already exists: " + found_user.user_id);
//         }
//     }
    
//     // Return an error if the user exists
//     if (!user_insta.empty || !user_tiktok.empty || !user_ltk.empty) {

//         const found_user = !user_insta.isEmpty ? user_insta.docs[0].data() : !user_tiktok.isEmpty ? user_tiktok.docs[0].data() : user_ltk.docs[0].data();

//         return res.status(400).send("User already exists: " + found_user.user_id);
//     } else {

//         // Create a new UUID
//         const user_id = uuidv4();

//         // Create the user
//         await createNewUserInNewSchema(o, user_id);

//         // Return 201 success
//         return res.status(201).send("Created user " + user_id);
//     }
// });


// express_app.post('/post/updateSchema', async (req, res) => {

//     await helper_updatePostsSchema();    

//     return res.sendStatus(201);
// });


// express_app.post('/user/updateSchemaWithNewField', async (req, res) => {

//     await helper_updateUserSchemaWithNewField();    

//     return res.sendStatus(201);
// });