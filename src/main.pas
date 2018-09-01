unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Buttons, StdCtrls, EditBtn

  ,FileUtil  // for findfiles

  ;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    cmb_Directory: TComboBox;
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
    img_Null: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    img_Splash: TImage;
    Label1: TLabel;
    lbl_Score: TLabel;
    pnl_Top: TPanel;
    sbtn_StartGame1: TSpeedButton;
    tmrGeneral: TTimer;
    tmrGamer: TTimer;
    tmrStartUp: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
    procedure sbtn_StartGameClick(Sender: TObject);
    procedure tmrGamerTimer(Sender: TObject);
    procedure tmrGeneralTimer(Sender: TObject);
    procedure tmrStartUpTimer(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  app_path,
  img_path,
  dir    : String;

  imgfiles : TStringList;
  imgDirs  : TStringList;
  imgmaps  : array[1..20] of Integer; //just for manupulation 1,9,2,5.png...
  score    : array[1..20] of Integer; //for calculation of user memory score
implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
var
  n,cnt:Integer;
  str:String;
begin
  Randomize;
  Caption:=Application.Title;
  app_path:=GetCurrentDir;
  dir:=DirectorySeparator;  // for shorting

  imgfiles:=TStringList.Create;
  imgDirs:=TStringList.Create;


  img_Splash.Align:=alClient;
  img_Splash.Picture.LoadFromFile(app_path+dir+'startup.png');

  FindAllDirectories(imgDirs,app_path,False);
  imgDirs.Sort;

  n:=0;
  repeat
    if Pos('images',imgDirs.Strings[n])=0 then
      begin
        imgDirs.Delete(n);
        Dec(n);
      end
      else
      begin
        str:=imgDirs.Strings[n];
        Delete(str,1,Length(app_path));
        imgDirs.Strings[n]:=str;
      end;
    Inc(n);
  until n>=imgDirs.Count;
  cmb_Directory.Items:=imgDirs;

  tmrStartUp.Enabled:=True;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  cmb_Directory.ItemIndex:=0;
end;

var
   click_cnt : Integer=0;
   pic1,pic2 : TImage;
procedure TfrmMain.Image1Click(Sender: TObject);
var
  arr_n : Integer;
begin
  //This proc is a general clicker for all image components
  if tmrGamer.Enabled then
    Exit;

  if (Sender is TImage) then
    with TImage(Sender) do
    begin
      arr_n:=Tag;
      if (arr_n>0) and (arr_n<21) then
        begin
          if FileExists(imgfiles.Strings[arr_n-1]) then  // for security
            begin
              Picture.LoadFromFile(imgfiles.Strings[arr_n-1]);
              Inc(click_cnt);
              case click_cnt of
                1:pic1:=TImage(Sender);
                2:pic2:=TImage(Sender);
              end;
            end;
        end;

      if click_cnt=2 then
        begin
          if pic1.Tag=pic2.Tag then
            begin
              click_cnt:=0;
              pic1.Picture.Assign(img_Null.Picture);
              pic2.Picture.Assign(img_Null.Picture);
              Exit;
            end;
          tmrGamer.Enabled:=True;
        end;

    end;
end;

var
  clk:Boolean=false;
procedure TfrmMain.Label1DblClick(Sender: TObject);
var
  n:Integer;
begin
  //for testing...
  if not clk then
    begin
      clk:=True;
      for n:=1 to 20 do
        with TImage(FindComponent('Image'+IntToStr(n))) do
        begin
          if FileExists(imgfiles.Strings[n-1]) then  // for security
              Picture.LoadFromFile(imgfiles.Strings[n-1]);
        end;
    end
    else
    begin
      clk:=False;
      for n:=1 to 20 do
        with TImage(FindComponent('Image'+IntToStr(n))) do
        begin
          Picture.Assign(img_Null.Picture);
        end;
    end;
end;

procedure TfrmMain.sbtn_StartGameClick(Sender: TObject);
var
  n:Integer;
begin
  tmrStartUpTimer(nil);
end;

procedure TfrmMain.tmrGamerTimer(Sender: TObject);
begin
  tmrGamer.Enabled:=False;
  //lets check pictures
  if click_cnt=2 then
    begin
      click_cnt:=0;
      if imgmaps[pic1.Tag]=imgmaps[pic2.Tag] then
        begin
          Inc(score[pic1.Tag]);
          Inc(score[pic2.Tag]);
          pic1.Visible:=False;
          pic2.Visible:=False;
        end
        else
        begin
          pic1.Picture.Assign(img_Null.Picture);
          pic2.Picture.Assign(img_Null.Picture);
          Dec(score[pic1.Tag]);
          Dec(score[pic2.Tag]);
        end;
    end;
end;

procedure TfrmMain.tmrGeneralTimer(Sender: TObject);
var
  n,
  vis_cnt,
  tot_click:Integer;
  x_score:Double;
begin
  vis_cnt:=0;
  for n:=1 to 20 do
    if not TImage(FindComponent('Image'+IntToStr(n))).Visible then
      Inc(vis_cnt);
  if vis_cnt=20 then
    begin
      tmrGeneral.Enabled:=False;
    end;

  tot_click:=0;
  for n:=1 to 20 do
    tot_click+=score[n];
  x_score:=tot_click/2;
  lbl_Score.Caption:=FloatToStr(x_score);
end;

procedure TfrmMain.tmrStartUpTimer(Sender: TObject);
var
  n,cnt:Integer;
  rnd1,rnd2:Integer;
  nums:String;
begin
  tmrStartUp.Enabled:=False;

  imgfiles.Clear;

  img_path:=app_path+cmb_Directory.Text+dir;  // 'hero_images/'
  FindAllFiles(imgfiles,img_path,'*.png',false,faAnyFile);
  imgfiles.Sort;

  cnt:=imgfiles.Count-1;
  for n:=0 to cnt do
    imgfiles.Add(imgfiles.Strings[n]);  //why? two times files


  cnt:=imgfiles.Count-1;
  for n:=0 to cnt do
    begin
      repeat
        rnd1:=Random(20);
        rnd2:=Random(20);
      until (rnd1<>rnd2);
      imgfiles.Exchange(rnd1,rnd2);  //simple but good method
    end;

  for n:=0 to cnt do
    begin
      nums:=ExtractFileName(imgfiles.Strings[n]);
      nums:=ExtractFileNameWithoutExt(nums);
      try
        imgmaps[n+1]:=StrToInt(nums);
      except
        ShowMessage('File name isn''t a number! : '+imgfiles.Strings[n]);
        Exit;
      end;
    end;
  for n:=1 to 20 do
    with TImage(FindComponent('Image'+IntToStr(n))) do
    begin
      Picture.Assign(img_Null.Picture);
      Visible:=True;
    end;

  for n:=1 to 20 do  //minimum click per picture
    score[n]:=1;

  img_Splash.Visible:=False;
  tmrGeneral.Enabled:=True;
end;

end.

