object Form1: TForm1
  Left = 263
  Top = 175
  BorderStyle = bsNone
  Caption = 'Extension Changer Delphi Edition'
  ClientHeight = 224
  ClientWidth = 250
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ImgTabLeft: TImage
    Left = 10
    Top = 53
    Width = 10
    Height = 150
    Transparent = True
  end
  object ImgTop: TImage
    Left = 0
    Top = 0
    Width = 250
    Height = 28
    Transparent = True
    OnMouseMove = FormMouseMove
  end
  object ImgLeft: TImage
    Left = 0
    Top = 27
    Width = 10
    Height = 188
    Transparent = True
  end
  object TabMain: TImage
    Left = 10
    Top = 36
    Width = 55
    Height = 20
    Transparent = True
    OnClick = TabMainClick
  end
  object TabOptions: TImage
    Left = 63
    Top = 36
    Width = 55
    Height = 20
    Transparent = True
    OnClick = TabOptionsClick
  end
  object TabAbout: TImage
    Left = 116
    Top = 36
    Width = 55
    Height = 20
    Transparent = True
    OnClick = TabAboutClick
  end
  object LblMain: TLabel
    Left = 16
    Top = 40
    Width = 24
    Height = 11
    Caption = 'Main'
    Color = clWhite
    Font.Charset = ARABIC_CHARSET
    Font.Color = clBlack
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnClick = TabMainClick
  end
  object LblOptions: TLabel
    Left = 67
    Top = 40
    Width = 38
    Height = 11
    Caption = 'Options'
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    OnClick = TabOptionsClick
  end
  object LblAbout: TLabel
    Left = 125
    Top = 40
    Width = 30
    Height = 11
    Caption = 'About'
    Font.Charset = ARABIC_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    OnClick = TabAboutClick
  end
  object TabActive: TImage
    Left = 24
    Top = 224
    Width = 55
    Height = 20
  end
  object TabUnactive: TImage
    Left = 80
    Top = 224
    Width = 55
    Height = 20
  end
  object ImgClose: TImgBtn
    Left = 228
    Top = 4
    Width = 15
    Height = 15
    OnClick = ImgCloseClick
    Supported = True
  end
  object ImgTabRight: TImage
    Left = 222
    Top = 53
    Width = 10
    Height = 150
    Transparent = True
  end
  object ImgRight: TImage
    Left = 240
    Top = 28
    Width = 10
    Height = 188
    Transparent = True
  end
  object ImgBottom: TImage
    Left = 8
    Top = 214
    Width = 233
    Height = 10
    Stretch = True
    Transparent = True
  end
  object ImgTabBottom: TImage
    Left = 20
    Top = 202
    Width = 202
    Height = 10
    Transparent = True
  end
  object imgedgeright: TImage
    Left = 240
    Top = 214
    Width = 10
    Height = 10
    Transparent = True
  end
  object imgedgeleft: TImage
    Left = 0
    Top = 214
    Width = 10
    Height = 10
    Transparent = True
  end
  object imgedgetabright: TImage
    Left = 222
    Top = 202
    Width = 10
    Height = 10
    Transparent = True
  end
  object imgedgetableft: TImage
    Left = 10
    Top = 202
    Width = 10
    Height = 10
    Transparent = True
  end
  object ImgTabEdge: TImage
    Left = 11
    Top = 53
    Width = 220
    Height = 10
    Transparent = True
  end
  object PAbout: TPanel
    Left = 24
    Top = 64
    Width = 193
    Height = 137
    BevelOuter = bvNone
    Color = 4227327
    TabOrder = 0
    OnMouseMove = FormMouseMove
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 169
      Height = 17
      AutoSize = False
      Caption = 'Extension Changer 0.5 build 186'
      Transparent = True
      WordWrap = True
    end
    object LblCopyright: TLabel
      Left = 8
      Top = 88
      Width = 161
      Height = 41
      AutoSize = False
      Caption = 
        'extchanger@yehiaeg.com http://www.yehiaeg.com   Copyright '#169' 2005' +
        ' YehiaEg.com'
      Transparent = True
      WordWrap = True
      OnClick = LblCopyrightClick
      OnMouseEnter = LblCopyrightMouseEnter
      OnMouseLeave = LblCopyrightMouseLeave
    end
  end
  object POptions: TPanel
    Left = 24
    Top = 64
    Width = 193
    Height = 137
    BevelOuter = bvNone
    Color = 8454016
    TabOrder = 1
    OnMouseMove = FormMouseMove
    object LblInfo2: TLabel
      Left = 40
      Top = 56
      Width = 153
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'Check for a new version'
      Transparent = True
      WordWrap = True
      OnClick = LblInfo2Click
      OnMouseEnter = LblInfo2MouseEnter
      OnMouseLeave = LblInfo2MouseLeave
    end
    object LblInfo1: TLabel
      Left = 40
      Top = 16
      Width = 145
      Height = 26
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'Find out more info about this extension'
      Transparent = True
      WordWrap = True
      OnClick = LblInfo1Click
      OnMouseEnter = LblInfo1MouseEnter
      OnMouseLeave = LblInfo1MouseLeave
    end
    object lblskins: TLabel
      Left = 40
      Top = 88
      Width = 153
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'Change Current Skin'
      Transparent = True
      WordWrap = True
      OnClick = lblskinsClick
      OnMouseEnter = lblskinsMouseEnter
      OnMouseLeave = lblskinsMouseLeave
    end
    object imgarrow01: TImgBtn
      Left = 8
      Top = 16
      Width = 24
      Height = 24
      Supported = True
    end
    object imgarrow02: TImgBtn
      Left = 8
      Top = 48
      Width = 25
      Height = 25
      Supported = True
    end
    object imgarrow03: TImgBtn
      Left = 8
      Top = 80
      Width = 25
      Height = 25
      Supported = True
    end
    object ChkOnTop: TCheckBox
      Left = 96
      Top = 120
      Width = 97
      Height = 17
      Caption = 'Always On Top'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
      OnClick = ChkOnTopClick
    end
  end
  object PMain: TPanel
    Left = 24
    Top = 64
    Width = 193
    Height = 137
    BevelOuter = bvNone
    Color = clRed
    TabOrder = 2
    OnMouseMove = FormMouseMove
    object LblName: TLabel
      Left = 56
      Top = 8
      Width = 46
      Height = 13
      Caption = 'File Name'
    end
    object LblType: TLabel
      Left = 56
      Top = 24
      Width = 43
      Height = 13
      Caption = 'File Type'
    end
    object LblTip: TLabel
      Left = 72
      Top = 64
      Width = 56
      Height = 13
      Caption = 'Change To:'
    end
    object Panel2: TPanel
      Left = 8
      Top = 8
      Width = 34
      Height = 34
      AutoSize = True
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 1
      object fIcon: TImage
        Left = 1
        Top = 1
        Width = 32
        Height = 32
      end
    end
    object TxtNew: TEdit
      Left = 64
      Top = 80
      Width = 73
      Height = 21
      TabOrder = 2
    end
    object CmdChange: TButton
      Left = 32
      Top = 104
      Width = 65
      Height = 25
      Caption = 'Change'
      Default = True
      TabOrder = 0
      OnClick = CmdChangeClick
    end
    object CmdCancel: TButton
      Left = 104
      Top = 104
      Width = 65
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = CmdCancelClick
    end
  end
  object extXp: TXPManifest
    Left = 192
    Top = 64
  end
  object popupskins: TPopupMenu
    AutoHotkeys = maManual
    Left = 192
    Top = 88
  end
end
