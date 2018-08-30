unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    img_Splash: TImage;
    imglst_Heros: TImageList;
    tmrStartUp: TTimer;
    procedure FormCreate(Sender: TObject);
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
  img_Splash.Picture.LoadFromFile(img_path+'hw'+dir+'launch.jpg');
  tmrStartUp.Enabled:=True;
end;

end.

