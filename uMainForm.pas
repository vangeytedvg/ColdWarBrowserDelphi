unit uMainForm;

interface

uses
	Winapi.Windows, System.SysUtils, System.Types, System.UITypes,
	System.Classes, System.Variants, Winapi.Messages,
	FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
	FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
	UWVLoader, UWVBrowserBase, UWVFMXBrowser, UWVFMXWindowParent, UWVTypeLibrary,
	UWVTypes, FMX.SearchBox, FMX.ListBox, FireDAC.Stan.Intf, FireDAC.Stan.Option,
	FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
	FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
	FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
	FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
	FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.Bind.EngExt,
	Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors,
	Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.Components,
	Data.Bind.DBScope, FMX.TabControl, FMX.DialogService, FMX.Objects,
	System.IniFiles, ShellAPI, ShlObj, System.IOUtils, FMX.Menus, FMX.Effects;

const
	WEBVIEW2_SHOWBROWSER = WM_APP + $101;

type
	TMainForm = class(TForm)
		AddressEdt: TEdit;
		GoBtn: TButton;
		WVFMXBrowser1: TWVFMXBrowser;
		Timer1: TTimer;
		AddressLay: TLayout;
		StatusBar1: TStatusBar;
		StatusLbl: TLabel;
		ListBoxDescription: TListBox;
		SearchBox1: TSearchBox;
		StyleBook1: TStyleBook;
		Header: TToolBar;
		HeaderLabel: TLabel;
		BtnSaveLink: TButton;
		Panel1: TPanel;
		BrowserLay: TLayout;
		FocusWorkaroundBtn: TButton;
		BtnDeleteSelectedListItem: TButton;
		BtnEditSelectedLink: TButton;
		BtnClearAddress: TButton;
		BtnInfo: TButton;
		MainMenu1: TMainMenu;
		MenuItem1: TMenuItem;
		MenuItem2: TMenuItem;
		BtnReload: TButton;
		MnuItemReport: TMenuItem;
		MnuItemGroupAll: TMenuItem;
		MnuClearCache: TMenuItem;
		MenuItem3: TMenuItem;
		MnuPrint: TMenuItem;
		MnuPrintToPDF: TMenuItem;
		MenuItem4: TMenuItem;
		Splitter1: TSplitter;
		FDQueryGeneric: TFDQuery;
		FDConnection1: TFDConnection;
		FDQueryDeleteItem: TFDQuery;
		FDQueryGetArticle: TFDQuery;
		FDQueryUpdateLink: TFDQuery;
		FDQueryGetLink: TFDQuery;
		FDQueryInsertNewLink: TFDQuery;
		FDQueryFullReport: TFDQuery;
		BindSourceDB1: TBindSourceDB;
		FDQuery2: TFDQuery;
		BindingsList1: TBindingsList;
		LinkListControlToField1: TLinkListControlToField;
		ShadowEffect1: TShadowEffect;
		BtnBack: TButton;
		Button1: TButton;
		Button2: TButton;
		Edit1: TEdit;
		procedure FormCreate(Sender: TObject);
		procedure FormResize(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure Timer1Timer(Sender: TObject);
		procedure GoBtnClick(Sender: TObject);
		procedure WVFMXBrowser1AfterCreated(Sender: TObject);
		procedure WVFMXBrowser1InitializationError(Sender: TObject;
			AErrorCode: HRESULT; const AErrorMessage: Wvstring);
		procedure WVFMXBrowser1GotFocus(Sender: TObject);
		procedure WVFMXBrowser1StatusBarTextChanged(Sender: TObject;
			const AWebView: ICoreWebView2);
		procedure ListBoxDescriptionItemClick(const Sender: TCustomListBox;
			const Item: TListBoxItem);
		procedure BtnSaveLinkClick(Sender: TObject);
		procedure BtnDeleteSelectedListItemClick(Sender: TObject);
		procedure BtnClearAddressClick(Sender: TObject);
		procedure BtnEditSelectedLinkClick(Sender: TObject);
		procedure BtnInfoClick(Sender: TObject);
		procedure WVFMXBrowser1NavigationCompleted(Sender: TObject;
			const AWebView: ICoreWebView2;
			const AArgs: ICoreWebView2NavigationCompletedEventArgs);
		procedure FormClose(Sender: TObject; var Action: TCloseAction);
		procedure MenuItem2Click(Sender: TObject);
		procedure BtnReloadClick(Sender: TObject);
		procedure MnuClearCacheClick(Sender: TObject);
		procedure MnuPrintToPDFClick(Sender: TObject);
		procedure BtnBackClick(Sender: TObject);
		procedure Button1Click(Sender: TObject);
		procedure Button2Click(Sender: TObject);
		procedure MnuItemGroupAllClick(Sender: TObject);

	private
		FMXWindowParent: TWVFMXWindowParent;
		FCustomWindowState: TWindowState;
		FOldWndPrc: TFNWndProc;
		FFormStub: Pointer;
		///
		/// ColdWar
		///
		FLinkID: Integer;
		FListITEM: TListBoxItem;
		FLinkCategory: string;
		FLinkDescription: string;
		FLinkURL: string;
		FArticleID: Integer;
		FArticleText: string;
		procedure LoadArticle(ArticleId: Integer);
		function GetArticleContent(LinkId: Integer): string;
		///
		///
		procedure LoadURL;
		procedure ResizeChild;
		procedure CreateFMXWindowParent;
		function GetFMXWindowParentRect: System.Types.TRect;
		function PostCustomMessage(AMsg: Cardinal; AWParam: WPARAM = 0;
			ALParam: LPARAM = 0): Boolean;
		function GetCurrentWindowState: TWindowState;
		procedure UpdateCustomWindowState;
		procedure CustomWndProc(var AMessage: TMessage);
		function GetDocumentsDirectory: string;
	public
		procedure CreateHandle; override;
		procedure DestroyHandle; override;
		procedure NotifyMoveOrResizeStarted;
		procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
			AHeight: Integer); override;
	end;

