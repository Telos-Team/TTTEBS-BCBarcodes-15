codeunit 80282 "TTT-EBS-BCBarcodeURL"
{
    procedure CreateBarcode(var pBarcodeEntry: Record "TTT-EBS-BCBarcodeEntry"; pRecID: RecordId; pValue: Code[20]; pType: Code[20]; pBarcodeType: Code[20]; pHeight: Integer; pWidth: Integer; pWithText: Boolean)
    var
        lr_Barcode: Record "TTT-EBS-BCBarcode";
        lv_SysID: Guid;
        lv_TableID: Integer;
        lv_Handled: Boolean;
        ValueMustNotBeBlankErr: Label 'Value must not be blank!';
        BarcodeTypeMustNotBeBlankErr: Label 'Barcode Type must not be blank!';
    begin
        if pValue = '' then
            Error(ValueMustNotBeBlankErr);

        if pBarcodeType = '' then
            Error(BarcodeTypeMustNotBeBlankErr);

        // Find System ID, from called Record ID (use for finding or creating barcode)..
        lv_SysID := GetSystemIDFromRecordID(pRecID);
        lv_TableID := pRecID.TableNo();

        // Find or Create in Table "BarCode" (PKEY -> Table ID + Link System ID)
        CreateBarcode(lr_Barcode, lv_TableID, lv_SysID, pRecID);

        // Find or Create in Table "BarCodeEntry" (PKEY -> Link SID + Entry No)
        lv_SysID := GetSystemIDFromRecordID(lr_Barcode.RecordId());
        if CreateBarcodeEntry(pBarcodeEntry,
                                lv_SysID,
                                pValue,
                                pType,
                                pBarcodeType,
                                pHeight,
                                pWidth,
                                pWithText
                                ) then begin
            OnBeforeCreateBarCode(pBarcodeEntry, lv_Handled);
            if not lv_Handled then
                DoCreateBarCode(pBarcodeEntry);
        end;
        OnAfterCreateBarCode(pBarcodeEntry);
    end;

    local procedure DoCreateBarCode(var pBarcodeEntry: Record "TTT-EBS-BCBarcodeEntry");
    var
        lr_BarcodeType: Record "TTT-EBS-BCBarcodeType";
        lv_HttpClient: HttpClient;
        lv_HttpRequestMessage: HttpRequestMessage;
        lv_HttpResponseMessage: HttpResponseMessage;
        lv_InStream: InStream;
        lv_OutStream: OutStream;
        lv_Method: Text;
        HttpCallFailedErr: Label 'Barcode could not be created! (Error: %1)', Comment = '%1 = Error message';
    begin
        lr_BarcodeType.get(pBarcodeEntry."BarcodeType");
        lv_Method := StrSubstNo(Format(lr_BarcodeType.URL), pBarcodeEntry."BarcodeValue");

        lv_HttpRequestMessage.SetRequestUri(lv_Method);
        if not lv_HttpClient.Send(lv_HttpRequestMessage, lv_HttpResponseMessage) then
            Error(HttpCallFailedErr, lv_HttpRequestMessage.GetRequestUri());  // TTTEBS - Better to find reason for not Send!

        if lv_HttpResponseMessage.Content().ReadAs(lv_InStream) then begin
            pBarcodeEntry.Barcode.CreateOutStream(lv_OutStream);
            if CopyStream(lv_OutStream, lv_InStream) then
                pBarcodeEntry.Modify(true);
        end;
    end;

    procedure GetSystemIDFromRecordID(pRecID: RecordId): Guid;
    var
        lr_RR: Recordref;
    begin
        lr_RR := pRecID.GetRecord();
        if lr_RR.Find('=') then
            exit(lr_RR.Field(lr_RR.SystemIdNo()).Value());
    end;

    procedure CreateBarcode(var pBarcode: Record "TTT-EBS-BCBarcode"; pTableID: Integer; pSysID: Guid; pRecID: RecordId);
    begin
        with pBarcode do begin
            SetRange("TableID", pTableID);
            SetRange("LinkSystemID", pSysID);
            if FindFirst() then
                // If record renamed -> Delete, and recreate..
                if LinkRecordID <> pRecID then
                    Delete(true)
                else
                    exit;

            Init();
            "TableID" := pTableID;
            "LinkSystemID" := pSysID;
            "LinkRecordID" := pRecID;
            Insert(true);
        end;
    end;

    procedure CreateBarcodeEntry(var pBarcodeEntry: Record "TTT-EBS-BCBarcodeEntry"; pSysID: Guid; pValue: Code[20]; pType: Code[20]; pBarcodeType: Code[20]; pHeight: Integer; pWidth: Integer; pWithText: Boolean): Boolean;
    var
        lv_NextEntryNo: Integer;
    begin
        Clear(pBarcodeEntry);
        with pBarcodeEntry do begin
            SetRange(LinkSystemID, pSysID);
            SetRange(BarcodeValue, pValue);

            SetRange(Type, pType);
            SetRange(BarcodeType, pBarcodeType);
            SetRange(Height, pHeight);
            SetRange(Width, pWidth);
            SetRange(WithText, pWithText);

            if FindFirst() then begin
                CalcFields(Barcode);
                exit(false);
            end;

            SetRange(BarcodeValue);
            SetRange(Type);
            SetRange(BarcodeType);
            SetRange(Height);
            SetRange(Width);
            SetRange(WithText);
            if FindLast() then
                lv_NextEntryNo := "EntryNo";
            lv_NextEntryNo += 1;

            Init();
            "LinkSystemID" := pSysID;
            "EntryNo" := lv_NextEntryNo;

            Type := pType;
            "BarcodeType" := pBarcodeType;
            Height := pHeight;
            Width := pWidth;
            "WithText" := pWithText;
            "BarcodeValue" := pValue;
            Insert(true);
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateBarCode(var pBarcodeEntry: Record "TTT-EBS-BCBarcodeEntry"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateBarCode(var pBarcodeEntry: Record "TTT-EBS-BCBarcodeEntry");
    begin
    end;
}