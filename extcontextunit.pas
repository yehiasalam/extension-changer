unit extcontextunit;

interface

uses
  Windows,Classes, ActiveX, ComObj, ShlObj, Dialogs;

type
  TContextMenu = class(TComObject, IShellExtInit, IContextMenu)
  private
    refiles: TStringList;
  protected
    { IShellExtInit }
    function IShellExtInit.Initialize = SEIInitialize; // Avoid compiler warning
    function SEIInitialize(pidlFolder: PItemIDList; lpdobj: IDataObject; hKeyProgID: HKEY): HResult; stdcall;
    { IContextMenu }
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;   pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  end;

const
  Class_ContextMenu: TGUID = '{4187A059-6CEF-4DA0-80A1-15CBF47EF34C}';

implementation

uses ComServ, SysUtils, ShellApi, Registry;

function TContextMenu.SEIInitialize(pidlFolder: PItemIDList; lpdobj: IDataObject;  hKeyProgID: HKEY): HResult;
var
  StgMedium: TStgMedium;
  FormatEtc: TFormatEtc;
  i:integer;
  Recount :integer;
  Buffer: array[0..MAX_PATH] of Char;
begin
  // Fail the call if lpdobj is Nil.
  if (lpdobj = nil) then begin
    Result := E_INVALIDARG;
    exit;
  end;

with FormatEtc do begin
   cfFormat := CF_HDROP;
   ptd      := nil;
   dwAspect := DVASPECT_CONTENT;
   lindex   := -1;
   tymed    := TYMED_HGLOBAL;
end;

  // Render the data referenced by the IDataObject pointer to an HGLOBAL
  // storage medium in CF_HDROP format.
  Result := lpdobj.GetData(FormatEtc, StgMedium);
  if Failed(Result) then  Exit;

  refiles := Tstringlist.Create;
  recount := DragQueryFile(StgMedium.hGlobal, $FFFFFFFF, nil, 0);
  if recount > 0 then begin
      for i := 0 to recount - 1 do begin
          DragQueryFile(StgMedium.hGlobal, I, Buffer, MAX_PATH);
          refiles.Add(StrPas(Buffer));
      end;
      Result := NOERROR;
   end
   else Result := E_FAIL;
ReleaseStgMedium(StgMedium);
end;

function TContextMenu.QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult;
var re:string;
begin

Result := 0; // or use MakeResult(SEVERITY_SUCCESS, FACILITY_NULL, 0);
if ((uFlags and $0000000F) = CMF_NORMAL) or ((uFlags and CMF_EXPLORE) <> 0) then begin
  if refiles.Count = 1 then re := 'Edit The Extension (' + extractfileext(refiles[0])+ ')'
                       else re := 'Edit The Extension';
  InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst, pchar(re));
                    //indecMenu
     // Return number of menu items added
  Result := 1; // or use MakeResult(SEVERITY_SUCCESS, FACILITY_NULL, 1)
end;
end;

function TContextMenu.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
var
  re: string;
  i:integer;
  redllpath : array[0..MAX_PATH] of char;
begin
  Result := E_FAIL;
  // Make sure we are not being called by an application
  if (HiWord(Integer(lpici.lpVerb)) <> 0) then exit;

  // Make sure we aren't being passed an invalid argument number
  if (LoWord(lpici.lpVerb) <> 0) then begin
    Result := E_INVALIDARG;
    Exit;
  end;
  for i := 0 to refiles.Count - 1 do re := re + ' "' + refiles[i]  + '"';
  FillChar(redllpath, sizeof(redllpath), #0);
  GetModuleFileName(hInstance, redllpath, sizeof(redllpath));

  Re := '"' + extractfilepath(redllpath ) + 'extmain.exe"' + re;
  WinExec(pchar(re), lpici.nShow);
  Result := NOERROR;

end;

function TContextMenu.GetCommandString(idCmd, uType: UINT; pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HRESULT;
begin
if (idCmd = 0) then begin
  if uType = GCS_HELPTEXT
  then StrCopy(pszName, 'Edit the extension of the selected file(s).');
  Result := NOERROR;
end
else Result := E_INVALIDARG;
end;

type
  TContextMenuFactory = class(TComObjectFactory)
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

procedure TContextMenuFactory.UpdateRegistry(Register: Boolean);
var
  ClassID: string;
begin
if Register then begin
  inherited UpdateRegistry(Register);
  ClassID := GUIDToString(Class_ContextMenu);
  CreateRegKey('*\shellex', '', '');
  CreateRegKey('*\shellex\ContextMenuHandlers', '', '');
  CreateRegKey('*\shellex\ContextMenuHandlers\Extension Changer', '', ClassID);
  CreateRegKey('Directory\shellex', '', '');
  CreateRegKey('Directory\shellex\ContextMenuHandlers', '', '');
  CreateRegKey('Directory\shellex\ContextMenuHandlers\Extension Changer', '', ClassID);

    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
      with TRegistry.Create do
        try
          RootKey := HKEY_LOCAL_MACHINE;
          OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions', True);
          OpenKey('Approved', True);
          WriteString(ClassID, 'Extension Changer Context Menu Handler');
        finally
          Free;
        end;
end
else begin //Unregister
    DeleteRegKey('*\shellex\ContextMenuHandlers\Extension Changer');
    DeleteRegKey('Directory\shellex\ContextMenuHandlers\Extension Changer');
    inherited UpdateRegistry(Register);
end;

end;

initialization
  TContextMenuFactory.Create(ComServer, TContextMenu, Class_ContextMenu,
    '', 'Extension Changer Context Menu Shell Extension', ciMultiInstance,
    tmApartment);
end.
