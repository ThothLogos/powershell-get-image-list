# Contents of Dir

__examplelist.txt__ - holds a line-by-line list of image URLs to grab, needs to be output by webapp.html

__GetPics.bat__ - PowerShell scripts (.ps1) cannot be double-clicked without system config changes, .bat is a click-able wrapper to accomplish the same goal

__webapp.html__ - placeholder

__pic_script/grabem.ps1__ - PowerShell script that does the work

__pic_script/*__ - this is a working directory which will house a temp folder and images prior to .zip output

__latest_pics.zip__ - not in repo but will be generated after script runs

# Current Process

- Browser should output a text file with a timestamp, maybe `HH.mm.ss-MMddyyyy-coverimages.txt` or something of the sort. This is to prevent windows making dupes like: `coverlist.txt (1)` and `coverlist.txt - Copy (2)` and all that stupid shit. Use a timestamp to avoid that.

- The browser file just needs to have *some* piece of the name be standard, in my example I'm using `coverimages` as a pattern I'm searching for.

- I checked the default download directory for FireFox, FireFox Dev, Chrome, Brave, Edge, they all go to `C:\Users\[USER]\Downloads` - so we try that first

- If that folder is successfully found, we iterate over all files within it, and filter down to anything matching `*coverimages*` anywhere in the filename. This, combined with the timestamp naming of the browser's output file, will give us potentially multiple image list files to work with. So we then filter them by the system's `LastWriteTime`, sort it, and grab the newest from the top of the list.

- We now have the name and path of the most recent file located in `C:\Users\[USER]\Downloads` which also contains the pattern matching whatever we put in the variable `$coverlist_pattern`.

- If for some reason the `Downloads` folder does not exist, can't be found/accessed, or whatever else, the fallback is a full search of `C:\`, and then repeating the same filtering process to find the newest matching the pattern. This fallback can be expanded/changed/narrowed easily enough, I just wanted to test using a search functionality.

- At this point we should hopefully have the file name and full path. So now we iterate it line by line, and do a `wget` for each image, conveniently name them, drop them in a temp folder, then zip that contents and name it `Cover Images 04-12-2020.zip`, placing it in the top-level folder, same location that your `vueapp.html` will be in that he runs.

 - Last step is a cleanup of all the temp files, he should only ever see the .zip to avoid confusion, so we nuke the temp folder and the raw images, and just leave the zip.