var
	MainForm: TMainForm;

implementation

{$R *.fmx}

// This is a simple browser in normal mode in a Firemonkey application.
// This demo uses a TWVFMXBrowser and a TWVFMXWindowParent. It replaces the original WndProc with a
// custom CustomWndProc procedure to handle Windows messages.
uses
	FMX.Platform, FMX.Platform.Win, FrmAddLink, FrmDetailsEditor, frmAllLinks;

function TMainForm.GetDocumentsDirectory: string;
var
	Path: array [0 .. MAX_PATH] of Char;
begin
	// Call SHGetFolderPath to retrieve the documents directory path
	if Succeeded(SHGetFolderPath(0, CSIDL_MYDOCUMENTS, 0, 0, @Path[0])) then
		Result := Path
	else
		Result := '';
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
// Save the position and size of this form
var
	Inifile: Tinifile;
begin
	IniFile := TIniFile.Create(TPath.Combine(GetDocumentsDirectory,
		'COLDWARsettings.ini'));
	FDConnection1.Close;
	try
		// Save the form's position and size to the INI file
		IniFile.WriteInteger('MainForm', 'Left', Left);
		IniFile.WriteInteger('MainForm', 'Top', Top);
		IniFile.WriteInteger('MainForm', 'Width', Width);
		IniFile.WriteInteger('MainForm', 'Height', Height);
	finally
		// Free the INI file instance
		IniFile.Free;
	end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
	IniFile: TIniFile;
