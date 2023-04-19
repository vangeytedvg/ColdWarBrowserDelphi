unit frmAddLink;

interface

uses
	System.SysUtils, System.Types, System.UITypes, System.Classes,
	System.Variants,
	FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
	FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Edit, FMX.Objects;

const
		NEWSTATE = 0;
		EDITSTATE = 1;

type
	TAddLinkForm = class(TForm)
		ComboBox1: TComboBox;
		ListBoxItem1: TListBoxItem;
		ListBoxItem2: TListBoxItem;
		ListBoxItem3: TListBoxItem;
		ListBoxItem4: TListBoxItem;
		ListBoxItem5: TListBoxItem;
		ListBoxItem6: TListBoxItem;
		LblState: TLabel;
		LblCategory: TLabel;
		StyleBook1: TStyleBook;
		LblDescription: TLabel;
		EdtDescription: TEdit;
    btnOk: TButton;
		Button2: TButton;
    Image1: TImage;
		procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
	private
		{ Private declarations }
		FState: Integer;
	public
		{ Public declarations }
		property States: Integer read FState write FSTate;
	end;

var
	AddLinkForm: TAddLinkForm;

implementation

{$R *.fmx}

procedure TAddLinkForm.btnOkClick(Sender: TObject);
begin
  if (EdtDescription.Text = String.Empty) or (ComboBox1.Selected.Text = String.Empty) then
  begin
    ShowMessage('No description or Category');
    Abort;
  end;
end;

procedure TAddLinkForm.FormCreate(Sender: TObject);
// Check what the state of the form is
begin
	if States = NEWSTATE then
		LblState.Text := 'Create New Link'
	else if States = EDITSTATE then
		LblState.Text := 'Edit existing Link';
end;

end.
