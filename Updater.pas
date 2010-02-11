unit Updater;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Urlmon ,ExtCtrls,IniFiles,shellapi;

type
  TForm2 = class(TForm)
    TxtInfo: TMemo;
    CmdCheck: TButton;
    BevDownload: TBevel;
    Lbldownload: TLabel;
    procedure CmdCheckClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LbldownloadClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses unit1;
{$R *.dfm}

procedure TForm2.CmdCheckClick(Sender: TObject);
var ln1,ln2,fPath : String;
    ini: TiniFile ;
begin

if cmdcheck.Caption = 'Close' then begin
  self.Close;
  exit;
end;

fpath:=ExtractFilePath(Application.ExeName)+ 'updates.ini';
txtinfo.Text:= 'Checking for newer version...'                 ;
URLDownloadToFile(nil, vpath,pchar(Fpath), 0, nil);

if fileexists(fpath) = true then begin
   ini := TiniFile.Create(fPath);
   Ln1 := ini.ReadString('ExtensionChanger','Version','');
   Ln2 := ini.ReadString('ExtensionChanger','Description','') ;
   ini.Free;
   deletefile(fpath);
   if ln1 = vnumber then begin
      txtinfo.Text:= 'No updates were found, You have already the latest version.';
      bevdownload.Visible:= false; lbldownload.Visible:= false;
      end
   else begin
       txtinfo.text:=ln2;
       bevdownload.Visible:=true; lbldownload.Visible:=true;
   end;
   cmdcheck.Caption := 'Close';
  end
else begin
txtinfo.Text:= 'Error: The update file was not found on the server,' + #13#10
             + 'Try checking manually http://www.yehiaeg.com for updates';
end;


end;


procedure TForm2.FormShow(Sender: TObject);
begin
cmdcheck.Caption := 'Check';
lbldownload.Hide;bevdownload.Hide;
txtinfo.Lines.Text := 'Click the button to Check for the latest version...' + #13#10#13#10 +
                      'The Application will connect to a web server , make sure that you have an active internet connection.';

end;

procedure TForm2.LbldownloadClick(Sender: TObject);
begin
ShellExecute( self.Handle,'open', pchar(lbldownload.Caption), nil, nil,0);
end;

end.
