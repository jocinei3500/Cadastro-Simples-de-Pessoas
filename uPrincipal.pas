unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Data.Win.ADODB, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls;

type
  TfrmPrincipal = class(TForm)
    edNome: TEdit;
    edRG: TEdit;
    edCPF: TEdit;
    edNomeMae: TEdit;
    edNomePai: TEdit;
    lbNome: TLabel;
    lbCPG: TLabel;
    lbRG: TLabel;
    lbNomeMae: TLabel;
    lbNomePai: TLabel;
    GroupBox1: TGroupBox;
    btNovo: TBitBtn;
    btCadEdit: TBitBtn;
    btExcluir: TBitBtn;
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Pessoas1: TMenuItem;
    Endereos1: TMenuItem;
    dbgDados: TDBGrid;
    edCEP: TEdit;
    Label1: TLabel;
    mCEP: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    edID: TEdit;
    procedure Endereos1Click(Sender: TObject);
    procedure btCadEditClick(Sender: TObject);
    procedure edCEPExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgDadosDblClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure cadEdit();
    procedure carregaPessoas();
    procedure buscaCEP();
    procedure visualizaDados();
    procedure limpaCampos();
    procedure Excluir();
    function verificaCampos: boolean;
  public
    { Public declarations }
    function verificaCEP(_Cep: string): boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses uCadEndereco, uData, ConsultaCEP, ViaCEP.Intf, ViaCEP.Core, ViaCEP.Model;

{$R *.dfm}

procedure TfrmPrincipal.btCadEditClick(Sender: TObject);
begin
  cadEdit();
end;

procedure TfrmPrincipal.btExcluirClick(Sender: TObject);
begin
  Excluir;
end;

procedure TfrmPrincipal.btNovoClick(Sender: TObject);
begin
  limpaCampos;
end;

procedure TfrmPrincipal.buscaCEP();
var
  ViaCEP: IViaCEP;
  CEP: TViaCEPClass;
begin
  ViaCEP := TViaCEP.Create;
  if (not(ViaCEP.Validate(edCEP.Text))) then
  begin
    showmessage('CEP inválido!');
    exit;
  end;

  CEP := ViaCEP.Get(edCEP.Text);
  if not Assigned(CEP) then
    exit;
  if CEP.Localidade = '' then
  begin
    showmessage('CEP Não encontrado');
    exit;
  end;
  try
    mCEP.Lines.Add(CEP.Logradouro + ' - ' + CEP.Bairro);
    mCEP.Lines.Add(CEP.Localidade + ' - ' + CEP.UF);

    if trim(mCEP.Text) = '' then
    begin
      showmessage('CEP não encontrado');
      mCEP.Clear;
      edCEP.SetFocus;
    end;

  finally
    CEP.Free;
  end;

end;

procedure TfrmPrincipal.cadEdit;
var
  id, nome, cpf, rg, nomeMae, nomePai, CEP, sql: string;
begin
  if verificaCampos = false then
    exit;
  id := edID.Text;
  nome := edNome.Text;
  cpf := edCPF.Text;
  rg := edRG.Text;
  nomeMae := edNomeMae.Text;
  nomePai := edNomePai.Text;
  CEP := edCEP.Text;
  if btCadEdit.Caption = 'Cadastrar' then
  begin
    sql := 'INSERT INTO PESSOAS(NOME, CPF, RG, NOME_MAE, NOME_PAI' +
      ',CEP) VALUES(' + quotedStr(nome) + ',' + quotedStr(cpf) + ',' +
      quotedStr(rg) + ',' + quotedStr(nomeMae) + ',' + quotedStr(nomePai) + ','
      + quotedStr(CEP) + ')';
  end
  else
  begin
    sql := 'UPDATE PESSOAS SET NOME =' + quotedStr(nome) + ', CPF=' +
      quotedStr(cpf) + ',RG=' + quotedStr(rg) + ',NOME_MAE=' +
      quotedStr(nomeMae) + ',NOME_PAI=' + quotedStr(nomePai) + ',CEP=' +
      quotedStr(CEP) + ' WHERE ID =' + id;
  end;

  dmdata.qPessoas.sql.Clear;
  dmdata.qPessoas.sql.Add(sql);
  dmdata.qPessoas.ExecSQL;
  carregaPessoas();

