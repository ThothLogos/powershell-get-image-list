
# Grab a timestamp to name our temp folder which will hold images
$outdir = Get-Date -Format "HHmmss_MM-dd-yyyy"

# If this folder doesn't exist, make it so
if (-Not (Test-Path -Path ".\pic_script\$outdir")) {
  New-Item -ItemType Directory -Force -Path .\pic_script\$outdir
}

# Loop over each line of the input file
foreach($line in Get-Content .\examplelist.txt) {
  # We expect an image URL, so chop off the last bit to use as a filename
  $pic=$line.Split("{/}")[-1]
  # Equivalent of wget, snatch the image and save it as the name we just split off
  Invoke-WebRequest $line -OutFile .\pic_script\$outdir\$pic
}

# Grab a date to attach to our zip filename
$zipdate = Get-Date -Format "MM-dd-yyyy"

# Compress contents of the timestamped folder into a zip file, export to top-level
Compress-Archive -Path .\pic_script\$outdir\* -DestinationPath ".\Cover Images $zipdate"

# Remove the timestamped folder which was holding our raw images
Remove-Item '.\pic_script\$outdir' -Recurse