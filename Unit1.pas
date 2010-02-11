unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, registry,ExtCtrls, DdeMan, shellapi,ComCtrls,StrUtils,
  XPMan,inifiles, ImgBtn, Menus;

type
  TForm1 = class(TForm)
    ImgTop: TImage;
    ImgLeft: TImage;
    ImgRight: TImage;
    ImgBottom: TImage;
    TabMain: TImage;
    TabOptions: TImage;
    TabAbout: TImage;
    LblMain: TLabel;
    LblOptions: TLabel;
    LblAbout: TLabel;
    PAbout: TPanel;
    Label2: TLabel;
    LblCopyright: TLabel;
    TabActive: TImage;
    TabUnactive: TImage;
    POptions: TPanel;
    LblInfo2: TLabel;
    ChkOnTop: TCheckBox;
    LblInfo1: TLabel;
    ImgTabEdge: TImage;
    extXp: TXPManifest;
    PMain: TPanel;
    Panel2: TPanel;
    fIcon: TImage;
    LblName: TLabel;
    LblType: TLabel;
    LblTip: TLabel;
    TxtNew: TEdit;
    CmdChange: TButton;
    CmdCancel: TButton;
    ImgClose: TImgBtn;
    ImgTabLeft: TImage;
    ImgTabRight: TImage;
    ImgTabBottom: TImage;
    imgedgeright: TImage;
    imgedgeleft: TImage;
    imgedgetabright: TImage;
    imgedgetableft: TImage;
    popupskins: TPopupMenu;
    lblskins: TLabel;
    imgarrow01: TImgBtn;
    imgarrow02: TImgBtn;
    imgarrow03: TImgBtn;
    procedure lblskinsMouseLeave(Sender: TObject);
    procedure lblskinsMouseEnter(Sender: TObject);
    procedure LblInfo2MouseLeave(Sender: TObject);
    procedure lblskinsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure BeginExt;
    procedure ImgCloseClick(Sender: TObject);
    procedure CmdCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TabOptionsClick(Sender: TObject);
    procedure TabMainClick(Sender: TObject);
    procedure TabAboutClick(Sender: TObject);
    procedure ChkOnTopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LblInfo1MouseEnter(Sender: TObject);
    procedure LblInfo1MouseLeave(Sender: TObject);
    procedure LblInfo2MouseEnter(Sender: TObject);
    procedure LblInfo2Click(Sender: TObject);
    procedure CmdChangeClick(Sender: TObject);
    procedure LblCopyrightMouseEnter(Sender: TObject);
    procedure LblCopyrightMouseLeave(Sender: TObject);
    procedure LblCopyrightClick(Sender: TObject);
    procedure LblInfo1Click(Sender: TObject);
    procedure LoadSkin(re:string);
    procedure GetAvailableSkins() ;
    procedure  popupskinsclick(Sender:TObject);
  private
  public
      procedure AcceptFiles( var msg : TMessage );
      message WM_DROPFILES;
  end;

  function getRGB(Re:String):TColor;

var
  Form1: TForm1;
const vNumber = '0.5' ;
const vPath = 'http://www.yehiaeg.com/extchanger/updates.ini';



implementation
uses Updater,ShlObj;
var  mFiles:TStringList;
     fcTab: array[0..1] of Tcolor;
     cskin:string;


{$R *.dfm}

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: Integer);
begin
if ssLeft in shift then begin
releasecapture;
sendmessage(form1.Handle,WM_NCLBUTTONDOWN,HTCAPTION,0);
end;

end;

function CountMe:string;
var i:integer;
    Re:integer;
