object DownloadFiles: TDownloadFiles
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 122
  Width = 305
  object NetHTTPRequest1: TNetHTTPRequest
    Client = NetHTTPClient1
    OnRequestCompleted = NetHTTPRequest1RequestCompleted
    OnRequestError = NetHTTPRequest1RequestError
    OnReceiveData = NetHTTPRequest1ReceiveData
    Left = 136
    Top = 32
  end
  object NetHTTPClient1: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 216
    Top = 32
  end
end