begin
	FMXWindowParent := nil;
	FCustomWindowState := WindowState;
	FDConnection1.Connected := True;
	FDQuery2.Active := True;
	FLinkID := 0;
	FListITEM := nil;
	FLinkCategory := '';
	FLinkDescription := '';
	FLinkURL := '';
	// Create an INI file instance
	IniFile := TIniFile.Create(TPath.Combine(GetDocumentsDirectory,
		'COLDWARsettings.ini'));
	try
		// Read the form's position and size from the INI file and restore it
		Left := IniFile.ReadInteger('MainForm', 'Left', Left);
		Top := IniFile.ReadInteger('MainForm', 'Top', Top);
		Width := IniFile.ReadInteger('MainForm', 'Width', Width);
		Height := IniFile.ReadInteger('MainForm', 'Height', Height);
	finally
		// Free the INI file instance
		IniFile.Free;
	end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
	ResizeChild;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
	TempHandle: HWND;
	IniFile: TIniFile;
begin
	// TFMXWindowParent has to be created at runtime
	CreateFMXWindowParent;
	// You *MUST* call CreateBrowser to create and initialize the browser.
	// This will trigger the AfterCreated event when the browser is fully
	// initialized and ready to receive commands.
	if GlobalWebView2Loader.InitializationError then
		Showmessage(GlobalWebView2Loader.ErrorMessage)
	else if GlobalWebView2Loader.Initialized then
	begin
		TempHandle := FmxHandleToHWND(FMXWindowParent.Handle);
		WVFMXBrowser1.DefaultUrl := AddressEdt.Text;
		if not(WVFMXBrowser1.CreateBrowser(TempHandle)) then
			Timer1.Enabled := True;
	end;

	FDQuery2.Open;

end;

function TMainForm.PostCustomMessage(AMsg: Cardinal; AWParam: WPARAM;
	ALParam: LPARAM): Boolean;
var
	TempHWND: HWND;
begin
	TempHWND := FmxHandleToHWND(Handle);
	Result := (TempHWND <> 0) and WinApi.Windows.PostMessage(TempHWND, AMsg,
		AWParam, ALParam);
end;

procedure TMainForm.GoBtnClick(Sender: TObject);
begin
	LoadURL;
end;

procedure TMainForm.ResizeChild;
begin
	if (FMXWindowParent <> nil) then
	begin
		FMXWindowParent.SetBounds(GetFMXWindowParentRect);
		FMXWindowParent.UpdateSize;
	end;
end;

/// --///////////////////////////////////////////////////////////////////////////
procedure TMainForm.BtnDeleteSelectedListItemClick(Sender: TObject);
// Delete the selected item in the link listbox
var
	DelItem: TListBoxItem;
	Id: Integer;
	BResult: TModalResult;
begin
	DelItem := ListBoxDescription.Selected;
	Id := DelItem.ImageIndex;
	TDialogService.MessageDialog('Delete link : ' + DelItem.Text + '?',
		System.UITypes.TMsgDlgType.MtInformation, [System.UITypes.TMsgDlgBtn.MbYes,
		System.UITypes.TMsgDlgBtn.MbNo, System.UITypes.TMsgDlgBtn.MbCancel],
		System.UITypes.TMsgDlgBtn.MbYes, 0,

		// Use an anonymous method to make sure the acknowledgment appears as expected.
		procedure(const AResult: TModalResult)
		begin
			case AResult of
				{ Detect which button was pushed and show a different message }
				MrYES:
					begin
						FDQuery2.Close;
						FDQueryDeleteItem.ParamByName('id').AsInteger := Id;
						FDQueryDeleteItem.ExecSQL;
						FDQuery2.Open
					end;
				MrNo:
					Exit;
				MrCancel:
					Exit;
			end;
		end);
end;

procedure TMainForm.BtnEditSelectedLinkClick(Sender: TObject);
// Edit a selected link
var
	S: string;
	UpdItem: TListBoxItem;
	IId: Integer;
