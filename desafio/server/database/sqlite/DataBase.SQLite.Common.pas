unit DataBase.SQLite.Common;

interface

uses
  FireDAC.Comp.Client;

type
  ISQLiteScript = interface
    ['{E595C0E0-7ADD-4838-A6E7-92253BDB6E00}']
    procedure Execute(const AConnection: TFDConnection);
  end;

implementation

end.
