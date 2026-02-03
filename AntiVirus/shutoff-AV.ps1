Set-MpPreference -DisableRealtimeMonitoring $true


Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableIOAVProtection $true (scans all downloaded files and attachments)
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -EnableControlledFolderAccess Disabled
Set-MpPreference -SubmitSamplesConsent NeverSend (stops automatic sample submission)
Set-MpPreference -MAPSReporting Disable (stops cloud-based protection reporting) 
