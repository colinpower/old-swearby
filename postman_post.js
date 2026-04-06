import fetch from 'node-fetch';
import * as cheerio from 'cheerio';



/// ----------------------------------
//Initialize variables

const url = "https://dehanche.com/products/hollyhock-suede-chocolate-suede-silver";
const instagram = "taniasarin";

const ltk = "";
const tiktok = "";
const text = "From my website - get 10% off!";
const code = "TANIA10";
const link = "";                
const offer_type = "%"; 
const offer_value = "10";         

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



// Find the index of "?" in the URL
const queryIndex = url.indexOf('?');

// If the "?" exists, slice the string up to that index; otherwise, keep the URL as is.
const cleanUrl = queryIndex !== -1 ? url.slice(0, queryIndex) : url;


// Parse the URL using the URL class
const urlObj = new URL(cleanUrl);

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

const title = await getPageTitle(cleanUrl);
const image = await getPageImage(cleanUrl);

const trimmedTitle = title.trim();

// Create the data object
const data = {
    "socials": {
        "instagram": instagram,
        "ltk": ltk,
        "tiktok": tiktok
    },
    "text": text,
    "url": {
        "prefix": prefix,
        "host": hostname,
        "path": path,
        "full": cleanUrl,
        "page_title": trimmedTitle,
        "image_url": image
    },
    "referral": {
        "code": code,
        "link": link,
        "offer_type": offer_type,
        "offer_value": offer_value
    }
};

// Convert the object to a JSON string with indentation for readability
const jsonString = JSON.stringify(data, null, 4);

// Print the JSON string to the console
console.log(jsonString);
