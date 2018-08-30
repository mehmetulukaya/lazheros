unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Buttons;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image2: TImage;
    Image20: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    img_Splash: TImage;
    tmrStartUp: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrStartUpTimer(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  app_path,
  img_path,
  dir    : String;


implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption:=Application.Title;
  app_path:=GetCurrentDir;
  dir:=DirectorySeparator;  // for shorting
  img_path:='..'+dir+'hero_images'+dir;  // '../hero_images/'
  img_Splash.Align:=alClient;
  img_Splash.Picture.LoadFromFile(img_path+'hw'+dir+'launch.jpg');
  tmrStartUp.Enabled:=True;
end;

procedure TfrmMain.tmrStartUpTimer(Sender: TObject);
begin
  tmrStartUp.Enabled:=False;

  img_Splash.Visible:=False;
end;

end.

