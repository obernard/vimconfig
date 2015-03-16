$VimRcFilePath = Join-Path $HOME ".vimrc"
$VimFilesPath = Join-Path $HOME "vimfiles"
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
    curl -LSso $PathogenFilePath https://tpo.pe/pathogen.vim
}

# Gets plugins.
$BundleFolder = Join-Path $VimFilesPath "bundle"
Get-Content plugins.txt | foreach {
    $PluginRemoteAddress = $_
    # TODO: Poor man's URL2name converter. Change that!
    $PluginName = $PluginRemoteAddress.split('/')[-1].split('.')[0]
    if (-not (Test-Path (Join-Path $BundleFolder $PluginName) -PathType Container)) {
        git clone $PluginRemoteAddress $BundleFolder
    }
}
