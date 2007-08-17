[Setup]
AppId=CManager
AppName=CManager
AppVerName=CManager 1.7.1 Beta
AppPublisherURL=http://cmanager.sourceforge.net
AppSupportURL=http://cmanager.sourceforge.net
AppUpdatesURL=http://cmanager.sourceforge.net
DefaultDirName={pf}\CManager
DefaultGroupName=CManager
AllowNoIcons=true
LicenseFile=..\..\docs\license
OutputDir=..\..\bin
OutputBaseFilename=..\..\releases\CManagerSetup_1_7_1_Beta
SetupIconFile=..\res\cmanager32.ico
Compression=lzma/max
SolidCompression=true
ShowLanguageDialog=auto
LanguageDetectionMethod=locale
WizardImageFile=..\res\install.bmp
UsePreviousAppDir=yes

[Languages]
Name: english; MessagesFile: compiler:Default.isl
Name: polish; MessagesFile: compiler:Languages\Polish.isl

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked

[Types]
Name: "full"; Description: "Pe�na instalacja"
Name: "custom"; Description: "Wybrane elementy"; Flags: iscustom

[Components]
Name: "program"; Description: "Pliki programu"; Types: full custom; Flags: fixed
Name: "plugins"; Description: "Wtyczki do programu"; Types: full
Name: "plugins\mbank"; Description: "Import wyci�g�w z mBanku"; Types: full
Name: "plugins\currency"; Description: "Import kurs�w walut z NBP"; Types: full
Name: "advanced"; Description: "Zaawansowane sk�adniki systuemu"; Types: full
Name: "advanced\psql"; Description: "Konsola Sql"; Types: full

[Files]
Source: ..\..\bin\CManager.exe; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\docs\readme; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\docs\changelog; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\docs\contrib; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\docs\license; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\docs\plugins; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\docs\Help\CManager.chm; DestDir: {app}\Help\; Components: program; Flags: ignoreversion
Source: ..\..\bin\CUpdate.exe; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\bin\CArchive.exe; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\bin\CQuery.exe; DestDir: {app}; Components: program; Flags: ignoreversion
Source: ..\..\bin\Wtyczki\NBPACurrencyRates.dll; DestDir: {app}\Wtyczki\; Components: plugins\currency; Flags: ignoreversion
Source: ..\..\bin\Wtyczki\NBPBSCurrencyRates.dll; DestDir: {app}\Wtyczki\; Components: plugins\currency; Flags: ignoreversion
Source: ..\..\bin\Wtyczki\MbankExtFF.dll; DestDir: {app}\Wtyczki\; Components: plugins\mbank; Flags: ignoreversion
Source: ..\..\bin\Wtyczki\SqlConsole.dll; DestDir: {app}\Wtyczki\; Components: advanced\psql; Flags: ignoreversion
Source: ..\..\sources\res\home.url; DestDir: {app}; Components: program; Flags: ignoreversion

[Icons]
Name: {group}\CManager; Filename: {app}\CManager.exe; WorkingDir: {app}
Name: {group}\{cm:UninstallProgram,CManager}; Filename: {uninstallexe}
Name: {group}\Strona domowa; Filename: {app}\home.url; IconFilename: {app}\CManager.exe
Name: {userdesktop}\CManager; Filename: {app}\CManager.exe; Tasks: desktopicon; WorkingDir: {app}

[Run]
Filename: {app}\CManager.exe; Description: {cm:LaunchProgram,CManager}; Flags: nowait postinstall skipifsilent

[InstallDelete]
Name: {app}\report.css; Type: files
Name: {app}\report.htm; Type: files
Name: {app}\help\index.html; Type: files
Name: {app}\Wtyczki\NBPCurrencyRates.dll; Type: files
