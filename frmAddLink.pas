unit frmAddLink;

interface

uses
	System.SysUtils, System.Types, System.UITypes, System.Classes,
	System.Variants,
	FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
	FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, FMX.Edit, FMX.Objects,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.DBScope;

const
	NEWSTATE = 0;
	EDITSTATE = 1;

type
	TAddLinkForm = class(TForm)
		ComboBox1: TComboBox;
		LblState: TLabel;
		LblCategory: TLabel;
		StyleBook1: TStyleBook;
		LblDescription: TLabel;
		EdtDescription: TEdit;
		BtnOk: TButton;
		Button2: TButton;
		Image1: TImage;
    BindSourceCategories: TBindSourceDB;
    FDTableCategories: TFDTable;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
		procedure BtnOkClick(Sender: TObject);
		procedure FormShow(Sender: TObject);
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

uses
	Umainform;

{$R *.fmx}

procedure TAddLinkForm.BtnOkClick(Sender: TObject);
begin
	if (EdtDescription.Text = string.Empty) or
		(ComboBox1.Selected.Text = string.Empty) then
	begin
		ShowMessage('No description or Category');
		Abort;
	end;
end;

procedure TAddLinkForm.FormShow(Sender: TObject);
begin
  FDTableCategories.Active:=True;
	if States = NEWSTATE then
		LblState.Text := 'Create New Link'
	else if States = EDITSTATE then
		LblState.Text := 'Edit existing Link';
end;

end.
