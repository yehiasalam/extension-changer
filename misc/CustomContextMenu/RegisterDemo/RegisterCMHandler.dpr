program RegisterCMHandler;

uses
  Forms,
  RegisterCM in 'RegisterCM.pas' {Form1},
  CustomContextMenu in '..\CustomContextMenu.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Register Context Menu Handler';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
 