begin
	AddLinkForm.States := 1;
	// UpdItem := ListBoxDescription.Selected;
	// IId := UpdItem.ImageIndex;
	AddLinkForm.EdtDescription.Text := FListITEM.Text;
	Iid := FListITEM.ImageIndex;
	if AddLinkForm.ShowModal = Mrok then
	begin
		try
			FDQuery2.Close;
			FDQueryUpdateLink.Prepare;
			FDQueryUpdateLink.Params.ParamByName('Adescription').AsString :=
				AddlinkForm.EdtDescription.Text;
			FDQueryUpdateLink.Params.ParamByName('Acategory').Asstring :=
				AddLinkForm.ComboBox1.Selected.Text;
			FDQueryUpdateLink.Params.ParamByName('Aid').AsInteger := IId;
			FDQueryUpdateLink.ExecSQL;
			FDQuery2.Open;
		except
			on E: Exception do
			begin
				ShowMessage(E.Message);
			end;
		end;
	end;
end;

procedure TMainForm.BtnInfoClick(Sender: TObject);
// Edit the information about a link
// Insert or UPDATE it.
var
	FoundArt: Boolean;
	ArticleBody: string;
	SQLstr: string;
	QRY: TFDQuery;
begin
	// Article Selected?
	// FormDetailsEditor.MemoArticle.Text := '';
	// FormDetailsEditor.IsDirty := False;
	if FLinkId = 0 then
	begin
		ShowMessage('Please choose an article first!');
		Exit;
	end;
	FormDetailsEditor.LinkID := FLinkID;
	FormDetailsEditor.LblArticle.Text := FLinkDescription + ' in -<[' +
		FLinkCategory + ']>-';
	if GetArticleContent(FLinkID) = 'FOUND' then
	// UPDATE
	begin
		FoundArt := True;
		FormDetailsEditor.MemoArticle.Text := FArticleText;
		FormDetailsEditor.IsDirty := False;
	end
	else if GetArticleContent(FLinkID) = 'NONE' then
	begin
		FoundArt := False;
		FormDetailsEditor.MemoArticle.Text := '';
		FormDetailsEditor.IsDirty := False;
	end;
	if FormDetailsEditor.ShowModal = MrOk then
	begin
		ArticleBody := FormDetailsEditor.MemoArticle.Text;
		// Save or update the article
		if FoundArt then
		begin
			// Update record
			FDQuery2.Close;
			QRY := TFDQuery.Create(nil);
			try
				SQLstr := 'UPDATE LinkDetails SET ArticleText = ' + QuotedStr(ArticleBody) +
					' WHERE LinkID =' + IntToStr(FLinkId);
				Edit1.Text := Sqlstr;
				QRY.SQL.Add(SQLstr);
				QRY.Connection := FDConnection1;
				QRY.ExecSQL;
				FDQuery2.Open;
			finally
				QRY.Free;
			end;
		end
		else
		begin
			// Insert Record
			FDQuery2.Close;
			SQLstr := 'INSERT INTO LinkDetails (LinkId, ArticleText) VALUES (:myLinkId, :myArticleBody)';
			FDQueryGeneric.SQL.Text := SQLstr;
			FDQueryGeneric.ParamByName('myLinkId').AsInteger := FLinkId;
			FDQueryGeneric.ParamByName('myArticleBody').AsString := ArticleBody;
			FDQueryGeneric.ExecSQL;
			ShowMessage('New Record inserted');
			FDQuery2.Open;
		end;
	end;
end;

function TMainForm.GetArticleContent(LinkId: Integer): string;
var
	ArticleText: string;
begin
	FDQueryGetArticle.Close;
	FDQueryGetArticle.ParamByName('myLinkID').AsInteger := LinkId;

	FDQueryGetArticle.Open;
	if FDQueryGetArticle.RecordCount > 0 then
	begin
		FArticleID := FDQueryGetArticle.FieldByName('ID').Value;
		FArticleText := FDQueryGetArticle.FieldByName('ArticleText').Value;
		Result := 'FOUND';
	end
	else
	begin
		Result := 'NONE';
	end;
end;

procedure TMainForm.BtnSaveLinkClick(Sender: TObject);
// Add a new link to the database
var
	S: string;
