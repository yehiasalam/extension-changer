unit OwnerDrwMain;

interface

uses
  Windows, CustomContextMenu;

type
  TMyContextMenu = class(TOwnerDrawContextMenu)
  public
    // Basic methods
    function GetHelpText(IdCmdOffset: UINT): String; override;
    function GetVerb(IdCmdOffset: UINT): String; override;
    function AddMenuItems(Menu: HMENU; MenuIndex, IdCmdFirst, IdCmdLast: UINT): UINT; override;
    procedure ExecuteCommand(IdCmdOffset: UINT); override;
    // Owner-draw methods
    procedure MeasureMenuItem(IdCmd: UINT; var Width: UINT; var Height: UINT); override;
    procedure DrawMenuItem(Menu: HMENU; IdCmd: UINT; DC: HDC; Rect: TRect;
      State: TOwnerDrawState); override;
  end;


implementation

{$R bitmap.res}    // Include resource file containg bitmap

const
  GUID_ContextMenuEntry: TGUID = '{9BF0D3E8-9341-4400-B6A2-26780F46D39E}';
  HELPTEXT = 'This is an owner-drawn menu item.';
  VERB = 'OwnerDraw';
  MENUITEM_CAPTION = 'Owner-drawn item';

{------------------- Utility methods ------------------}

// This method found at: http://www.delphipages.com/news/detaildocs.cfm?ID=97

procedure DrawTransparentBitmap(DC: HDC; hBmp: HBITMAP; xStart, yStart: Integer;
  cTransparentColor: COLORREF);
var
  bm: BITMAP;
  cColor: COLORREF;
  bmAndBack, bmAndObject, bmAndMem, bmSave: HBITMAP;
  bmBackOld, bmObjectOld, bmMemOld, bmSaveOld: HBITMAP;
  hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave: HDC;
  ptSize: TPOINT;
begin
  hdcTemp := CreateCompatibleDC(DC);
  SelectObject(hdcTemp, hBmp);  // Select the bitmap
  GetObject(hBmp, SizeOf(BITMAP), @bm);
  ptSize.x := bm.bmWidth;       // Get width of bitmap
  ptSize.y := bm.bmHeight;      // Get height of bitmap
  DPtoLP(hdcTemp, ptSize, 1);   // Convert from device to logical points
  // Create some DCs to hold temporary data.
  hdcBack := CreateCompatibleDC(DC);
  hdcObject := CreateCompatibleDC(DC);
  hdcMem := CreateCompatibleDC(DC);
  hdcSave := CreateCompatibleDC(DC);
  // Create a bitmap for each DC. DCs are required for a number of GDI functions.
  // Monochrome DC
  bmAndBack := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  // Monochrome DC
  bmAndObject := CreateBitmap(ptSize.x, ptSize.y, 1, 1, nil);
  bmAndMem := CreateCompatibleBitmap(DC, ptSize.x, ptSize.y);
  bmSave := CreateCompatibleBitmap(DC, ptSize.x, ptSize.y);
  // Each DC must select a bitmap object to store pixel data.
  bmBackOld := SelectObject(hdcBack, bmAndBack);
  bmObjectOld := SelectObject(hdcObject, bmAndObject);
  bmMemOld := SelectObject(hdcMem, bmAndMem);
  bmSaveOld := SelectObject(hdcSave, bmSave);
  // Set proper mapping mode.
  SetMapMode(hdcTemp, GetMapMode(DC));
  // Save the bitmap sent here, because it will be overwritten.
  BitBlt(hdcSave, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);
  // Set the background color of the source DC to the color
  // contained in the parts of the bitmap that should be transparent
  cColor := SetBkColor(hdcTemp, cTransparentColor);
  // Create the object mask for the bitmap by performing a BitBlt
  // from the source bitmap to a monochrome bitmap.
  BitBlt(hdcObject, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCCOPY);
  // Set the background color of the source DC back to the original color.
  SetBkColor(hdcTemp, cColor);
  // Create the inverse of the object mask.
  BitBlt(hdcBack, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, NOTSRCCOPY);
  // Copy the background of the main DC to the destination.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, DC, xStart, yStart, SRCCOPY);
  // Mask out the places where the bitmap will be placed.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcObject, 0, 0, SRCAND);
  // Mask out the transparent colored pixels on the bitmap.
  BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcBack, 0, 0, SRCAND);
  // XOR the bitmap with the background on the destination DC.
  BitBlt(hdcMem, 0, 0, ptSize.x, ptSize.y, hdcTemp, 0, 0, SRCPAINT);
  // Copy the destination to the screen.
  BitBlt(DC, xStart, yStart, ptSize.x, ptSize.y, hdcMem, 0, 0, SRCCOPY);
  // Place the original bitmap back into the bitmap sent here.
  BitBlt(hdcTemp, 0, 0, ptSize.x, ptSize.y, hdcSave, 0, 0, SRCCOPY);
  // Delete the memory bitmaps.
  DeleteObject(SelectObject(hdcBack, bmBackOld));
  DeleteObject(SelectObject(hdcObject, bmObjectOld));
  DeleteObject(SelectObject(hdcMem, bmMemOld));
  DeleteObject(SelectObject(hdcSave, bmSaveOld));
  // Delete the memory DCs.
  DeleteDC(hdcMem);
  DeleteDC(hdcBack);
  DeleteDC(hdcObject);
  DeleteDC(hdcSave);
  DeleteDC(hdcTemp);
