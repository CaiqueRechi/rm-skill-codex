$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Set-Location $repositoryRoot

$pluginName = 'crow'
$marketplaceName = 'codex-crow'
$pluginRoot = Join-Path 'plugins' $pluginName

function Read-Text([string] $path) {
    return (Get-Content -Raw -Encoding UTF8 -LiteralPath $path) -replace "`r`n", "`n"
}

$version = (Get-Content -Raw -LiteralPath 'VERSION').Trim()
if ($version -notmatch '^\d+\.\d+\.\d+$') {
    throw 'VERSION must contain a semantic version such as 1.0.0.'
}

$manifest = Read-Text (Join-Path $pluginRoot '.codex-plugin/plugin.json') | ConvertFrom-Json
if ($manifest.name -ne $pluginName) {
    throw "plugin.json must declare name: $pluginName."
}
# Codex reads the manifest version to detect updates, the release reads VERSION.
if ($manifest.version -ne $version) {
    throw "plugin.json version must match VERSION ($version)."
}

$marketplace = Read-Text '.agents/plugins/marketplace.json' | ConvertFrom-Json
if ($marketplace.name -ne $marketplaceName) {
    throw ".agents/plugins/marketplace.json must declare name: $marketplaceName."
}
$marketplaceEntry = $marketplace.plugins | Where-Object { $_.name -eq $pluginName }
if ($null -eq $marketplaceEntry -or $marketplaceEntry.source.path -ne "./plugins/$pluginName") {
    throw ".agents/plugins/marketplace.json must list $pluginName at ./plugins/$pluginName."
}

# Constructs that only Claude Code understands; each must have been adapted.
$claudeOnlyConstructs = @('$ARGUMENTS', 'AskUserQuestion', 'disable-model-invocation', 'argument-hint', '/crow:')

$skillFiles = Get-ChildItem -Path (Join-Path $pluginRoot 'skills/*/SKILL.md') -File
if ($skillFiles.Count -eq 0) {
    throw "At least one skill is required in $pluginRoot/skills/<name>/SKILL.md."
}

$installationPolicyPath = '.github/installation-policy.md'
if (-not (Test-Path -LiteralPath $installationPolicyPath -PathType Leaf)) {
    throw "$installationPolicyPath is required."
}
$installationPolicy = (Read-Text $installationPolicyPath).TrimEnd("`n")
foreach ($policyConsumer in @(
    (Join-Path $pluginRoot 'skills/develop/SKILL.md'),
    (Join-Path $pluginRoot 'skills/build/SKILL.md')
)) {
    if (-not (Read-Text $policyConsumer).Contains($installationPolicy)) {
        throw "$policyConsumer must contain $installationPolicyPath word-for-word."
    }
}

# The retired repository name is historical only. It may appear in migration
# notes and review evidence, never as the active marketplace or install target.
$retiredRepositoryName = 'rm-skill-codex'
$retiredNameHistoryFiles = @(
    '.github/scripts/package-plugin.ps1',
    'docs/requirements/revisao-fase-0-codex.md',
    'docs/requirements/revisao-fase-0-codex-traceability.md',
    'docs/testing.md'
)
foreach ($trackedFile in (& git ls-files)) {
    $normalizedPath = $trackedFile -replace '\\', '/'
    if ($retiredNameHistoryFiles -contains $normalizedPath) {
        continue
    }

    $lines = @(Get-Content -Encoding UTF8 -LiteralPath $trackedFile)
    $insideMigrationSection = $false
    for ($lineIndex = 0; $lineIndex -lt $lines.Count; $lineIndex++) {
        $line = $lines[$lineIndex]
        if ($normalizedPath -eq 'README.md' -and $line -match '^#{1,6}\s+(.+)$') {
            $insideMigrationSection = $Matches[1].StartsWith('Vindo do')
        }
        if ($line.Contains($retiredRepositoryName) -and
            -not ($normalizedPath -eq 'README.md' -and $insideMigrationSection)) {
            throw "$normalizedPath`:$($lineIndex + 1) uses retired name $retiredRepositoryName outside migration history."
        }
    }
}

