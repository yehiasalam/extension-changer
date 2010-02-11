object Form2: TForm2
  Left = 256
  Top = 373
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Extension Changer'
  ClientHeight = 164
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BevDownload: TBevel
    Left = 8
    Top = 104
    Width = 233
    Height = 17
    Shape = bsFrame
    Visible = False
  end
  object Lbldownload: TLabel
    Left = 14
    Top = 105
    Width = 224
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.yehiaeg.com/extchang.exe'
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = 5254659
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    Visible = False
    OnClick = LbldownloadClick
  end
  object TxtInfo: TMemo
    Left = 8
    Top = 8
    Width = 233
    Height = 97
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Click the button to Check'
      'for the latest version...'
      ''
      'The Application will connect to a web '
      'server , make sure that you have an '
      'active internet connection.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object CmdCheck: TButton
    Left = 40
    Top = 128
    Width = 177
    Height = 25
    Caption = 'Check'
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CmdCheckClick
  end
end
