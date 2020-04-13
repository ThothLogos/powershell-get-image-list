$datadir = ".\data"
$download_dir = "C:\Users\$env:UserName\Downloads"
$coverlist_pattern = "*coverimages*"

# Find the browser's output file, first check the default system download dir
if (Test-Path -Path "$download_dir") {
  $newest = Get-ChildItem -Path "$download_dir" -File -Filter $coverlist_pattern |
            Sort-Object LastAccessTime -Descending |
            Select-Object -First 1 | % { $_.FullName }
  if ($newest) { echo "Newest was found in Downloads: $newest" }
} else {
  echo "`nDefault download folder ($download_dir) not found, attempting search."
  echo "`n`t(This may take a minute! Please wait...)`n"
  $newest = Get-ChildItem -Path C:\ -Filter $coverlist_pattern -Recurse -ErrorAction SilentlyContinue -Force |
            Sort-Object LastAccessTime -Descending |
            Select-Object -First 1 | % { $_.FullName }
  echo "Search results: $newest"
}

### At this point, hopefully we found the file...
if (!($newest)) { exit } # If not, let's bail

$outdir = Get-Date -Format "HH.mm.ss-MM-dd-yyyy" # Temp folder named with timestamp

# If a timestamped folder doesn't exist, make it so - will hold the pics before zipping
if (-Not (Test-Path -Path "$datadir\$outdir")) {
  New-Item -ItemType Directory -Force -Path $datadir\$outdir
}

foreach($line in Get-Content $newest) {
  $pic=$line.Split("{/}")[-1] # We expect image URL, chop off the last bit for filename
  # wget the file and use split-name
  Invoke-WebRequest $line -OutFile $datadir\$outdir\$pic
}

# Grab a date to attach to our zip filename
$zipdate = Get-Date -Format "MM-dd-yyyy"

# Compress contents of the timestamped folder into a zip file, export to top-level
Compress-Archive -Path $datadir\$outdir\* -Update -DestinationPath ".\Cover Images $zipdate"

# Remove the timestamped folder which was holding our raw images
Remove-Item -Recurse -Force "$datadir\$outdir"

sleep 10