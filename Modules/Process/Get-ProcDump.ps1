﻿# OUTPUT bin
# BINDEP .\Modules\bin\Procdump.exe
<#
.SYNOPSIS
Get-ProcDump.ps1 acquires a Sysinternal procdump of the specified 
process
.PARAMETER ProcId
A required parameter, the process id of the process you want to dump.
.NOTES
When used with Kansa.ps1, parameters must be positional. Named params
are not supported.
.EXAMPLE
Get-ProcDump.ps1 104

When passing specific modules with parameters via Kansa.ps1's
-ModulePath parameter, be sure to quote the entire string, like 
shown here:
.\kansa.ps1 -Target localhost -ModulePath ".\Modules\Process\Get-ProcDumpe.ps1 104"

If you have procdump.exe in your Modules\bin\ path and run Kansa with 
the -Pushbin flag, Kansa will attempt to copy the binary to the ADMIN$.
Binaries are not removed, so subsequent runs won't require -Pushbin.

Also, you should configure this to dump the process you're interested
in. By default it dumps itself, which is probably not what you want.
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$False,Position=0)]
        [Int]$ProcId=$pid
)

if (Test-Path "$env:SystemRoot\Procdump.exe") {
    $PDOutput = & $env:SystemRoot\Procdump.exe /accepteula $ProcId 2> $null
    foreach($line in $PDOutput) {
        if ($line -match 'Writing dump file (.*\.dmp) ...') {
            Get-Content -ReadCount 0 -Raw -Encoding Byte $($matches[1])
            Remove-Item $($matches[1])
        }
    }
}