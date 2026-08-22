$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Set-Location $repositoryRoot

$version = (Get-Content -Raw -LiteralPath 'VERSION').Trim()
if ($version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'VERSION must contain a semantic version such as 1.0.0.'
}

$skillNameLine = Get-Content -LiteralPath 'SKILL.md' |
    Where-Object { $_ -match '^name:\s*' } |
    Select-Object -First 1
$skillName = $skillNameLine -replace '^name:\s*', ''
if ($skillName -ne 'rm-skill-codex') {
    throw 'SKILL.md must declare name: rm-skill-codex.'
}

$requiredFiles = @(
    'SKILL.md',
    'README.md',
    'agents/openai.yaml',
    'references/splitting-commits.md'
)
foreach ($requiredFile in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $requiredFile -PathType Leaf)) {
        throw "$requiredFile is required in the release package."
    }
}

$documentationFiles = Get-ChildItem -LiteralPath 'docs' -Filter '*.md' -File
if ($documentationFiles.Count -eq 0) {
    throw 'At least one Markdown file is required in docs/.'
}

$outputDirectory = Join-Path $repositoryRoot 'dist'
$packageDirectory = Join-Path $outputDirectory 'rm-skill-codex'
$archiveName = "rm-skill-codex-v$version.zip"
$archivePath = Join-Path $outputDirectory $archiveName

if (Test-Path -LiteralPath $outputDirectory) {
    Remove-Item -LiteralPath $outputDirectory -Recurse -Force
}

New-Item -ItemType Directory -Path (
    Join-Path $packageDirectory 'agents'
), (
    Join-Path $packageDirectory 'docs'
), (
    Join-Path $packageDirectory 'references'
) | Out-Null

Copy-Item -LiteralPath 'README.md', 'SKILL.md' -Destination $packageDirectory
Copy-Item -LiteralPath 'agents/openai.yaml' -Destination (
    Join-Path $packageDirectory 'agents'
)
Copy-Item -LiteralPath $documentationFiles.FullName -Destination (
    Join-Path $packageDirectory 'docs'
)
Copy-Item -LiteralPath 'references/splitting-commits.md' -Destination (
    Join-Path $packageDirectory 'references'
)

Compress-Archive -LiteralPath $packageDirectory -DestinationPath $archivePath
$checksum = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
$checksumPath = "$archivePath.sha256"
Set-Content -LiteralPath $checksumPath -Value "$checksum  $archiveName" -Encoding ascii

Write-Output "Created $archivePath"
Write-Output "Created $checksumPath"
