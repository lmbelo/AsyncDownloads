program server;
{$APPTYPE GUI}



uses
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  DataBase.SQLite.ConnectionDefinition in 'database\sqlite\DataBase.SQLite.ConnectionDefinition.pas',
  DataBase.SQLite.Script in 'database\sqlite\DataBase.SQLite.Script.pas',
  DataBase.SQLite in 'database\sqlite\DataBase.SQLite.pas',
  DataBase.SQLite.Common in 'database\sqlite\DataBase.SQLite.Common.pas',
  DataBase.Repository in 'database\repository\DataBase.Repository.pas' {Repository: TDataModule},
  DataBase.Repository.Download in 'database\repository\DataBase.Repository.Download.pas' {DownloadRepository: TDataModule},
  ServerModule.Download in 'servermodule\ServerModule.Download.pas' {DownloadServerModule: TDSServerModule};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
