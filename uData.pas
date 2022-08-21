unit uData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmData = class(TDataModule)
    connection: TADOConnection;
    qPessoas: TADOQuery;
    qEndereco: TADOQuery;
    dsPessoas: TDataSource;
    dsEnderecos: TDataSource;
    dstPessoas: TDataSource;
    qqPessoas: TADOQuery;
    dsqEndereco: TDataSource;
    qqEndereco: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmData: TdmData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

end.
