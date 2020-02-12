codeunit 80282 "TTT-EBS-BCBarcodeURL"
{
    procedure CreateBarcode(var pBarcodeEntries: Record "TTT-EBS-BCBarcodeEntries"; pRecID: RecordId; pValue: Code[20]; pType: Code[20]; pBarcodeType: Code[20]; pHeight: Integer; pWidth: Integer; pWithText: Boolean)
    var
        lr_Barcode: Record "TTT-EBS-BCBarcode";
        lv_SysID: Guid;
        lv_TableID: Integer;
        lv_Handled: Boolean;
        ErrValueMustNotBeBlankLbl: Label 'Value Value must not be blank!';
        ErrBarcodeTypeMustNotBeBlankLbl: Label 'Barcode Type must not be blank!';
    begin
        if pValue = '' then
            error(ErrValueMustNotBeBlankLbl);

        if pBarcodeType = '' then
            error(ErrBarcodeTypeMustNotBeBlankLbl);

        // Find System ID, from called Record ID (use for finding or creating barcode)..
        lv_SysID := GetSystemIDFromRecordID(pRecID);
        lv_TableID := GetTableIDFromRecordID(pRecID);

        // Find or Create in Table "BarCode" (PKEY -> Table ID + Link SID)
        CreateBarcode(lr_Barcode, lv_TableID, lv_SysID, pRecID);

        // Find or Create in Table "BarCodeEntries" (PKEY -> Link SID + Entry No)
        lv_SysID := GetSystemIDFromRecordID(lr_Barcode.RecordId());
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

    local procedure DoCreateBarCode(var pBarcodeEntries: Record "TTT-EBS-BCBarcodeEntries"; var Handled: Boolean);
    var
        lr_BarcodeType: Record "TTT-EBS-BCBarcodeType";
        lv_HttpClient: HttpClient;
        lv_HttpRequestMessage: HttpRequestMessage;
        lv_HttpResponseMessage: HttpResponseMessage;
        lv_InStream: InStream;
        lv_OutStream: OutStream;
        lv_Method: Text;
        lv_StrPos: Integer;
        CallFailedLbl: Label 'Barcode could not be created! (Service down)';

    begin
        if Handled then
            exit;

        lr_BarcodeType.get(pBarcodeEntries."BarcodeType");

        // TTTEBS - Other soultion, to replace %1 with value >>  
        // lv_Method := StrSubstNo(lr_BarcodeType.URL, pBarcodeEntries."Barcode Value");
        lv_StrPos := StrPos(lr_BarcodeType.URL, '%1');
        lv_Method := DelStr(lr_BarcodeType.URL, lv_StrPos, 2);
        lv_Method := InsStr(lv_Method, pBarcodeEntries."BarcodeValue", lv_StrPos);
        // TTTEBS <<

        lv_HttpRequestMessage.SetRequestUri(lv_Method);
        if not lv_HttpClient.Send(lv_HttpRequestMessage, lv_HttpResponseMessage) then
            Error(CallFailedLbl);
        lv_HttpResponseMessage.Content().ReadAs(lv_InStream);
        pBarcodeEntries.Barcode.CreateOutStream(lv_OutStream);
        CopyStream(lv_OutStream, lv_InStream);
        pBarcodeEntries.Modify(true);
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
        exit(lr_RR.Number());
    end;

    procedure CreateBarcode(var pBarcode: Record "TTT-EBS-BCBarcode"; pTableID: Integer; pSysID: Guid; pRecID: RecordId);
    begin
        with pBarcode do begin
            SetRange("TableID", pTableID);
            SetRange("LinkSID", pSysID);
            if FindFirst() then
                exit;

            Init();
            "TableID" := pTableID;
            "LinkSID" := pSysID;
            "LinkRecordID" := Format(pRecID);
            Insert(true);
        end;
    end;

    procedure CreateBarcodeEntries(var pBarcodeEntries: Record "TTT-EBS-BCBarcodeEntries"; pSysID: Guid; pValue: Code[20]; pType: Code[20]; pBarcodeType: Code[20]; pHeight: Integer; pWidth: Integer; pWithText: Boolean): Boolean;
    var
        lv_NextEntryNo: Integer;
    begin
        with pBarcodeEntries do begin
            SetRange("LinkSID", pSysID);
            SetRange("BarcodeValue", pValue);

            SetRange(Type, pType);
            SetRange("BarcodeType", pBarcodeType);
            SetRange(Height, pHeight);
            SetRange(Width, pWidth);
            SetRange("WithText", pWithText);

            if FindFirst() then begin
                CalcFields(Barcode);
                exit(true);
            end;

            SetRange("BarcodeValue");
            SetRange(Type);
            SetRange("BarcodeType");
            SetRange(Height);
            SetRange(Width);
            SetRange("WithText");
            if FindLast() then
                lv_NextEntryNo := "EntryNo.";
            lv_NextEntryNo += 1;

            Init();
            "LinkSID" := pSysID;
            "EntryNo." := lv_NextEntryNo;

            Type := pType;
            "BarcodeType" := pBarcodeType;
            Height := pHeight;
            Width := pWidth;
            "WithText" := pWithText;
            "BarcodeValue" := pValue;
            Insert(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateBarCode(var pBarcodeEntries: Record "TTT-EBS-BCBarcodeEntries"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateBarCode(var pBarcodeEntries: Record "TTT-EBS-BCBarcodeEntries");
    begin
    end;
}