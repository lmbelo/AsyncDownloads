object Repository: TRepository
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 172
  Width = 326
  object SQLConn: TFDConnection
    TxOptions.Isolation = xiSerializible
    Left = 152
    Top = 16
  end
  object SQLQuery: TFDQuery
    Connection = SQLConn
    Left = 152
    Top = 72
  end
end