begin
	AddLinkForm.States := 0;
	if AddLinkForm.ShowModal = Mrok then
	begin
		try
			FDQuery2.Close;
			// FDConnection1.Close;
			// FDConnection1.Open;
			FDQueryInsertNewLink.Params.ParamByName('mylink').AsString :=
				AddressEdt.Text;
			FDQueryInsertNewLink.Params.ParamByName('mydescription').AsString :=
				AddLinkForm.EdtDescription.Text;
			FDQueryInsertNewLink.Params.ParamByName('mycategory').AsString :=
				AddLinkForm.ComboBox1.Items[AddLinkForm.Combobox1.ItemIndex];
			FDQueryInsertNewLink.Prepare;
			FDQueryInsertNewLink.ExecSQL;
			FDQuery2.Open;
			StatusLbl.Text := 'Record Saved';
		except
			on E: Exception do
			begin
				ShowMessage(E.Message);
			end;
		end;
	end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
	if WVFMXBrowser1.CanGoForward then
		WVFMXBrowser1.GoForward;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
	WVFMXBrowser1.Navigate('https://www.google.be');
end;

procedure TMainForm.BtnReloadClick(Sender: TObject);
// Reload the current page
begin
	WVFMXBrowser1.Refresh;

end;

procedure TMainForm.BtnBackClick(Sender: TObject);
begin
	if WVFMXBrowser1.CanGoBack then
		WVFMXBrowser1.GoBack
end;

procedure TMainForm.BtnClearAddressClick(Sender: TObject);
begin
	AddressEdt.Text := '';
end;

procedure TMainForm.CreateFMXWindowParent;
begin
	if (FMXWindowParent = nil) then
	begin
		FMXWindowParent := TWVFMXWindowParent.CreateNew(nil);
		FMXWindowParent.Browser := WVFMXBrowser1;
		FMXWindowParent.Reparent(Handle);
		ResizeChild;
		FMXWindowParent.Show;
	end;
end;

function TMainForm.GetFMXWindowParentRect: System.Types.TRect;
begin
	Result.Left := Round(BrowserLay.Position.X);
	Result.Top := Round(BrowserLay.Position.Y);
	Result.Right := Round(Result.Left + BrowserLay.Width);
	Result.Bottom := Round(Result.Top + BrowserLay.Height);
end;

procedure TMainForm.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
	PositionChanged: Boolean;
begin
	PositionChanged := (ALeft <> Left) or (ATop <> Top);
	inherited SetBounds(ALeft, ATop, AWidth, AHeight);
	if PositionChanged then
		NotifyMoveOrResizeStarted;
end;

procedure TMainForm.NotifyMoveOrResizeStarted;
begin
	if (WVFMXBrowser1 <> nil) then
		WVFMXBrowser1.NotifyParentWindowPositionChanged;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
	TempHandle: HWND;
begin
	Timer1.Enabled := False;
	TempHandle := FmxHandleToHWND(FMXWindowParent.Handle);
	if not(WVFMXBrowser1.CreateBrowser(TempHandle)) then
		Timer1.Enabled := True;
end;

procedure TMainForm.ListBoxDescriptionItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
var
	LinkUrl, ResultUrl: string;
	Id: Integer;
begin
	BtnDeleteSelectedListItem.Enabled := True;
	BtnEditSelectedLink.Enabled := True;
	Id := Item.ImageIndex;
	// Global
	FLinkID := Id;
	FListITEM := Item;
	LoadArticle(Id);
	AddressEdt.Text := FLinkURL;
	// LoadURL;
end;

procedure TMainForm.LoadArticle(ArticleId: Integer);
// Get the current article details and set variables
begin
	try
		// Assign the current id to the select query
		FDQueryGetLink.ParamByName('id').AsInteger := ArticleId;
		FDQueryGetLink.Command.CommandKind := SkSelect;
		FDQueryGetLink.Close;
		FDQueryGetLink.Open;
		if FDQueryGetLink.RecordCount > 0 then
		begin
			FLinkURL := FDQueryGetLink.FieldByName('link').Value;
			FLinkDescription := FDQueryGetLink.FieldByName('description').Value;
			FLinkCategory := FDQueryGetLink.FieldByName('category').Value;
		end;
	except
		on E: Exception do
		begin
			ShowMessage(E.Message);
		end;
	end;
