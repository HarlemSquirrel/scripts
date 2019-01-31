/*
 * Scroll through Yahoo Mail 10 times to load more messages.
 * This is useful for bulk archival or deletion.
 *
 * Run this in the browser console after logging in to mail.yahoo.com
 */

var div = document.querySelector('[data-name="scroll-area"]')
var i = 0, numTimes = 10

function scrollYahooMail() {
  console.log("Scrolling Yahoo Mail iteration: " + i + " of " + numTimes)
  div.scrollTop = div.scrollHeight
  i++
  if ( i < numTimes ) { setTimeout( scrollYahooMail, 4000 ) }
}

scrollYahooMail()
