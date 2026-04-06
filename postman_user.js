import fetch from 'node-fetch';
import * as cheerio from 'cheerio';




/// ----------------------------------
// Set up variables (instagram, bio are required)

const instagram = "taniasarin";
const ltk = "tania_sarin";
const shopmy = "";
const tiktok = "taniasarin";
const x = "";
const youtube = "";
const bio = "Sharing fashion, beauty and home | size small tops, size 26 in jeans, 8 in shoes";

/// ----------------------------------












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
  
      return imageUrl || "";
    } catch (error) {
      console.error("Error fetching image from page:", error);
      return "";
    }
  };


const url = "https://www.instagram.com/" + instagram;

const title = await getPageTitle(url);
const image = await getPageImage(url);

// Find the index where " (@" starts
const index = title.indexOf(" (@");

// If the substring is found, slice the string up to that index; otherwise, return the whole string.
const result = index !== -1 ? title.slice(0, index) : title;

// Create the data object
const data = {
    "info": {
        "bio": bio,
        "name": result,
        "pic": image
    },
    "socials": {
        "instagram": instagram,
        "ltk": ltk,
        "shopmy": shopmy,
        "tiktok": tiktok,
        "x": x,
        "youtube": youtube
    }
};

// Convert the object to a JSON string with indentation for readability
const jsonString = JSON.stringify(data, null, 4);

// Print the JSON string to the console
console.log(jsonString);
