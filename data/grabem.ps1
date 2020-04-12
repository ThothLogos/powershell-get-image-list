# Grab a timestamp to name our temp folder which will hold images
$outdir = Get-Date -Format "HH.mm.ss-MM-dd-yyyy"
$datadir = ".\data"
$download_dir = "C:\Users\$env:UserName\Downloads"

echo "User holds: $download_dir"

# If this folder doesn't exist, make it so
if (-Not (Test-Path -Path "$datadir\$outdir")) {
  New-Item -ItemType Directory -Force -Path $datadir\$outdir
}

# Loop over each line of the input file
foreach($line in Get-Content .\examplelist.txt) {
  # We expect an image URL, so chop off the last bit to use as a filename
  $pic=$line.Split("{/}")[-1]
  # Equivalent of wget, snatch the image and save it as the name we just split off
  Invoke-WebRequest $line -OutFile $datadir\$outdir\$pic
}

# Grab a date to attach to our zip filename
$zipdate = Get-Date -Format "MM-dd-yyyy"

# Compress contents of the timestamped folder into a zip file, export to top-level
# -Update handles cases of the file already existing with today's date, it will be replaced
# # and updated with new entries, if necessary
Compress-Archive -Path $datadir\$outdir\* -Update -DestinationPath ".\Cover Images $zipdate"

# Remove the timestamped folder which was holding our raw images
Remove-Item -Recurse -Force "$datadir\$outdir"