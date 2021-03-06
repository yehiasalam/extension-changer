unit ImgBtn;

//* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *//
//*  ImgBtn. Delphi 3, 4
//*
//* This component turns 3 images to button with 3 states : normal, MouseOver
//* and Pressed. I've also added some importent events.
//*
//* Writen by Paul Krestol.
//* For contacts e-mail me to : paul@mediasonic.co.il
//* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *//


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TOnMouseEvent = procedure( Msg: TWMMouse ) of object;

  TImgBtn = class( TImage )
  protected
    procedure WMMouseEnter( var Msg : TWMMouse ); message CM_MOUSEENTER;
    procedure WMMouseLeave( var Msg : TWMMouse ); message CM_MOUSELEAVE;
    procedure WMLButtonUp( var Msg : TWMLButtonUp ); message WM_LBUTTONUP;
    procedure WMLButtonDown( var Msg : TWMLButtonUp ); message WM_LBUTTONDOWN;
  private
    FEntered : boolean;
    FDown : boolean;
    FOnMouseEnter : TOnMouseEvent;
    FOnMouseLeave : TOnMouseEvent;
    FOnMouseDown  : TOnMouseEvent;
    FOnMouseUp    : TOnMouseEvent;
    FPicNormal : TPicture;
    FPicPressed : TPicture;
    FPicOver : TPicture;
    FSupported : boolean;
    procedure SetPicNormal( Value : TPicture );
    procedure SetPicPressed( Value : TPicture );
    procedure SetPicOver( Value : TPicture );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    //** Images **//
    property PictureNormal : TPicture read FPicNormal write SetPicNormal;
    property PicturePressed : TPicture read FPicPressed write SetPicPressed;
    property PictureOver : TPicture read FPicOver write SetPicOver;
    //** Events **//
    property OnMouseDown : TOnMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseEnter : TOnMouseEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TOnMouseEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp : TOnMouseEvent read FOnMouseUp write FOnMouseUp;
    property Supported : boolean read FSupported write FSupported;
    procedure DoMouseEnter();
    procedure DoMouseLeave();
    procedure SetMainPic(Sender:Tobject); //used to assign normal to main picture
  end;

procedure Register;

implementation
{$R *.RES}

(*******************************************************************************)
procedure Register;
begin
  RegisterComponents( 'Plus', [ TImgBtn ] );
end;

(*******************************************************************************)
constructor TImgBtn.Create;
begin
  inherited;
  FPicNormal := TPicture.Create; fPicNormal.OnChange :=SetMainPic;
  FPicOver := TPicture.Create;
  FPicPressed := TPicture.Create;
  FEntered := False;
  FDown := False;
  FSupported := True;
  //Transparent := True;
  //Picture.Bitmap.TransparentMode := tmFixed;
  //Picture.Bitmap.TransparentColor := rgb(238,2,163);
end;

(*******************************************************************************)
destructor TImgBtn.Destroy;
begin
  FPicNormal.Free;
  FPicPressed.Free;
  FPicOver.Free;
  inherited;
end;

(*******************************************************************************)
procedure TImgBtn.WMMouseEnter( var Msg: TWMMouse );
begin
  if not FSupported then Exit;
  FEntered := True;
  if FDown then Picture := FPicPressed
  else if  fpicover.Graphic <> nil then Picture := FPicOver;

  if Assigned( FOnMouseEnter ) then FOnMouseEnter( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.WMMouseLeave( var Msg: TWMMouse );
begin
  if not FSupported then Exit;
  FEntered := False;
  Picture := FPicNormal;
  if Assigned( FOnMouseLeave ) then FOnMouseLeave( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.WMLButtonDown(var Msg: TWMMouse);
begin
  inherited;
  if not FSupported then Exit;
  FDown := True;
  if FEntered then if  fpicpressed.Graphic <> nil then Picture := FPicPressed;
  if Assigned( FOnMouseDown ) then FOnMouseDown( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.WMLButtonUp(var Msg: TWMMouse);
begin
  inherited;
  if not FSupported then Exit;
  FDown := False;
  if FEntered then Picture := FPicOver;
  if Assigned( FOnMouseUp ) then FOnMouseUp( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.SetPicNormal( Value : TPicture );
begin
  Picture := Value;
  FPicNormal.Assign( Value );
end;

procedure TImgBtn.SetMainPic(Sender: Tobject);
begin
Picture :=   FPicNormal;
end;
(*******************************************************************************)
procedure TImgBtn.SetPicPressed( Value : TPicture );
begin
  FPicPressed.Assign( Value );
end;

(*******************************************************************************)
procedure TImgBtn.SetPicOver( Value : TPicture );
begin
  FPicOver.Assign( Value );
end;

procedure TImgBtn.DoMouseEnter;
begin
  if not FSupported then Exit;
  FEntered := True;
  if FDown then Picture := FPicPressed
  else if  fpicover.Graphic <> nil then Picture := FPicOver;
end;

procedure TImgBtn.DoMouseLeave;
begin
  if not FSupported then Exit;
  FEntered := False;
  Picture := FPicNormal;
end;



end.
