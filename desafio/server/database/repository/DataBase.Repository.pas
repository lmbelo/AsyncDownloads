unit DataBase.Repository;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.Option,
  FireDAC.VCLUI.Wait, FireDAC.ConsoleUI.Wait;

type
  TRepository = class(TDataModule)
    SQLConn: TFDConnection;
    SQLQuery: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  end;

var
  Repository: TRepository;

implementation

uses
  DataBase.SQLite.ConnectionDefinition;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TRepository.DataModuleCreate(Sender: TObject);
begin
  //Evita deadlocks entre transações
  SQLConn.TxOptions.Isolation := TFDTxIsolation.xiSerializible;

  //Obtem uma conexão do pool
  SQLConn.ConnectionDefName := TConnectionDefinition.CONNECTION_DEF_NAME_SQL_LITE;
end;

end.
