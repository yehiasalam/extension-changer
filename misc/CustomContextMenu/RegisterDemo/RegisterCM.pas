unit RegisterCM;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  ShlObj, ExtCtrls, CustomContextMenu, ComObj;

type
  TForm1 = class(TForm)
    BtnRegHandler: TButton;
    BtnUnregHandler: TButton;
    BtnExit: TButton;
    LblPath: TLabel;
    TxtPath: TEdit;
    LblDescription: TLabel;
    TxtDescription: TEdit;
    LblNote: TLabel;
    LblGuid: TLabel;
    TxtGuid: TEdit;
    LblFileType: TLabel;
    TxtFileType: TEdit;
    BtnRegFileType: TButton;
    BtnUnregFileType: TButton;
    LblName: TLabel;
    TxtName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnRegHandlerClick(Sender: TObject);
    procedure BtnUnregHandlerClick(Sender: TObject);
    procedure BtnRegFileTypeClick(Sender: TObject);
    procedure BtnUnregFileTypeClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
  private
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  SysDir: array[0..MAX_PATH] of Char;
begin
  if GetSystemDirectory(@SysDir, MAX_PATH) <> 0 then
    TxtPath.Text := PChar(@SysDir) + '\ShellExt\' + TxtPath.Text;
end;


procedure TForm1.BtnRegHandlerClick(Sender: TObject);
var
  CLSID: TGUID;
begin
  try
    CLSID := StringToGUID(TxtGuid.Text);
    if FileExists(TxtPath.Text) then
    begin
      RegisterHandler(CLSID, TxtPath.Text, TxtDescription.Text);
      MessageDlg('Handler has been registered.', mtInformation, [mbOk], 0);
    end
    else
      MessageDlg('File not found.', mtError, [mbOk], 0);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
end;


procedure TForm1.BtnUnregHandlerClick(Sender: TObject);
var
  CLSID: TGUID;
begin
  try
    CLSID := StringToGUID(TxtGuid.Text);
    UnregisterHandler(CLSID);
    MessageDlg('Handler has been unregistered.', mtInformation, [mbOk], 0);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
end;


procedure TForm1.BtnRegFileTypeClick(Sender: TObject);
var
  CLSID: TGUID;
begin
  try
    CLSID := StringToGUID(TxtGuid.Text);
    RegisterFileType(CLSID, TxtFileType.Text, TxtName.Text);
    MessageDlg('Handler has been associated with files of type ''' + TxtFileType.Text + '''.',
               mtInformation, [mbOk], 0);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
end;


procedure TForm1.BtnUnregFileTypeClick(Sender: TObject);
var
  CLSID: TGUID;
begin
  try
    CLSID := StringToGUID(TxtGuid.Text);
    UnregisterFileType(CLSID, TxtFileType.Text, TxtName.Text);
    MessageDlg('Handler has been unassociated from files of type ''' + TxtFileType.Text + '''.',
               mtInformation, [mbOk], 0);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOk], 0);
  end;
end;


procedure TForm1.BtnExitClick(Sender: TObject);
begin
  Close;
end;

end.

