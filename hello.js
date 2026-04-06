

// Sample URL
const inputUrl = "https://www.gymshark.com/products/gymshark-gfx-t-reps-crew-3pk-white-aw24?abc=123";

// Parse the URL using the URL class
const urlObj = new URL(inputUrl);

// Extract the protocol (e.g., "https:")
const protocol = urlObj.protocol; // "https:"

// Extract the full hostname (e.g., "www.gymshark.com")
const fullHostname = urlObj.hostname; // "www.gymshark.com"

// Determine the prefix
// In your case, you want the prefix to be "protocol://www." if the hostname starts with "www."
let prefix = protocol + "//";
if (fullHostname.startsWith("www.")) {
  prefix += "www.";
}

// Remove "www." from the hostname if present to get the clean hostname
const hostname = fullHostname.startsWith("www.") ? fullHostname.substring(4) : fullHostname;

// Build the path by concatenating the clean hostname with the pathname
// (ignoring the query string)
const path = hostname + urlObj.pathname;

console.log("prefix =", prefix);   // "https://www."
console.log("hostname =", hostname); // "gymshark.com"
console.log("path =", path);         // "


import fetch from 'node-fetch';
import * as cheerio from 'cheerio';
import express from 'express';
import functions from 'firebase-functions';
import { v4 as uuidv4 } from 'uuid';


async function getPageTitle(url) {
    // Fetch the HTML content from the URL
    const response = await fetch(url);
    const html = await response.text();
  
    // Load the HTML into Cheerio
    const $ = cheerio.load(html);
  
    // Extract the text inside the <title> tag
    return $('title').text();
};

async function getPageImage(url) {
    try {
      // Fetch the HTML content of the page
      const response = await fetch(url);
      const html = await response.text();
  
      // Load the HTML into Cheerio for parsing
      const $ = cheerio.load(html);
  
      // Try to extract the Open Graph image
      let imageUrl = $('meta[property="og:image"]').attr('content');
  
      // If no Open Graph image is found, try the Twitter image
      if (!imageUrl) {
        imageUrl = $('meta[name="twitter:image"]').attr('content');
      }
  
      return imageUrl || null;
    } catch (error) {
      console.error("Error fetching image from page:", error);
      return null;
    }
  };

  const test_url = "https://www.instagram.com/katiejanehughes"
  //"https://shopmy.us/katiejanehughes";
  
//   //"https://www.shopltk.com/explore/Thegiftstagram"
//   //"https://www.instagram.com/katiejanehughes"
//     // https://www.gymshark.com/products/gymshark-gfx-t-reps-crew-3pk-white-aw24

try {
    const title = await getPageTitle(test_url);
    console.log("Page title:", title);
  } catch (error) {
    console.error("Error retrieving page title:", error);
}

try {
    const image = await getPageImage(test_url);
    console.log("Image URL:", image);
  } catch (error) {
    console.error("Error retrieving page image:", error);
}



// NOT NEEDED HERE
// import url  from ('url');

// // Parse a URL
// const myUrl = 'https://www.example.com/path/to/page?query=param';
// const parsedUrl = url.parse(myUrl, true);

// console.log(parsedUrl.protocol); // 'https:'
// console.log(parsedUrl.hostname); // 'www.example.com'
// console.log(parsedUrl.pathname); // '/path/to/page'
// console.log(parsedUrl.query); // { query: 'param' }