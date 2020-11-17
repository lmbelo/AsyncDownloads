unit Download.Manager;

interface

uses
  Download.Files, Api.Download, Api.Client, System.Threading, System.Classes,
  System.Generics.Collections, Download, Download.Subscriber;

type
  TAttachObserver = reference to procedure(const ASubject: ISubject<TDownloadNotification>);

  TDownloadManager = class(TInterfacedObject)
  private
    FDownloads: TDictionary<TDownloadToken, IDownload>;

    procedure AddDownload(const AToken: TDownloadToken; const ADownload: IDownload);
    procedure RemoveDownload(const AToken: TDownloadToken);
  public
    constructor Create();
    destructor Destroy(); override;

    function StartDownload(const AUrl: string; const AAttachObserver: TAttachObserver): IDownload;
    procedure InterruptDownload(const AToken: TDownloadToken);
    function InterruptAll(): IFuture<boolean>;
    function HasPendingDownload(): boolean;
  end;

implementation

uses
  System.SysUtils;

{ TDownloadManager }

constructor TDownloadManager.Create;
begin
  FDownloads := TDictionary<TDownloadToken, IDownload>.Create();
end;

destructor TDownloadManager.Destroy;
begin
  FDownloads.Free();
  inherited;
end;

procedure TDownloadManager.AddDownload(const AToken: TDownloadToken;
  const ADownload: IDownload);
begin
  TMonitor.Enter(FDownloads);
  try
    FDownloads.Add(AToken, ADownload);
  finally
    TMonitor.Exit(FDownloads);
  end;
end;

procedure TDownloadManager.RemoveDownload(const AToken: TDownloadToken);
begin
  TMonitor.Enter(FDownloads);
  try
    FDownloads.Remove(AToken);
  finally
    TMonitor.Exit(FDownloads);
  end;
end;

function TDownloadManager.StartDownload(const AUrl: string;
  const AAttachObserver: TAttachObserver): IDownload;
var
  LDownload: IDownload;
  LSubject: ISubject<TDownloadNotification>;
begin
  //Não criar dentro da execução da tarefa,
  //logo que a tarefa pode começar após o retorno do método
  //Uma consulta ao manager através do identifier poderia não encontrar nada
  LDownload := TDownload.Create();
  AddDownload(LDownload.Token, LDownload);

  //Evita que o download comece e termine antes do observer ser registrado
  if Assigned(AAttachObserver) then begin
    if Supports(LDownload, ISubject<TDownloadNotification>, LSubject) then
      AAttachObserver(LSubject);
  end;

  var LTask := TTask.Create(procedure() begin
    try
      LDownload.Download(AUrl, Now());
    finally
      RemoveDownload(LDownload.Token);
    end;
  end);
  LTask.Start();

  Result := LDownload;
end;

function TDownloadManager.HasPendingDownload: boolean;
var
  LIdentifier: TDownloadToken;
begin
  TMonitor.Enter(FDownloads);
  try
    for LIdentifier in FDownloads.Keys do begin
      if (FDownloads.Items[LIdentifier].Status in PENDING_STATUS) then begin
        Result := true;
        Exit;
      end;
    end;
  finally
    TMonitor.Exit(FDownloads);
  end;
  Result := false;
end;

function TDownloadManager.InterruptAll: IFuture<boolean>;
var
  LIdentifier: TDownloadToken;
begin
  TMonitor.Enter(FDownloads);
  try
    for LIdentifier in FDownloads.Keys do begin
      if (FDownloads.Items[LIdentifier].Status in PENDING_STATUS) then begin
        FDownloads.Items[LIdentifier].Interrupt();
      end;
    end;
  finally
    TMonitor.Exit(FDownloads);
  end;

  Result := TTask.Future<boolean>(function(): boolean begin
    while HasPendingDownload() do begin
      Sleep(100);
    end;
    Result := true;
  end);
end;

procedure TDownloadManager.InterruptDownload(
  const AToken: TDownloadToken);
var
  LDownload: IDownload;
begin
  TMonitor.Enter(FDownloads);
  try
    if FDownloads.TryGetValue(AToken, LDownload) then begin
      LDownload.Interrupt();
    end;
  finally
    TMonitor.Exit(FDownloads);
  end;
end;

end.