foreach ($skillFile in $skillFiles) {
    $skillDirectory = $skillFile.Directory
    $text = Read-Text $skillFile.FullName

    if ($text -notmatch '^---\n') {
        throw "$($skillFile.FullName) must start with YAML frontmatter."
    }
    $skillName = ([regex]::Match($text, '(?m)^name:\s*(\S+)')).Groups[1].Value
    # A skill whose name differs from its folder fails to load without any error.
    if ($skillName -ne $skillDirectory.Name) {
        throw "$($skillFile.FullName) must declare name: $($skillDirectory.Name)."
    }
    if (-not $text.Contains('## Non-negotiable rules')) {
        throw "$($skillFile.FullName) must carry the non-negotiable rules block."
    }
    if (-not (Test-Path -LiteralPath (Join-Path $skillDirectory.FullName 'agents/openai.yaml') -PathType Leaf)) {
        throw "$($skillDirectory.Name) must have agents/openai.yaml."
    }

    foreach ($file in Get-ChildItem -LiteralPath $skillDirectory.FullName -Recurse -File) {
        $content = Read-Text $file.FullName
        foreach ($construct in $claudeOnlyConstructs) {
            if ($content.Contains($construct)) {
                throw "$($file.FullName) still contains $construct, which Codex does not understand."
            }
        }
    }
}

foreach ($requiredFile in @('README.md', 'LICENSE', 'VERSION')) {
    if (-not (Test-Path -LiteralPath $requiredFile -PathType Leaf)) {
        throw "$requiredFile is required in the release package."
    }
}

$outputDirectory = Join-Path $repositoryRoot 'dist'
$packageDirectory = Join-Path $outputDirectory $marketplaceName
$archiveName = "$pluginName-v$version.zip"
$archivePath = Join-Path $outputDirectory $archiveName

if (Test-Path -LiteralPath $outputDirectory) {
    Remove-Item -LiteralPath $outputDirectory -Recurse -Force
}
New-Item -ItemType Directory -Path $packageDirectory | Out-Null

Copy-Item -LiteralPath 'README.md', 'LICENSE', 'VERSION' -Destination $packageDirectory
Copy-Item -LiteralPath '.agents', 'plugins', 'assets' -Destination $packageDirectory -Recurse -Force
New-Item -ItemType Directory -Path (Join-Path $packageDirectory '.github') | Out-Null
Copy-Item -LiteralPath $installationPolicyPath -Destination (Join-Path $packageDirectory '.github')

# Compress-Archive skips dot-directories on Linux, which would drop .agents and .codex-plugin.
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($packageDirectory, $archivePath, 'Optimal', $true)

$requiredEntries = @(
    "$marketplaceName/.agents/plugins/marketplace.json",
    "$marketplaceName/.github/installation-policy.md",
    "$marketplaceName/plugins/$pluginName/.codex-plugin/plugin.json"
)
$archive = [System.IO.Compression.ZipFile]::OpenRead($archivePath)
try {
    $entryNames = $archive.Entries | ForEach-Object { $_.FullName -replace '\\', '/' }
} finally {
    $archive.Dispose()
}
foreach ($requiredEntry in $requiredEntries) {
    if ($entryNames -notcontains $requiredEntry) {
        throw "$archiveName is missing $requiredEntry."
    }
}
$checksum = (Get-FileHash -LiteralPath $archivePath -Algorithm SHA256).Hash.ToLowerInvariant()
$checksumPath = "$archivePath.sha256"
Set-Content -LiteralPath $checksumPath -Value "$checksum  $archiveName" -Encoding ascii

Write-Output "Created $archivePath"
Write-Output "Created $checksumPath"
