unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMyFileRec = packed record
    NumMajor
    , NumMinor
    , NumRelease
    , NumBuild: DWORD;
    PrVersMSHi
    , PrVersMSLo
    , PrVersLSHi
    , PrVersLSLo: DWORD;
  end;

  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  FileVersInfo: TMyFileRec;

  function FileVersion(const FileName: TFileName; out MyFileRec: TMyFileRec): string;
  var
    VerInfoSize: Cardinal;
    VerValueSize: Cardinal;
    Dummy: Cardinal;
    PVerInfo: Pointer;
    PVerValue: PVSFixedFileInfo;
  begin
    Result := '';
//    MyFileRec:= default(TMyFileRec);
    with MyFileRec do
    begin
      NumMajor := 0;
      NumMinor := 0;
      NumRelease := 0;
      NumBuild := 0;
      PrVersMSHi := 0;
      PrVersMSLo := 0;
      PrVersLSHi := 0;
      PrVersLSLo := 0;
    end;

    VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
    GetMem(PVerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
        if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
          with PVerValue^ do
          begin
            Result := Format('v%d.%d.%d build %d', [
              HiWord(dwFileVersionMS), //Major
              LoWord(dwFileVersionMS), //Minor
              HiWord(dwFileVersionLS), //Release
              LoWord(dwFileVersionLS)]); //Build

            MyFileRec.NumMajor := HiWord(dwFileVersionMS);
            MyFileRec.NumMinor := LoWord(dwFileVersionMS);
            MyFileRec.NumRelease := HiWord(dwFileVersionLS);
            MyFileRec.NumBuild := LoWord(dwFileVersionLS);
            MyFileRec.PrVersMSHi := HiWord(dwProductVersionMS);
            MyFileRec.PrVersMSLo := LoWord(dwProductVersionMS);
            MyFileRec.PrVersLSHi := HiWord(dwProductVersionLS);
            MyFileRec.PrVersLSLo := LoWord(dwProductVersionLS);
          end;
    finally
      FreeMem(PVerInfo, VerInfoSize);
    end;
  end;
begin
  Label6.Caption:= Format('Full version info: %s', [FileVersion(Application.ExeName, FileVersInfo)]);
  Label1.Caption:= Format('System.GetFileVersion: %d.%d',
                        [HiWord(GetFileVersion(Application.ExeName)),
                        LoWord(GetFileVersion(Application.ExeName))]);
  Label2.Caption:= Format('Major: %d',[FileVersInfo.NumMajor]);
  Label3.Caption:= Format('Minor: %d',[FileVersInfo.NumMinor]);
  Label4.Caption:= Format('Release: %d',[FileVersInfo.NumRelease]);
  Label5.Caption:= Format('Build: %d',[FileVersInfo.NumBuild]);
  Label7.Caption:= Format('PrVersMSHi: %d',[FileVersInfo.PrVersMSHi]);
  Label8.Caption:= Format('PrVersMSLo: %d',[FileVersInfo.PrVersMSLo]);
  Label9.Caption:= Format('PrVersLSHi: %d',[FileVersInfo.PrVersLSHi]);
  Label10.Caption:= Format('PrVersLSLo: %d',[FileVersInfo.PrVersLSLo]);
end;

end.
