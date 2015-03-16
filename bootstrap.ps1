$VimRcFilePath = Join-Path $HOME ".vimrc"
$VimFilesPath = Join-Path $HOME "vimfiles"
$PathogenURL = "https://tpo.pe/pathogen.vim"
$PathogenFilePath = Join-Path $VimFilesPath (Join-Path "autoload" "pathogen.vim")

# Initialises vimrc file.
if (-not (Test-Path $VimRcFilePath -PathType Leaf)) {
    New-Item -ItemType File $VimRcFilePath | Out-Null
    echo "source $HOME\vimconfig\.vimrc" | Out-File $VimRcFilePath -Append
}

# Create folders needed by pathogen.
@((Join-Path $VimFilesPath "autoload"),
  (Join-Path $VimFilesPath "bundle")) | foreach {
    if (-not (Test-Path $_ -PathType Container)) {
        New-ITem -ItemType Directory $_ | Out-Null
    }
}

# Initialises Pathogen.
if (-not (Test-Path $PathogenFilePath -PathType Leaf)) {
    if ((Get-Host).Version.Major -eq 4) {
        Invoke-WebRequest -Uri $PathogenURL -OutFile $PathogenFilePath
    } else {
        # Let's hope Cygwin is installed! ^^
        curl -LSso $PathogenFilePath $PathogenURL
    }
}

# Gets plugins.
$BundleFolder = Join-Path $VimFilesPath "bundle"
Get-Content plugins.txt | foreach {
    $PluginRemoteAddress = $_
    # TODO: Poor man's URL2name converter. Change that!
    $PluginName = $PluginRemoteAddress.split('/')[-1].split('.')[0]
    $DestinationFolder = Join-Path $BundleFolder $PluginName
    if (-not (Test-Path $DestinationFolder -PathType Container)) {
        git clone $PluginRemoteAddress $DestinationFolder
    }
}