end;

procedure TMainForm.LoadURL;
begin
	WVFMXBrowser1.Navigate(AddressEdt.Text);
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
	Application.Terminate;
end;

procedure TMainForm.MnuClearCacheClick(Sender: TObject);
var
	BResult: TModalResult;
begin
	TDialogService.MessageDialog('Clear Cache?',
		System.UITypes.TMsgDlgType.MtInformation, [System.UITypes.TMsgDlgBtn.MbYes,
		System.UITypes.TMsgDlgBtn.MbNo, System.UITypes.TMsgDlgBtn.MbCancel],
		System.UITypes.TMsgDlgBtn.MbYes, 0,

	// Use an anonymous method to make sure the acknowledgment appears as expected.
		procedure(const AResult: TModalResult)
		begin
			case AResult of
				{ Detect which button was pushed and show a different message }
				MrYES:
					begin
						WVFMXBrowser1.ClearCache;
					end;
				MrNo:
					Exit;
				MrCancel:
					Exit;
			end;
		end);
end;

procedure TMainForm.MnuItemGroupAllClick(Sender: TObject);
// Make a report of all comments found
var
	S: string;
  Qry: TFDQuery;
  OldCategory : string;
begin
  Qry := TFDQuery.Create(nil);
	S := 'SELECT Links.Description, Links.Category, Links.Link, LinkDetails.ArticleText ' +
	'FROM Links LEFT JOIN LinkDetails ON Links.Id = LinkDetails.LinkId ORDER BY Links.Category';
  try
  	Qry.Connection := FDConnection1;
    Qry.Open(s);

    while not Qry.Eof do
    begin
      if OldCategory <> Qry.FieldByName('Category').AsString then
      begin
        FrmAll.MemoAll.Lines.Add(Qry.FieldByName('Category').AsString + sLineBreak);
        // Draw a line
        FrmAll.MemoAll.Lines.Add(StringOfChar('-', 80));
        OldCategory :=Qry.FieldByName('Category').AsString;
      end;
      FrmAll.MemoAll.Lines.Add(Qry.FieldByName('Description').AsString + sLineBreak);
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;


  FrmAll.Show;
end;

procedure TMainForm.MnuPrintToPDFClick(Sender: TObject);
begin
	WVFMXBrowser1.CoreWebView2PrintSettings.ShouldPrintBackgrounds := True;
	WVFMXBrowser1.ShowPrintUI(True);
end;

procedure TMainForm.CreateHandle;
begin
	inherited CreateHandle;
	FFormStub := MakeObjectInstance(CustomWndProc);
	FOldWndPrc := TFNWndProc(SetWindowLongPtr(FmxHandleToHWND(Handle),
		GWLP_WNDPROC, NativeInt(FFormStub)));
end;

procedure TMainForm.DestroyHandle;
begin
	SetWindowLongPtr(FmxHandleToHWND(Handle), GWLP_WNDPROC,
		NativeInt(FOldWndPrc));
	FreeObjectInstance(FFormStub);
	inherited DestroyHandle;
end;

procedure TMainForm.CustomWndProc(var AMessage: TMessage);
const
	SWP_STATECHANGED = $8000; // Undocumented
var
	TempWindowPos: PWindowPos;
