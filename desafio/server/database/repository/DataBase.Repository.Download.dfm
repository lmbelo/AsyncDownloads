inherited DownloadRepository: TDownloadRepository
  OldCreateOrder = True
  inherited SQLQuery: TFDQuery
    SQL.Strings = (
      'SELECT * FROM LOGDOWNLOAD')
  end
end
