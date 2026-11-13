$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$out = Join-Path $root 'out'
$source = Join-Path $out 'os.img'
$padded = Join-Path $out 'CajoOS-1mb.img'
$target = Join-Path $out 'CajoOS.vdi'

if (-not (Test-Path -LiteralPath $source)) {
    throw 'out/os.img not found. Run python .\build.py first.'
}

Copy-Item -LiteralPath $source -Destination $padded -Force
$stream = [System.IO.File]::Open($padded, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Write)
try {
    if ($stream.Length -lt 1MB) {
        $stream.SetLength(1MB)
    }
} finally {
    $stream.Dispose()
}

$vboxManage = Get-Command VBoxManage.exe -ErrorAction SilentlyContinue
if ($vboxManage) {
    $vboxManagePath = $vboxManage.Source
} else {
    $vboxManagePath = Join-Path $env:ProgramFiles 'Oracle\VirtualBox\VBoxManage.exe'
    if (-not (Test-Path -LiteralPath $vboxManagePath)) {
        throw 'VBoxManage.exe not found. Install VirtualBox or add VBoxManage.exe to PATH.'
    }
}

if (Test-Path -LiteralPath $target) {
    Remove-Item -LiteralPath $target
}

& $vboxManagePath convertfromraw $padded $target --format=VDI
if ($LASTEXITCODE -ne 0) {
    throw "VBoxManage convertfromraw failed with exit code $LASTEXITCODE."
}

Write-Host "Created $target"
