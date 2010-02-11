unit ReadOnlyMain;

interface

uses
  Windows, Classes, CustomContextMenu;

const
  MAX_FILES = 30;

type
  TMyContextMenu = class(TCustomContextMenu)
  private
    FileAttributes: array[0..MAX_FILES-1] of Cardinal;
  public
    function GetHelpText(IdCmdOffset: UINT): String; override;
    function GetVerb(IdCmdOffset: UINT): String; override;
    function AddMenuItems(Menu: HMENU; MenuIndex, IdCmdFirst, IdCmdLast: UINT): UINT; override;
    procedure ExecuteCommand(IdCmdOffset: UINT); override;
  end;


implementation

uses
  SysUtils, Math;

const
  GUID_ContextMenuEntry: TGUID = '{EBDF1F20-C829-11D1-8233-0020AF3E97C6}';
  VERB = 'readonly';
  // Menu items
  MENUITEM_PARENT = 0;
  MENUITEM_REMOVE_READONLY = 1;
  MENUITEM_SET_READONLY = 2;
  MENUITEM_FILENAMES_OFFSET = 3;

{------------------- TMyContextMenu -------------------}

function TMyContextMenu.GetHelpText(IdCmdOffset: UINT): String;
var
  FileAttr: Cardinal;
  Index: UINT;
begin
  if FileNames.Count = 1 then  // We have only 1 menu item
  begin
    FileAttr := FileAttributes[0];
    if (FileAttr and FILE_ATTRIBUTE_READONLY) <> 0 then
      Result := 'This item is read-only.'
    else
      Result := 'This item is not read-only.';
  end

  else   // We have several menu items; IdCmdOffset tells us which one is highlighted
  begin
    if IdCmdOffset = MENUITEM_PARENT then
      Result := 'Allows you to view and change read-only protection.'
    else if IdCmdOffset = MENUITEM_SET_READONLY then
      Result := 'Sets read-only protection for the selected items.'
    else if IdCmdOffset = MENUITEM_REMOVE_READONLY then
      Result := 'Removes read-only protection for the selected items.'
    else
    begin
      Index := IdCmdOffset - MENUITEM_FILENAMES_OFFSET;
      try
        FileAttr := FileAttributes[Index];
        if (FileAttr and FILE_ATTRIBUTE_READONLY) <> 0 then
          Result := 'This item is read-only.'
        else
          Result := 'This item is not read-only.';
      except
        Result := 'Error: No item with index ' + IntToStr(Index);
      end;
    end;
  end;
end;


function TMyContextMenu.GetVerb(IdCmdOffset: UINT): String;
begin
  Result := VERB;
end;


function TMyContextMenu.AddMenuItems(Menu: HMENU; MenuIndex, IdCmdFirst, IdCmdLast: UINT): UINT;
type
  TFileCollectionStatus = (Mixed, AllReadOnly, AllNotReadOnly);

  function GetFileCollectionStatus(FileAttributes: array of Cardinal): TFileCollectionStatus;
  var
    I: Integer;
    ReadOnlyFound, NotReadOnlyFound: Integer;
  begin
    ReadOnlyFound := 0;
    NotReadOnlyFound := 0;
    for I := 0 to FileNames.Count -1 do
    begin
      if (FileAttributes[I] and FILE_ATTRIBUTE_READONLY) <> 0 then
        Inc(ReadOnlyFound)
      else
        Inc(NotReadOnlyFound);
      if (ReadOnlyFound > 0) and (NotReadOnlyFound > 0) then
        Break;
    end;

    if (ReadOnlyFound > 0) and (NotReadOnlyFound > 0) then
      Result := Mixed
    else if (ReadOnlyFound > 0) then
      Result := AllReadOnly
    else
      Result := AllNotReadOnly;
  end;

var
  mii: TMenuItemInfo;
  SubMenu: HMENU;
  I: UINT;
  FilesToAdd: Word;
  FileCollectionStatus: TFileCollectionStatus;
