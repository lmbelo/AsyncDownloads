unit Download;

interface

uses
  Api.Client, Download.Files, System.SysUtils, System.Classes,
  Download.Subscriber, System.Generics.Collections, Model.Download;

type
  TDownloadToken = string;
  TDownloadStatus = (dsNone, dsStarted, dsDownloading, dsCompleted, dsInterrupted, dsError);

  IDownload = interface
    ['{FB7D2266-0E2E-4C66-829A-017CA19887CB}']
    function GetStatus(): TDownloadStatus;
    function GetToken(): TDownloadToken;
    function GetFatalException(): Exception;

    procedure Download(const AUrl: string; const ADtIni: TDateTime);
    procedure Interrupt();

    property Token: TDownloadToken read GetToken;
    property Status: TDownloadStatus read GetStatus;
    property FatalException: Exception read GetFatalException;
  end;

  TDownloadProgress = class
  private
    FLength: Int64;
    FPercentage: integer;
  public
    constructor Create(const ALength: Int64; const APercentage: Integer);

    property Length: Int64 read FLength write FLength;
    property Percentage: integer read FPercentage write FPercentage;
  end;

  TDownloadNotification = class
  private
    FDownload: IDownload;
    FData: TDownloadModel;
    FProgress: TDOwnloadProgress;
  public
    constructor Create(const ADownload: IDownload);
    destructor Destroy(); override;

    property Download: IDownload read FDownload;
    property Data: TDownloadModel read FData;
    property Progress: TDownloadProgress read FProgress write FProgress;
  end;

  TDownload = class(TInterfacedObject, IDownload, ISubject<TDownloadNotification>)
  private
    FSubject: ISubject<TDownloadNotification>;
    FApiClient: TDataSnapClientModule;
    FDownloader: TDownloadFiles;
    FToken: TDownloadToken;
    FStatus: TDownloadStatus;
    FFatalException: Exception;
    FNotification: TDownloadNotification;
    function GetStatus(): TDownloadStatus;
    function GetToken(): TDownloadToken;
    function GetFatalException(): Exception;
    procedure ChangeStatus(const AStatus: TDownloadStatus);
    procedure DoDownload(const Aurl: string; const ADtIni: TDateTime);
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Download(const AUrl: string; const ADtIni: TDateTime);
    procedure Interrupt();
    property Status: TDownloadStatus read FStatus write FStatus;
    property Subject: ISubject<TDownloadNotification> read FSubject implements ISubject<TDownloadNotification>; //Delegates
  end;

const
  PENDING_STATUS: set of TDownloadStatus = [TDownloadStatus.dsStarted,
                                            TDownloadStatus.dsDownloading];

implementation

{ TDownload }

procedure TDownload.ChangeStatus(const AStatus: TDownloadStatus);
begin
  FStatus := AStatus;
end;

constructor TDownload.Create;
var
  LToken: TGUID;
begin
  CreateGUID(LToken);
  FToken := GUIDToString(LToken);
  FStatus := TDownloadStatus.dsNone;
  FSubject := TObservable<TDownloadNotification>.Create();
  FApiClient := TDataSnapClientModule.Create(nil);
  FDownloader := TDownloadFiles.Create(nil)
end;

destructor TDownload.Destroy;
begin
  FDownloader.Free();
  FApiClient.Free();
  inherited;
end;

procedure TDownload.DoDownload(const Aurl: string; const ADtIni: TDateTime);
begin
  var LApiDownload := FApiClient.DownloadServerModuleClient;
  var LId := LApiDownload.Download(AUrl, ADtIni);

  var LData := FNotification.Data;
  var LProgress := FNotification.Progress;
  LData.Id := LId;

  ChangeStatus(TDownloadStatus.dsStarted);
  try
    FSubject.NotifyObservers(FNotification);
  finally
    FDownloader.GetFile(AUrl,
      procedure(const ALength: Int64; const APercentage: Integer; const AIsInterrupted: boolean = true; const AErrorMessage: string = '') begin
        if AIsInterrupted then begin
          LData.DtFim := Now();
          ChangeStatus(TDownloadStatus.dsInterrupted);
        end else if (AErrorMessage <> EmptyStr) then begin
          LData.DtFim := Now();
          ChangeStatus(TDownloadStatus.dsError);
        end else begin
          if (FStatus <> TDownloadStatus.dsDownloading) then
            ChangeStatus(TDownloadStatus.dsDownloading);
        end;
        LProgress.Length := ALength;
        LProgress.Percentage := APercentage;
        FSubject.NotifyObservers(FNotification);
      end);

    try
      LApiDownload.StopDownload(LId, LData.DtFim);
    finally
      if (FStatus = TDownloadStatus.dsDownloading) then begin
        LData.DtFim := Now();
        ChangeStatus(TDownloadStatus.dsCompleted);
        FSubject.NotifyObservers(FNotification);
      end;
    end;
  end;
end;

procedure TDownload.Download(const AUrl: string; const ADtIni: TDateTime);
begin
  FNotification := TDownloadNotification.Create(Self);
  try
    try      
      var LData := FNotification.Data;
      LData.Url := AUrl;
      LData.DtInicio := ADtIni;
      DoDownload(AUrl, ADtIni);
    except
      on E: Exception do begin
        ChangeStatus(TDownloadStatus.dsError);
        FFatalException := E;
        FSubject.NotifyObservers(FNotification);
      end;
    end;
  finally
    FreeAndNil(FNotification);
  end;
end;

function TDownload.GetToken: TDownloadToken;
begin
  Result := FToken;
end;

function TDownload.GetFatalException: Exception;
begin
  Result := FFatalException;
end;

function TDownload.GetStatus: TDownloadStatus;
begin
  Result := FStatus;
end;

procedure TDownload.Interrupt;
begin
  if not (FStatus = TDownloadStatus.dsCompleted) then begin
    FDownloader.Interrupted := true;
  end;
end;

{ TDownload.TDownloadProgress }

constructor TDownloadProgress.Create(const ALength: Int64;
  const APercentage: Integer);
begin
  Length := ALength;
  Percentage := APercentage;
end;

{ TDownloadNotification }

constructor TDownloadNotification.Create(const ADownload: IDownload);
begin
  FDownload := ADownload;
  FData := TDownloadModel.Create();
  FProgress := TDownloadProgress.Create(0, 0);
end;

destructor TDownloadNotification.Destroy();
begin
  FProgress.Free();
  FData.Free();
end;


end.
