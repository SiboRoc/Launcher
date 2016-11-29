
## todo, move latest bootstrap into position
$bootstrapsrcfolder = "launcher-bootstrap\build\libs"
$bootstrapfile = "launcher-bootstrap-*-all.jar"
$bootstrapdestfolder = " ..\..\projects\on\_upload\launcher"
$bootstrapdestfile = "SiboRocLauncherBootstrap-4-4.jar"

$srcfolder = "launcher/build/libs"
$destfolder = "../../projects/on/_upload/launcher/versions"

## $result = Get-ChildItem $destfolder -Filter ".jar" | Remove-Item 
$result = Get-ChildItem $srcfolder -Filter "*all.jar" | Copy-Item -Destination $destfolder -Force

$launchers = Get-ChildItem -Path ..\..\projects\on\_upload\launcher\versions
$fver = ""
$lastfile = ""

Foreach ($file in $launchers)
{
        if ($file -Match "launcher")
        {
           $parts = $file -split "\-"
           $ver = $parts[1];
           $ver = $ver -split "\."
           $ver = $ver[0] + "." + $ver[1]
           if ($ver -gt $fver)
           {
               $fver = $ver;
               $lastfile = $file
           }
        } 
}


$fver = $fver -replace '\.', '-'

$nfile = "SiboRocLauncher-" + $fver + ".jar.pack"
Write-Host "New target launcher filename: $nfile"

$packer = "C:\Program Files\Java\jdk1.8.0_101\bin\pack200.exe "

$cmd = " -g $destfolder/$nfile $destfolder/$lastfile"
Write-Host "$packer $cmd"

Invoke-Expression "& `"$packer`" $cmd"


$latestjson = "../../projects/on/_upload/latest.json"
$OFS = "`r`n"
$jsoncontent = "{" +
               $OFS +
               '     "version": "' +
               $fver + '",' +
               $OFS +
               '     "url": ' +
               '"https://s3-us-west-2.amazonaws.com/siboroc2/launcher/versions/' +
               $nfile +
               '"' +
               $OFS +
               "}"

Get-ChildItem -Path $latestjson -File | Remove-Item

Add-content "$latestjson" -value $jsoncontent