begin
  FillChar(mii, SizeOf(mii), 0);
  mii.cbSize := SizeOf(mii);
  mii.fMask := MIIM_ID or MIIM_TYPE;
  mii.fType := MFT_STRING;
  mii.fState := MFS_ENABLED;

  if FileNames.Count = 1 then
  begin
    mii.wID := IdCmdFirst;
    // Get read-only file attribute
    FileAttributes[0] := GetFileAttributes(PChar(FileNames[0]));
    if FileAttributes[0] <> $FFFFFFFF then
    begin
      if (FileAttributes[0] and FILE_ATTRIBUTE_READONLY) <> 0 then
      begin
        // File is read-only
        mii.fMask := mii.fMask or MIIM_STATE;
        mii.fState := mii.fState or MFS_CHECKED;
      end;
      mii.dwTypeData := PChar('R&ead-only');
      InsertMenuItem(Menu, MenuIndex, True, mii);
      Result := IdCmdFirst;    // Return max id of inserted menu items = IdCmdFirst
    end
    else
      Result := 0;   // Something went wrong; don't insert any menu item, and return 0
  end

  else
  begin
    // Submenu items
    SubMenu := CreatePopupMenu;

    FileNames.Sort;

    FilesToAdd := Min(FileNames.Count, MAX_FILES);
    for I := 0 to FilesToAdd -1 do
    begin
      mii.dwTypeData := PChar(ExtractFileName(FileNames[I]));
      mii.wID := IdCmdFirst + MENUITEM_FILENAMES_OFFSET + I;
      mii.fMask := MIIM_ID or MIIM_TYPE;
      // Get read-only file attribute
      FileAttributes[I] := GetFileAttributes(PChar(FileNames[I]));
      if (FileAttributes[I] and FILE_ATTRIBUTE_READONLY) <> 0 then
      begin
        // File is read-only
        mii.fMask := mii.fMask or MIIM_STATE;
        mii.fState := mii.fState or MFS_CHECKED;
      end;
      InsertMenuItem(SubMenu, I, True, mii);
    end;

    mii.fMask := MIIM_ID or MIIM_TYPE;
    mii.fType := MFT_SEPARATOR;
    mii.wID := 0;
    InsertMenuItem(SubMenu, $FFFFFFFF, True, mii);
    mii.fType := MFT_STRING;

    FileCollectionStatus := GetFileCollectionStatus(FileAttributes);

    mii.dwTypeData := PChar('&Remove read-only protection');
    mii.wID := IdCmdFirst + MENUITEM_REMOVE_READONLY;
    if FileCollectionStatus = AllNotReadOnly then
    begin
      mii.fMask := mii.fMask or MIIM_STATE;
      mii.fState := MFS_DISABLED or MFS_GRAYED;
    end;
    InsertMenuItem(SubMenu, $FFFFFFFF, True, mii);
    mii.fMask := MIIM_ID or MIIM_TYPE;

    mii.dwTypeData := PChar('&Set read-only protection');
    mii.wID := IdCmdFirst + MENUITEM_SET_READONLY;
    if FileCollectionStatus = AllReadOnly then
    begin
      mii.fMask := mii.fMask or MIIM_STATE;
      mii.fState := MFS_DISABLED or MFS_GRAYED;
    end;
    InsertMenuItem(SubMenu, $FFFFFFFF, True, mii);

    // Check for max # files
    if FilesToAdd >= MAX_FILES then
    begin
      AppendMenu(SubMenu, MF_SEPARATOR, 0, nil);
      AppendMenu(SubMenu, MF_STRING or MF_DISABLED, 0,
                 PChar('(More than ' + IntToStr(MAX_FILES) + ' items)'));
    end;

    // Create parent item containing the submenu
    mii.dwTypeData := PChar('R&ead-only');
    mii.wID := IdCmdFirst + MENUITEM_PARENT;
    mii.fMask := MIIM_ID or MIIM_TYPE or MIIM_SUBMENU;
    mii.hSubMenu := SubMenu;
    InsertMenuItem(Menu, MenuIndex, True, mii);

    // Return max id of inserted menu items
    Result := IdCmdFirst + MENUITEM_FILENAMES_OFFSET + FilesToAdd - 1;
  end;
end;


procedure TMyContextMenu.ExecuteCommand(IdCmdOffset: UINT);

  procedure SetFilesReadOnly(IndexStart, IndexEnd: Integer; ReadOnly: Boolean);
  var
    I: Integer;
  begin
    for I := IndexStart to IndexEnd do
    begin
      if ReadOnly then
        FileAttributes[I] := FileAttributes[I] or FILE_ATTRIBUTE_READONLY
      else
        FileAttributes[I] := FileAttributes[I] and not FILE_ATTRIBUTE_READONLY;
      SetFileAttributes(PChar(FileNames[I]), FileAttributes[I]);
    end;
  end;

var
  IsReadOnly: Boolean;
  Index: UINT;
begin
  if FileNames.Count = 1 then
  begin
    IsReadOnly := ((FileAttributes[0] and FILE_ATTRIBUTE_READONLY) <> 0);
    SetFilesReadOnly(0, 0, not IsReadOnly);
  end

  else
  begin
    if IdCmdOffset = MENUITEM_PARENT then
      // Do nothing
    else if IdCmdOffset = MENUITEM_SET_READONLY then
      SetFilesReadOnly(0, Min(FileNames.Count, MAX_FILES) - 1, True)
    else if IdCmdOffset = MENUITEM_REMOVE_READONLY then
      SetFilesReadOnly(0, Min(FileNames.Count, MAX_FILES) - 1, False)
    else
    begin
      Index := IdCmdOffset - MENUITEM_FILENAMES_OFFSET;
      IsReadOnly := ((FileAttributes[Index] and FILE_ATTRIBUTE_READONLY) <> 0);
      SetFilesReadOnly(Index, Index, not IsReadOnly);
    end;
  end;
end;


initialization
  Initialize(TMyContextMenu, GUID_ContextMenuEntry, 'ReadOnlyPlugin');

end.

