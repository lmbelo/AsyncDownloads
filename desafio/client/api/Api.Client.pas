unit Api.Client;

interface

uses
  System.SysUtils, System.Classes, Api.Download, Datasnap.DSClientRest;

type
  TDataSnapClientModule = class(TDataModule)
    DSRestConnection1: TDSRestConnection;
  private
    FInstanceOwner: Boolean;
    FDownloadServerModuleClient: TDownloadServerModuleClient;
    function GetDownloadServerModuleClient: TDownloadServerModuleClient;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property InstanceOwner: Boolean read FInstanceOwner write FInstanceOwner;
    property DownloadServerModuleClient: TDownloadServerModuleClient read GetDownloadServerModuleClient write FDownloadServerModuleClient;
end;

var
  DataSnapClientModule: TDataSnapClientModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

constructor TDataSnapClientModule.Create(AOwner: TComponent);
begin
  inherited;
  FInstanceOwner := True;
end;

destructor TDataSnapClientModule.Destroy;
begin
  FDownloadServerModuleClient.Free;
  inherited;
end;

function TDataSnapClientModule.GetDownloadServerModuleClient: TDownloadServerModuleClient;
begin
  if FDownloadServerModuleClient = nil then
    FDownloadServerModuleClient:= TDownloadServerModuleClient.Create(DSRestConnection1, FInstanceOwner);
  Result := FDownloadServerModuleClient;
end;

end.
