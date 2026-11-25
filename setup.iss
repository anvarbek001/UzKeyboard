; O'zbek klaviatura - Inno Setup o'rnatish skripti

[Setup]
AppId={{B7E4C2A1-3D5F-4A8B-9E6C-1F2D3A4B5C6D}
AppName=O'zbek klaviatura
AppVersion=1.0
AppPublisher=UzKeyboard
DefaultDirName={localappdata}\UzKeyboard
DefaultGroupName=O'zbek klaviatura
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=output
OutputBaseFilename=UzKeyboard-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayName=O'zbek klaviatura
UninstallDisplayIcon={app}\UzKeyboard.exe
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "dist\UzKeyboard.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\O'zbek klaviatura"; Filename: "{app}\UzKeyboard.exe"
Name: "{group}\O'chirish"; Filename: "{uninstallexe}"

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "UzKeyboard"; ValueData: """{app}\UzKeyboard.exe"""; Flags: uninsdeletevalue

[Run]
Filename: "{app}\UzKeyboard.exe"; Description: "Dasturni hozir ishga tushirish"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im UzKeyboard.exe"; Flags: runhidden; RunOnceId: "KillUzKeyboard"