begin
	try
		case AMessage.Msg of
			WM_MOVE, WM_MOVING:
				NotifyMoveOrResizeStarted;
			WM_SIZE:
				if (AMessage.WParam = SIZE_RESTORED) then
					UpdateCustomWindowState;
			WM_WINDOWPOSCHANGING:
				begin
					TempWindowPos := TWMWindowPosChanging(AMessage).WindowPos;
					if ((TempWindowPos.Flags and SWP_STATECHANGED) <> 0) then
						UpdateCustomWindowState;
				end;
			WM_SHOWWINDOW:
				if (AMessage.WParam <> 0) and (AMessage.LParam = SW_PARENTOPENING) then
					PostCustomMessage(WEBVIEW2_SHOWBROWSER);
			WEBVIEW2_SHOWBROWSER:
				if (FMXWindowParent <> nil) then
				begin
					FMXWindowParent.WindowState := TWindowState.WsNormal;
					ResizeChild;
				end;
		end;
		AMessage.Result := CallWindowProc(FOldWndPrc, FmxHandleToHWND(Handle),
			AMessage.Msg, AMessage.WParam, AMessage.LParam);
	except
		on E: Exception do
			Log.D('TMainForm.CustomWndProc error : ' + E.Message);
	end;
end;

procedure TMainForm.UpdateCustomWindowState;
var
	TempNewState: TWindowState;
begin
	TempNewState := GetCurrentWindowState;
	if (FCustomWindowState <> TempNewState) then
	begin
		if (FCustomWindowState = TWindowState.WsMinimized) then
			PostCustomMessage(WEBVIEW2_SHOWBROWSER);
		FCustomWindowState := TempNewState;
	end;
end;

procedure TMainForm.WVFMXBrowser1AfterCreated(Sender: TObject);
begin
	FMXWindowParent.UpdateSize;
	Caption := 'Database Ready';
	AddressLay.Enabled := True;
end;

procedure TMainForm.WVFMXBrowser1GotFocus(Sender: TObject);
begin
	// We use a hidden button to fix the focus issues when the browser has the real focus.
	FocusWorkaroundBtn.SetFocus;
end;

procedure TMainForm.WVFMXBrowser1InitializationError(Sender: TObject;
AErrorCode: HRESULT; const AErrorMessage: Wvstring);
begin
	Showmessage(AErrorMessage);
end;

procedure TMainForm.WVFMXBrowser1NavigationCompleted(Sender: TObject;
const AWebView: ICoreWebView2;
const AArgs: ICoreWebView2NavigationCompletedEventArgs);
// ******************************************************************************
// NOTE: HAD THIS CHANGE THIS TO KEEP TRACK OF THE URL IF THE USER
// CLICKS ON A LINK AND THE PAGE CHANGES
var
	S: Pwidechar;
begin
	AWebView.Get_Source(S);
	AddressEdt.TExt := S;
end;

procedure TMainForm.WVFMXBrowser1StatusBarTextChanged(Sender: TObject;
const AWebView: ICoreWebView2);
begin
	StatusLbl.Text := WVFMXBrowser1.StatusBarText;
end;

function TMainForm.GetCurrentWindowState: TWindowState;
var
	TempPlacement: TWindowPlacement;
	TempHWND: HWND;
begin
	// TForm.WindowState is not updated correctly in FMX forms.
	// We have to call the GetWindowPlacement function in order to read the window state correctly.
	Result := TWindowState.WsNormal;
	TempHWND := FmxHandleToHWND(Handle);
	ZeroMemory(@TempPlacement, SizeOf(TWindowPlacement));
	TempPlacement.Length := SizeOf(TWindowPlacement);
	if GetWindowPlacement(TempHWND, @TempPlacement) then
		case TempPlacement.ShowCmd of
			SW_SHOWMAXIMIZED:
				Result := TWindowState.WsMaximized;
			SW_SHOWMINIMIZED:
				Result := TWindowState.WsMinimized;
		end;
	if IsIconic(TempHWND) then
		Result := TWindowState.WsMinimized;
end;

initialization

GlobalWebView2Loader := TWVLoader.Create(nil);
GlobalWebView2Loader.UserDataFolder := ExtractFileDir(ParamStr(0)) +
	'\CustomCache';
GlobalWebView2Loader.StartWebView2;

end.
