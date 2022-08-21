unit uCadEndereco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons;

type
  TfrmCadEndereco = class(TForm)
    lbCEP: TLabel;
    lbEndereco: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edCEP: TEdit;
    edEndereco: TEdit;
    edNum: TEdit;
    edCidade: TEdit;
    edEstado: TEdit;
    GroupBox1: TGroupBox;
    btNovo: TBitBtn;
    btCadEdit: TBitBtn;
    btExcluir: TBitBtn;
    dbgDados: TDBGrid;
    procedure Button1Click(Sender: TObject);
    procedure btCadEditClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgDadosDblClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure cadEdit();
    procedure carregaEnderecos();
    procedure limpaCampos();
    procedure excluir();
    function verificaCampos: boolean;
    procedure visualizaDados();
  public
    { Public declarations }
  end;

var
  frmCadEndereco: TfrmCadEndereco;

implementation

uses uData;

{$R *.dfm}

procedure TfrmCadEndereco.btCadEditClick(Sender: TObject);
begin
  cadEdit();
end;

procedure TfrmCadEndereco.btExcluirClick(Sender: TObject);
begin
  excluir;
end;

procedure TfrmCadEndereco.btNovoClick(Sender: TObject);
begin
  limpaCampos;
end;

procedure TfrmCadEndereco.Button1Click(Sender: TObject);
begin
  dmdata.qEndereco.SQL.Clear;
  dmdata.qEndereco.SQL.Add('SELECT * FROM ENDERECO');
  dmdata.qEndereco.Open;

end;

procedure TfrmCadEndereco.cadEdit;
var
  cep, endereco, num, cidade, estado, SQL: string;
begin
  cep := edCEP.Text;
  endereco := edEndereco.Text;
  num := edNum.Text;
  cidade := edCidade.Text;
  estado := edEstado.Text;
  if btCadEdit.Caption = 'Cadastrar' then
  begin
    SQL := 'INSERT INTO ENDERECOS(CEP, ENDERECO, NUM, CIDADE,ESTADO)' +
      'VALUES(' + quotedStr(cep) + ',' + quotedStr(endereco) + ',' +
      quotedStr(num) + ',' + quotedStr(cidade) + ',' + quotedStr(estado) + ')';
  end
  else
  begin
    SQL := 'UPDATE ENDERECOS SET CEP=' + quotedStr(cep) + ', ENDERECO=' +
      quotedStr(endereco) + ', NUM=' + quotedStr(num) + ',CIDADE=' +
      quotedStr(cidade) + ',ESTADO=' + quotedStr(estado) + 'WHERE CEP=' +
      quotedStr(cep);

  end;
  dmdata.qEndereco.SQL.Clear;
  dmdata.qEndereco.SQL.Add(SQL);
  dmdata.qEndereco.ExecSQL;
  carregaEnderecos();

end;

procedure TfrmCadEndereco.carregaEnderecos;
begin
  dmdata.qqEndereco.close;
  dmdata.qqEndereco.SQL.Clear;
  dmdata.qqEndereco.SQL.Add('SELECT * FROM ENDERECOS');
  dmdata.qqEndereco.Open;

end;

procedure TfrmCadEndereco.dbgDadosDblClick(Sender: TObject);
begin
  visualizaDados;
end;

procedure TfrmCadEndereco.excluir;
  var
    sql, cep:string;
begin
  cep:=edCep.Text;
  sql:='DELETE FROM ENDERECOS WHERE CEP='+ quotedStr(cep);
  dmData.qPessoas.SQL.Clear;
  dmData.qPessoas.SQL.Add(sql);
  dmData.qPessoas.ExecSQL;
  limpaCampos;
  carregaEnderecos;

end;

procedure TfrmCadEndereco.FormShow(Sender: TObject);
begin
  carregaEnderecos;
end;

procedure TfrmCadEndereco.limpaCampos;
begin
  edCEP.Clear;
  edEndereco.Clear;
  edNum.Clear;
  edCidade.Clear;
  edEstado.Clear;
  btCadEdit.Caption := 'Cadastrar';
  btExcluir.Enabled := false;

end;

function TfrmCadEndereco.verificaCampos: boolean;
begin
  result := false;
  if edCEP.Text = '' then
  begin
    Showmessage('Informe o CEP!');
    edCEP.SetFocus;
    exit;
  end;

  if edEndereco.Text = '' then
  begin
    Showmessage('Informe o Endereço!');
    edEndereco.SetFocus;
    exit;
  end;

  if edNum.Text = '' then
  begin
    Showmessage('Informe o Número!');
    edNum.SetFocus;
    exit;
  end;

  if edCidade.Text = '' then
  begin
    Showmessage('Informe a Cidade!');
    edCidade.SetFocus;
    exit;
  end;

  if edEstado.Text = '' then
  begin
    Showmessage('Informe o Estado!');
    edEstado.SetFocus;
    exit;
  end;

  result := true;
end;

procedure TfrmCadEndereco.visualizaDados;
begin
  edCEP.Text := dbgDados.Fields[0].Text;
  edEndereco.Text := dbgDados.Fields[1].Text;
  edNum.Text := dbgDados.Fields[2].Text;
  edCidade.Text := dbgDados.Fields[3].Text;
  edEstado.Text := dbgDados.Fields[4].Text;
  // buscaCEP;
  btExcluir.Enabled := true;
  btCadEdit.Caption := 'Atualizar';
end;

end.