end;

procedure TfrmPrincipal.carregaPessoas;
begin
  dmdata.qqPessoas.close;
  dmdata.qqPessoas.sql.Clear;
  dmdata.qqPessoas.sql.Add('SELECT * FROM PESSOAS');
  dmdata.qqPessoas.open;

end;

procedure TfrmPrincipal.dbgDadosDblClick(Sender: TObject);
begin
  visualizaDados;
end;

procedure TfrmPrincipal.edCEPExit(Sender: TObject);
begin
  buscaCEP;
end;

procedure TfrmPrincipal.Endereos1Click(Sender: TObject);
begin
  frmCadEndereco.Show;
end;

procedure TfrmPrincipal.Excluir;
var
  sql, id: string;
begin
  id := edID.Text;
  sql := 'DELETE FROM PESSOAS WHERE ID=' + id;
  dmdata.qPessoas.sql.Clear;
  dmdata.qPessoas.sql.Add(sql);
  dmdata.qPessoas.ExecSQL;
  limpaCampos;
  carregaPessoas;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  carregaPessoas;
end;

procedure TfrmPrincipal.limpaCampos;
begin
  edID.Clear;
  edNome.Clear;
  edCPF.Clear;
  edRG.Clear;
  edNomeMae.Clear;
  edNomePai.Clear;
  edCEP.Clear;
  mCEP.Clear;
  btCadEdit.Caption := 'Cadastrar';
  btExcluir.Enabled := false;
  edNome.SetFocus;
end;

function TfrmPrincipal.verificaCampos: boolean;
begin

  result := false;
  if edNome.Text = '' then
  begin
    showmessage('Informe o Nome!');
    edNome.SetFocus;
    exit;
  end;

  if edCPF.Text = '' then
  begin
    showmessage('Informe o CPF!');
    edCPF.SetFocus;
    exit;
  end;

  if edRG.Text = '' then
  begin
    showmessage('Informe o RG!');
    edRG.SetFocus;
    exit;
  end;

  if edNomeMae.Text = '' then
  begin
    showmessage('Informe o nome da mãe');
    edNomeMae.SetFocus;
    exit;
  end;

  if edNomePai.Text = '' then
  begin
    showmessage('Informe o nome do pai!');
    edNomePai.SetFocus;
    exit;
  end;

  if edCEP.Text = '' then
  begin
    showmessage('Informe o CEP');
    edCEP.SetFocus;
    exit;
  end;

  result := true;
end;

function TfrmPrincipal.verificaCEP(_Cep: string): boolean;
var
  ViaCEP: IViaCEP;
  CEP: TViaCEPClass;
begin
  result := true;
  ViaCEP := TViaCEP.Create;
  if (not(ViaCEP.Validate(_Cep))) then
  begin
    showmessage('CEP inválido!');
    result := false;
    exit;
  end;

  CEP := ViaCEP.Get(_Cep);
  if not Assigned(CEP) then
  begin
    result := false;
    exit;
  end;

  if CEP.Localidade = '' then
  begin
    showmessage('CEP Não encontrado');
    result:=false;
    exit;
  end;

  result:=true;

end;

procedure TfrmPrincipal.visualizaDados;
begin
  edID.Text := dbgDados.Fields[0].Text;
  edNome.Text := dbgDados.Fields[1].Text;
  edCPF.Text := dbgDados.Fields[2].Text;
  edRG.Text := dbgDados.Fields[3].Text;
  edNomeMae.Text := dbgDados.Fields[5].Text;
  edNomePai.Text := dbgDados.Fields[4].Text;
  edCEP.Text := dbgDados.Fields[6].Text;
  buscaCEP;
  btExcluir.Enabled := true;
  btCadEdit.Caption := 'Atualizar';

end;

end.