begin
Re := 0;
for i := 0 to(mfiles.Count  -1) do
  if not (rightstr(mfiles[i],1)='\') and not (mfiles[i] = '') then inc(re);

Result:= inttostr(re);
end;

procedure WriteContents( const mFolder: String; SubDirectory: Boolean;CurI:integer );
        procedure S4F( Dir: String );
        var
          SearchRec: TSearchRec;
        begin
            //Seach SubDirectory
            if (FindFirst(Dir + '*.*', faAnyFile, SearchRec) = 0) then
            try
              repeat
                    if (SubDirectory = true) and ((SearchRec.Attr and faDirectory) > 0) and (SearchRec.Name <> '.' ) and (SearchRec.Name <> '..') then
                       S4F( Dir + SearchRec.Name + '\')
                       else if searchrec.attr <> 16  then //no a dir
                       mfiles.Add( dir+ searchrec.Name );                 // if dir then >0
              until FindNext( SearchRec ) <> 0
            finally
              FindClose( SearchRec );
            end;

        end;
begin

  S4F( IncludeTrailingPathDelimiter( mFolder ) );
  mfiles.Delete (curi) ;
end;



function InStrRev( Start:Integer; Const BigStr,SmallStr:String):Integer;
var L9, L8, P,BigL, SmallL: Integer; C : Char;
begin
Result := 0; // Set Default
BigL := Length( BigStr ); // Take String Lengths
SmallL := Length( SmallStr );
if Start <= 0 Then Start := BigL;  // 0 Starts from end of String
if Start > BigL Then Start := BigL;
If BigL = 0 Then Exit; // '' Target always returns 0
If SmallL = 0 Then begin // '' Convention returns Start
  Result := Start;
  Exit;
end;
C := SmallStr[1];  // Take First Char of Search String
If (Start + SmallL - 1) > BigL Then Start := BigL - SmallL + 1; // Run back if BigStr not long enough
// Hunt Backwards for a match
  For L9 := Start DownTo 1 Do
      If BigStr[L9] = C Then Begin // If first Char Found
           P := L9 + SmallL - 1;
           For L8 := SmallL DownTo 2 Do Begin// Scan Backwards
                  If BigStr[P] <> SmallStr[L8] Then Break;
                  P := P - 1;
           end;
           // Success - we know first Char matches
           If P = L9 Then Begin
                Result := L9;
                Break;
           end;
      end;

end;{InStrRev}


procedure TForm1.ImgCloseClick(Sender: TObject);
begin
self.close;
end;

procedure TForm1.BeginExt  ;
var
   SH: shfileinfo ;
   Re,ReFinder:Integer;
   ReExt :string;
begin
if mfiles.Count= 1 then begin
        if fileexists(mfiles[0]) then begin
          SHGetFileInfo(pchar(mFiles[0]), 0, sh, sizeof(sh), SHGFI_TYPENAME {Or SHGFI_DISPLAYNAME});
          LblType.caption := sh.szTypeName;
          if  LblType.Caption = '' then  LblType.Caption := 'Unkown File Type';
          ReExt := extractfileext(mfiles[0]);
          LblTip.Caption := 'Change (' + lowercase(rightstr(ReExt,length(ReExt)-1)) + ') To:';

          refinder := instrrev(length(mfiles[0]),mfiles[0],'\')  ;
          lblName.caption:= Rightstr(mFiles[0], Length(mFiles[0]) - reFinder);
          lblname.Hint :=  LblName.Caption ;
          If Length(LblName.Caption ) > 23 Then LblName.Caption  := Leftstr( LblName.Caption , 20) + '...';
          //Show bIcon
          Re := SHGetFileInfo(pchar(mFiles[0]), 0, sh,sizeof(sh),SHGFI_ICON{ SHGFI_SHELLICONSIZE Or SHGFI_LARGEICON Or SHGFI_SYSICONINDEX});
          ficon.picture.Icon.Handle  := sh.hIcon    ;
        end
        else begin
          re:= messagebox(self.handle,'Include subfolders ?' ,'Extension Changer',MB_YESNO	);
          if Re = IDYES	then WriteContents (mFiles[0],true,0) else WriteContents (mFiles[0],false,0) ;//No SubDir Plz
          LblName.caption := ' ' + countme  + ' Files selected';
          LblType.Caption  := 'Several Files';
          LblTip.Caption  := 'Change (.*) To:'    ;
          ficon.Picture.Icon := application.icon;
        end;
        end
else if mfiles.Count > 1 then begin
    LblType.Caption:= 'Multiply Files';
    For re := 0 To (mfiles.Count-1) do begin
     If directoryexists(mFiles[re]) = true Then //if a folder then get contents
      WriteContents (mFiles[re],true,re) ;
    end;
    LblName.Caption  := ' ' + CountMe + ' Files selected';
    LblType.caption := 'Several Files'               ;
    LblTip.Caption  := 'Change ' + '(.*)' + ' To:'    ;
    ficon.Picture.Icon  := application.Icon ;
end;
txtnew.SetFocus;
end;

procedure TForm1.CmdChangeClick(Sender: TObject);
var i,Re:integer;
    nFileName:string;
begin
for i := 0 to (mfiles.Count-1) do begin
  if (mfiles[i] <> '') and (fileexists(mfiles[i]) = true) then begin
      nfilename:= changefileext(mfiles[i],'.'+txtnew.Text );
      if fileexists(nFilename) = true Then begin
          Re := messagedlg('This file name already exists: '+ #13#10  + nFilename +  #13#10#13#10 +
                               'Overwrite?',mtconfirmation, [mbyes , mbno],0);
          if (Re = mrYes) And (nFilename <> mFiles[i]) Then begin
            deletefile(nFilename);
            renamefile (mFiles[i], nFilename);
          end;
      end
      else renamefile(mFiles[i], nFilename);
  end; {if}
end; {for}
self.Close;
end;

procedure TForm1.AcceptFiles( var msg : TMessage );
var
  i,nCount   : integer;
  acFileName : array [0..255] of char;
begin
// find out how many files we're accepting
nCount := DragQueryFile( msg.WParam, $FFFFFFFF,acFileName,255 );
// query Windows one at a time for the file name
for i := 0 to nCount-1 do
begin
  DragQueryFile( msg.WParam, i, acFileName, 255 );
  mfiles.Add (acfilename);
end;
DragFinish( msg.WParam ); // let Windows know that you're done
BeginExt ;
end;


procedure TForm1.CmdCancelClick(Sender: TObject);
begin
self.Close;
end;


procedure TForm1.FormCreate(Sender: TObject);
var Reg: Tregistry ;
    Re:string;
    i:byte;
begin

mfiles := tstringlist.Create; reg:= tregistry.Create ;
self.caption := 'Extension Changer ' + vNumber;
pmain.BringToFront;
//Grab Options...............
reg.OpenKeyReadOnly('\Software\Extension Changer');
self.Left:= strtoint(reg.Readstring('Left'))  ;
self.Top := strtoint(reg.ReadString('Top'))  ;
re:= reg.ReadString('StayOnTop')  ;
if re= '0' then chkontop.Checked := false
else begin
  chkontop.Checked:= true;
  SetWindowPos(self.Handle,HWND_TOPMOST,0,0,0,0, SWP_NOMOVE Or SWP_NOSIZE);
end ;
//..................................
DragAcceptFiles(Handle, True );
cskin := reg.ReadString('cSkin');
reg.Free;



GetAvailableSkins;
LoadSkin(Extractfilepath(application.ExeName) + 'skins\' + cskin);

for i := 0 to  ControlCount -1 do begin
  if controls[i] is Timage then begin
    Timage(controls[i]).Picture.Bitmap.TransparentMode := tmFixed;
    Timage(controls[i]).Picture.Bitmap.TransparentColor := rgb(238,2,163);
  end;
end;
tabmain.OnClick(nil);


end;

procedure TForm1.TabOptionsClick(Sender: TObject);
begin

taboptions.Picture := tabactive.Picture;
tabmain.Picture:= tabunactive.Picture ;
tababout.Picture:= tabunactive.Picture ;
lbloptions.font.Color:= fctab[1];
lblmain.font.Color:=   fctab[0];
lblabout.font.Color:=  fctab[0];
poptions.BringToFront ;
end;

procedure TForm1.TabMainClick(Sender: TObject);
begin
taboptions.Picture := tabunactive.Picture;
tabmain.Picture:= tabactive.Picture ;
tababout.Picture:= tabunactive.Picture ;
lbloptions.font.Color:= fctab[0];
lblmain.font.Color:=   fctab[1];
lblabout.font.Color:=  fctab[0];
pmain.BringToFront ;
end;

procedure TForm1.TabAboutClick(Sender: TObject);
begin
taboptions.Picture := tabunactive.Picture;
tabmain.Picture:= tabunactive.Picture ;
tababout.Picture:= tabactive.Picture ;
lbloptions.font.Color:= fctab[0];
lblmain.font.Color:=   fctab[0];
lblabout.font.Color:=  fctab[1];
pabout.BringToFront ;
end;


procedure TForm1.ChkOnTopClick(Sender: TObject);
begin
case chkontop.Checked of
  false: SetWindowPos(self.Handle,HWND_NOTOPMOST,0,0,0,0, SWP_NOMOVE Or SWP_NOSIZE);
  true:SetWindowPos(self.Handle,HWND_TOPMOST,0,0,0,0, SWP_NOMOVE Or SWP_NOSIZE);
end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var Reg:Tregistry;
begin
reg:= tregistry.Create  ;
reg.OpenKey('\Software\Extension Changer',false);
reg.WriteString('Left',inttostr(self.Left)) ;
reg.WriteString('Top',inttostr(self.Top));
reg.WriteString('cSkin',cskin);
if chkontop.Checked = true then reg.WriteString('OnTop', '1') else  reg.WriteString('OnTop', '0');
reg.Free ; mfiles.Free;
action:=caFree
end;

procedure TForm1.LblInfo1MouseEnter(Sender: TObject);
begin
lblinfo1.Font.Style  := [fsUnderline];
imgarrow01.DoMouseEnter;
end;

procedure TForm1.LblInfo1MouseLeave(Sender: TObject);
begin
lblinfo1.Font.Style:= [];
imgarrow01.DoMouseLeave;
end;

procedure TForm1.LblInfo2MouseEnter(Sender: TObject);
begin
lblinfo2.Font.Style:= [fsunderline];
imgarrow02.DoMouseEnter;
end;

procedure TForm1.LblInfo2MouseLeave(Sender: TObject);
begin
lblinfo2.Font.Style:= [];
imgarrow02.DoMouseLeave;
end;

procedure TForm1.LblInfo2Click(Sender: TObject);
begin
form2.showmodal;
end;


procedure TForm1.lblskinsMouseEnter(Sender: TObject);
begin
lblskins.Font.Style  := [fsUnderline];
imgarrow03.DoMouseEnter;

end;

procedure TForm1.lblskinsMouseLeave(Sender: TObject);
begin
lblskins.Font.Style  := [];
imgarrow03.DoMouseLeave;

end;

procedure TForm1.LblCopyrightMouseEnter(Sender: TObject);
begin
lblcopyright.Font.Style := [fsunderline];
lblcopyright.Cursor:=crHandPoint;

end;

procedure TForm1.LblCopyrightMouseLeave(Sender: TObject);
begin
lblcopyright.Font.Style := [];
lblcopyright.Font.Color := clblack;
Cursor:=crdefault;
end;

procedure TForm1.LblCopyrightClick(Sender: TObject);
begin
  ShellExecute(self.Handle, 'open','http://www.yehiaeg.com',nil, nil, 0);
end;

procedure TForm1.LblInfo1Click(Sender: TObject);
var Re:string;
begin
Re := 'http://filext.com/detaillist.php?extdetail=' + txtnew.Text ;
ShellExecute( self.Handle,'open', pchar(Re), nil, nil,0);
end;

procedure TForm1.FormShow(Sender: TObject);
var i:byte;
begin
//cause parameters begins with paramstr(1)
for i := 1 to paramcount  do mfiles.Add(paramstr(i));
beginext;

end;

procedure TForm1.LoadSkin(re: string);
var rebm,retest:Tbitmap;
    reini :Tinifile;
begin
rebm := TBitmap.Create; retest := tbitmap.create;
rebm.LoadFromFile(changefileext(re,'.bmp'));
//rebm.Canvas.CopyMode := cmSrcAnd;
reini := tinifile.Create(re);

pmain.Color := getrgb(reini.ReadString('Skin','tabbackcolor',''));
pabout.Color := getrgb(reini.ReadString('Skin','tabbackcolor',''));
poptions.Color := getrgb(reini.ReadString('Skin','tabbackcolor',''));
form1.Color := getrgb(reini.ReadString('Skin','formbackcolor',''));
fctab[0] := getrgb(reini.ReadString('Skin','tabunactivefontcolor',''));
fctab[1] := getrgb(reini.ReadString('Skin','tabactivefontcolor',''));


form1.Font.Name := reini.ReadString('Skin','normalfont','');
lblabout.Font.Name := reini.ReadString('Skin','tabfont','');
lbloptions.Font.Name  := lblabout.Font.Name  ;
lblmain.Font.Name :=  lblabout.Font.Name;
lbloptions.font.Color:= fctab[1];
lblmain.font.Color:=   fctab[0];
lblabout.font.Color:=  fctab[0];


reini.Free;



//rebm.TransparentMode := tmFixed; doen't work ?
//rebm.TransparentColor := $00A302EE;
retest.Width := 15;
retest.Height := 15;
retest.Canvas.CopyRect(retest.Canvas.ClipRect,rebm.Canvas,
                         rect(50,30,65,45));

imgclose.PictureNormal.Assign( retest);

retest.Canvas.CopyRect(retest.Canvas.ClipRect,rebm.Canvas,
                         rect(50,50,65,65));

imgclose.PictureOver.Assign( retest);

retest.Canvas.CopyRect(retest.Canvas.ClipRect,rebm.Canvas,
                         rect(50,70,65,85));

retest.Width := 24;
retest.Height := 24;

imgclose.PicturePressed.Assign( retest);

retest.Canvas.CopyRect(rect(0,0,24,24),rebm.Canvas,
                         rect(10,30,34,54));

imgarrow01.PictureOver.Assign(retest);
imgarrow02.PictureOver.Assign(retest);
imgarrow03.PictureOver.Assign(retest);

retest.Canvas.CopyRect(rect(0,0,24,24),rebm.Canvas,
                         rect(10,60,34,84));

imgarrow01.PictureNormal.Assign(retest);
imgarrow02.PictureNormal.Assign(retest);
imgarrow03.PictureNormal.Assign(retest);
//imgclose.Canvas.CopyRect(rect(0,0,15,15),rebm.Canvas,
 //                        rect(50,38,65,53));

 imgtop.Canvas.CopyRect(rect(0,0,250,28), rebm.Canvas,
                     rect(0,0,250,28));

imgbottom.Canvas.CopyRect(rect(0,0,imgbottom.Width,10), rebm.Canvas,
                       rect(180,100,200,110));

imgleft.Canvas.CopyRect(rect(0,0,10,imgleft.Height), rebm.Canvas,
                       rect(180,30,190,50));

imgright.Canvas.CopyRect(rect(0,0,imgright.Width,imgright.Height), rebm.Canvas,
                       rect(180,70,190,90));

imgedgeleft.Canvas.CopyRect(rect(0,0,10,10), rebm.Canvas,
                       rect(180,140,190,150));

imgedgeright.Canvas.CopyRect(rect(0,0,10,10), rebm.Canvas,
                       rect(220,140,230,150));

imgtableft.Canvas.CopyRect(rect(0,0,10,imgtableft.Height), rebm.Canvas,
                       rect(10,90,20,110));



imgtabright.Canvas.CopyRect(rect(0,0,imgtabright.Width,imgtabright.Height), rebm.Canvas,
                       rect(30,90,40,110));

imgtabbottom.Canvas.CopyRect(rect(0,0,imgtabbottom.Width,imgtabbottom.Height), rebm.Canvas,
                       rect(10,140,20,150));

imgtabedge.Canvas.CopyRect(rect(0,0,imgtabedge.Width,10), rebm.Canvas,
                       rect(180,120,190,130));


imgedgetableft.Canvas.CopyRect(rect(0,0,10,10), rebm.Canvas,
                       rect(10,120,20,130));

imgedgetabright.Canvas.CopyRect(rect(0,0,10,10), rebm.Canvas,
                       rect(30,120,40,130));


tabactive.Canvas.CopyRect(rect(0,0,tabactive.Width,tabactive.Height), rebm.Canvas,
                       rect(110,40,165,60));

tabunactive.Canvas.CopyRect(rect(0,0,tabunactive.Width,tabunactive.Height), rebm.Canvas,
                       rect(110,60,165,80));



taboptions.Picture := tabactive.Picture;
tabmain.Picture    := tabunactive.Picture ;
tababout.Picture   := tabunactive.Picture ;

retest.Free;
rebm.Free;
end;

procedure TForm1.GetAvailableSkins;
var
  remenu:TMenuItem;
  searchResult : TSearchRec;
begin
  // Try to find regular files matching Unit1.d* in the current dir
  if FindFirst(extractfilepath(application.ExeName)+ 'skins\*.ini', faAnyFile, searchResult) = 0 then
  begin
    repeat
      remenu := TMenuItem.create(self);
      remenu.caption := searchResult.name;
      remenu.onclick := popupskinsclick;
      popupskins.Items.Add(remenu);
    until FindNext(searchResult) <> 0;

    // Must free up resources used by these successful finds
    FindClose(searchResult);
  end;

end;


procedure TForm1.popupskinsclick(Sender: TObject);
var re:string;
begin
re := TMenuItem(sender).caption;
LoadSkin(Extractfilepath(application.ExeName) + 'skins\' +re);
cskin := re; //global variable that hold current skin
            //for saving the skin when closing
end;

procedure TForm1.lblskinsClick(Sender: TObject);
begin
popupskins.Popup(mouse.cursorpos.x,mouse.cursorpos.y);
end;


function getRGB(Re: String): TColor;
var r,g,b :byte;
begin
r := strtoint(leftstr(re,3));
g := strtoint(midstr(re,4,3));
b := strtoint(rightstr(re,3));
result := rgb( r,g,b);
end;

end.
