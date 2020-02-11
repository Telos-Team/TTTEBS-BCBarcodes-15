codeunit 80282 "TTTEBS-BCBarcodeURL"
{
    procedure CreateBarcode(var pBarcodeEntries: Record "TTTEBS-BCBarcodeEntries"; pRecID: RecordId; pValue: Code[20]; pType: Code[20]; pBarcodeType: Code[20]; pHeight: Integer; pWidth: Integer; pWithText: Boolean)
    var
        lr_Barcode: Record "TTTEBS-BCBarcode";
        lv_SysID: Guid;
        lv_TableID: Integer;
        lv_Handled: Boolean;
        ErrMustNotBeBlankLbl: Label '%1 Value must not be blank!';
    begin
        if pValue = '' then
            error(StrSubstNo(ErrMustNotBeBlankLbl, 'Value'));

        if pBarcodeType = '' then
            error(StrSubstNo(ErrMustNotBeBlankLbl, 'Barcode Type'));

        // Find System ID, from called Record ID (use for finding or creating barcode)..
        lv_SysID := GetSystemIDFromRecordID(pRecID);
        lv_TableID := GetTableIDFromRecordID(pRecID);

        // Find or Create in Table "BarCode" (PKEY -> Table ID + Link SID)
        CreateBarcode(lr_Barcode, lv_TableID, lv_SysID, pRecID);

        // Find or Create in Table "BarCodeEntries" (PKEY -> Link SID + Entry No)
        lv_SysID := GetSystemIDFromRecordID(lr_Barcode.RecordId);
        if CreateBarcodeEntries(pBarcodeEntries,
                                    lv_SysID,
                                    pValue,
                                    pType,
                                    pBarcodeType,
                                    pHeight,
                                    pWidth,
                                    pWithText
                                    ) then
            lv_Handled := true;

        OnBeforeCreateBarCode(pBarcodeEntries, lv_Handled);
        DoCreateBarCode(pBarcodeEntries, lv_Handled);
        OnAfterCreateBarCode(pBarcodeEntries);
    end;

    local procedure DoCreateBarCode(var pBarcodeEntries: Record "TTTEBS-BCBarcodeEntries"; var Handled: Boolean);
    var
        lr_BarcodeType: Record "TTTEBS-BCBarcodeType";
        lv_HttpClient: HttpClient;
        lv_HttpRequestMessage: HttpRequestMessage;
        lv_HttpResponseMessage: HttpResponseMessage;
        lv_InStream: InStream;
        lv_OutStream: OutStream;
        lv_Method: Text;
        CallFailedLbl: Label 'Barcode could not be created! (Service down)';
    begin
        if Handled then
            exit;

        lr_BarcodeType.get(pBarcodeEntries."Barcode Type");
        lv_Method := StrSubstNo(lr_BarcodeType.URL, pBarcodeEntries."Barcode Value");

        lv_HttpRequestMessage.SetRequestUri(lv_Method);
        if not lv_HttpClient.Send(lv_HttpRequestMessage, lv_HttpResponseMessage) then
            Error(CallFailedLbl);
        lv_HttpResponseMessage.Content().ReadAs(lv_InStream);
        pBarcodeEntries.Barcode.CreateOutStream(lv_OutStream);
        CopyStream(lv_OutStream, lv_InStream);
        pBarcodeEntries.Modify(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateBarCode(var pBarcodeEntries: Record "TTTEBS-BCBarcodeEntries"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateBarCode(var pBarcodeEntries: Record "TTTEBS-BCBarcodeEntries");
    begin
    end;

    procedure GetSystemIDFromRecordID(pRecID: RecordId): Guid;
    var
        lr_RR: Recordref;
    begin
        lr_RR := pRecID.GetRecord();
        if lr_RR.Find('=') then
            exit(format(lr_RR.Field(lr_RR.SystemIdNo()).Value()));
    end;

    procedure GetTableIDFromRecordID(pRecID: RecordId): Integer;
    var
        lr_RR: Recordref;
    begin
        lr_RR := pRecID.GetRecord();
        exit(lr_RR.Number);
    end;

    procedure CreateBarcode(var pBarcode: Record "TTTEBS-BCBarcode"; pTableID: Integer; pSysID: Guid; pRecID: RecordId);
    begin
        with pBarcode do begin
            SetRange("Table ID", pTableID);
            SetRange("Link SID", pSysID);
            if FindFirst() then
                exit;

            Init();
            "Table ID" := pTableID;
            "Link SID" := pSysID;
            "Link Record ID" := Format(pRecID);
            Insert(true);
        end;
    end;

    procedure CreateBarcodeEntries(var pBarcodeEntries: Record "TTTEBS-BCBarcodeEntries"; pSysID: Guid; pValue: Code[20]; pType: Code[20]; pBarcodeType: Code[20]; pHeight: Integer; pWidth: Integer; pWithText: Boolean): Boolean;
    var
        lv_NextEntryNo: Integer;
    begin
        with pBarcodeEntries do begin
            SetRange("Link SID", pSysID);
            SetRange("Barcode Value", pValue);

            SetRange(Type, pType);
            SetRange("Barcode Type", pBarcodeType);
            SetRange(Height, pHeight);
            SetRange(Width, pWidth);
            SetRange("With Text", pWithText);

            if FindFirst() then begin
                CalcFields(Barcode);
                exit(true);
            end;

            SetRange("Barcode Value");
            SetRange(Type);
            SetRange("Barcode Type");
            SetRange(Height);
            SetRange(Width);
            SetRange("With Text");
            if FindLast() then
                lv_NextEntryNo := "Entry No.";
            lv_NextEntryNo += 1;

            Init();
            "Link SID" := pSysID;
            "Entry No." := lv_NextEntryNo;

            Type := pType;
            "Barcode Type" := pBarcodeType;
            Height := pHeight;
            Width := pWidth;
            "With Text" := pWithText;
            "Barcode Value" := pValue;
            Insert(true);
        end;
    end;
}