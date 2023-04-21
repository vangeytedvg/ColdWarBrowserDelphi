program SimpleFMXBrowser;
uses
  System.StartUpCopy,
  FMX.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  frmAddLink in 'frmAddLink.pas' {AddLinkForm},
  frmDetailsEditor in 'frmDetailsEditor.pas' {FormDetailsEditor},
  frmAllLinks in 'frmAllLinks.pas' {FrmAll};

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAddLinkForm, AddLinkForm);
  Application.CreateForm(TFormDetailsEditor, FormDetailsEditor);
  Application.CreateForm(TFrmAll, FrmAll);
  Application.Run;
end.