end;

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
  // Insert menu item
  FillChar(mii, SizeOf(mii), 0);
  mii.cbSize := SizeOf(mii);
  mii.fMask := MIIM_ID or MIIM_TYPE;
  mii.fType := MFT_OWNERDRAW;     // Remember to specify MFT_OWNERDRAW
  mii.fState := MFS_ENABLED;
  mii.wID := IdCmdFirst;
  InsertMenuItem(Menu, MenuIndex, True, mii);
  Result := IdCmdFirst;      // Return max id of inserted menu items = IdCmdFirst
end;


procedure TMyContextMenu.ExecuteCommand(IdCmdOffset: UINT);
begin
  MessageBox(0, 'You clicked an owner-drawn menu item.', 'Owner-draw demo',
    MB_ICONINFORMATION or MB_OK);
end;


procedure TMyContextMenu.MeasureMenuItem(IdCmd: UINT; var Width: UINT; var Height: UINT);
begin
  Height := 36;
  { We need to calculate the width of our menu item. Since we just want to use the
    standard menu font we use the GetStandardTextWidth method. }
  // Get text width and add 32+4 px for the bitmap we're going to draw
  Width := GetStandardTextWidth(MENUITEM_CAPTION) + 32 + 4;
end;


procedure TMyContextMenu.DrawMenuItem(Menu: HMENU; IdCmd: UINT; DC: HDC; Rect: TRect;
  State: TOwnerDrawState);
var
  Bmp: HBITMAP;
begin
  // Fill background and set colors depending on selection status
  if odSelected in State then
  begin
    SetBkColor(DC, GetSysColor(COLOR_HIGHLIGHT));
    SetTextColor(DC, GetSysColor(COLOR_HIGHLIGHTTEXT));
    FillRect(DC, Rect, HBRUSH(COLOR_HIGHLIGHT+1));
  end
  else
  begin
    SetBkColor(DC, GetSysColor(COLOR_MENU));
    SetTextColor(DC, GetSysColor(COLOR_MENUTEXT));
    FillRect(DC, Rect, HBRUSH(COLOR_MENU+1));
  end;
  Bmp := LoadBitmap(HInstance, 'TEMPLE');   // Load 32x32 bitmap
  try
    { Drawing a bitmap transparently is complicated stuff. I tried using imagelists,
      but failed to make it work. The method below comes to the rescue.
      The bitmap we use has a white background. }
    // Draw bitmap (starting with a margin of 16)
    if Bmp <> 0 then
      DrawTransparentBitmap(DC, Bmp, Rect.Left + 16, Rect.Top + 2, $FFFFFF);  // $FFFFFF = clWhite
    // Draw text, using a 16 px left margin, and 32+4 px reserved for the image
    TextOut(DC, Rect.Left + 16+32+4, Rect.Top + 12, PChar(MENUITEM_CAPTION), Length(MENUITEM_CAPTION));
  finally
    // Clean up
    DeleteObject(Bmp);
  end;
end;


initialization
  Initialize(TMyContextMenu, GUID_ContextMenuEntry, 'OwnerDrawPlugin');

end.

