unit CopyPathMain;

interface

uses
  Windows, CustomContextMenu;

type
  TMyContextMenu = class(TCustomContextMenu)
  public
    function GetHelpText(IdCmdOffset: UINT): String; override;
    function GetVerb(IdCmdOffset: UINT): String; override;
    function AddMenuItems(Menu: HMENU; MenuIndex, IdCmdFirst, IdCmdLast: UINT): UINT; override;
    procedure ExecuteCommand(IdCmdOffset: UINT); override;
  end;


implementation

uses
  SysUtils;

const
  GUID_ContextMenuEntry: TGUID = '{B33DE756-DEEE-4D7A-87DB-900854B1D3A7}';
  HELPTEXT = 'Copies the path of the selected items to the Clipboard.';
  VERB = 'CopyPath';

{------------------- TMyContextMenu -------------------}

function TMyContextMenu.GetHelpText(IdCmdOffset: UINT): String;
begin
  Result := HELPTEXT;
end;


function TMyContextMenu.GetVerb(IdCmdOffset: UINT): String;
begin
  Result := VERB;
end;


function TMyContextMenu.AddMenuItems(Menu: HMENU; MenuIndex, IdCmdFirst, IdCmdLast: UINT): UINT;
var
  mii: TMenuItemInfo;
begin
  FillChar(mii, SizeOf(mii), 0);
  mii.cbSize := SizeOf(mii);
  mii.fMask := MIIM_ID or MIIM_TYPE;
  mii.fType := MFT_STRING;
  mii.fState := MFS_ENABLED;
  mii.dwTypeData := PChar('Cop&y path(s)');
  mii.wID := IdCmdFirst;
  InsertMenuItem(Menu, MenuIndex, True, mii);
  Result := IdCmdFirst;      // Return max id of inserted menu items = IdCmdFirst
end;


procedure TMyContextMenu.ExecuteCommand(IdCmdOffset: UINT);

  procedure CopyToClipboard(S: String);
  { This method uses API methods rather than the ClipBrd unit in order to create
    a smaller footprint. }
  var
    Data: THandle;
    DataPtr: Pointer;
  begin
    Data := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Length(S) + 1);
    if Data <> 0 then
    begin
      DataPtr := GlobalLock(Data);
      if Cardinal(DataPtr) <> 0 then
        try
          CopyMemory(DataPtr, PChar(S), Length(S));
          // Send to clipboard
          OpenClipBoard(0);
          EmptyClipboard;
          SetClipboardData(CF_TEXT, Data);
          CloseClipBoard;
        finally
          GlobalUnlock(Data);
        end;
    end;
  end;

var
  I: Integer;
  S: String;
begin
  if FileNames.Count = 1 then
  begin
    S := FileNames[0];
    CopyToClipboard(S);
  end
  else
  begin
    FileNames.Sort;
    S := '';
    for I := 0 to FileNames.Count -1 do
      S := S + FileNames[I] + #13#10;
    CopyToClipboard(S);
  end;
end;


initialization
  Initialize(TMyContextMenu, GUID_ContextMenuEntry, 'CopyPathPlugin');

end.

