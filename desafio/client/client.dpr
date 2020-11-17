program client;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {DownloadForm},
  Download.Files in 'download\Download.Files.pas' {DownloadFiles: TDataModule},
  Download.List in 'download\Download.List.pas' {DownloadList: TDataModule},
  Download.HistoricoDownloads in 'download\Download.HistoricoDownloads.pas' {HistoricoDownload},
  Download.Manager in 'download\Download.Manager.pas',
  Api.Download in 'api\Api.Download.pas',
  Api.Client in 'api\Api.Client.pas' {DataSnapClientModule: TDataModule},
  Download.Subscriber in 'download\Download.Subscriber.pas',
  Download in 'download\Download.pas',
  Model.Download in 'model\Model.Download.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.CreateForm(TDownloadForm, DownloadForm);
  Application.Run;
end.
