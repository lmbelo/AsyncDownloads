unit Model.Download;

interface

type
  TDownloadModel = class
  private
    FId: integer;
    FUrl: string;
    FDtFim: TDateTime;
    FDtInicio: TDateTime;
  public
    constructor Create(); overload;
    constructor Create(const AId: integer; const AUrl: string; const ADtInicio: TDateTime); overload;
    constructor Create(const AId: integer; const AUrl: string; const ADtInicio, ADtFim: TDateTime); overload;

    property Id: integer read FId write FId;
    property Url: string read FUrl write FUrl;
    property DtInicio: TDateTime read FDtInicio write FDtInicio;
    property DtFim: TDateTime read FDtFim write FDtFim;
  end;

implementation

uses
  System.SysUtils;

{ TDownloadModel }

constructor TDownloadModel.Create(const AId: integer; const AUrl: string;
  const ADtInicio, ADtFim: TDateTime);
begin
  FId := AId;
  FUrl := AUrl;
  FDtInicio := ADtInicio;
  FDtFim := ADtFim;
end;

constructor TDownloadModel.Create(const AId: integer; const AUrl: string;
  const ADtInicio: TDateTime);
begin
  Create(AId, AUrl, ADtInicio, MinDateTime);
end;

constructor TDownloadModel.Create;
begin
  Create(0, EmptyStr, MinDateTime, MinDateTime);
end;

end.
