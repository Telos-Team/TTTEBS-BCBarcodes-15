table 80281 "TTT-EBS-BCBarcode"
{
    Caption = 'Barcode';
    DataClassification = CustomerContent;
    LookupPageId = "TTT-EBS-BCBarcodeList";
    DrillDownPageId = "TTT-EBS-BCBarcodeList";

    fields
    {
        field(1; "TableID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(2; "LinkSID"; Guid)
        {
            Caption = 'Link System ID';
            DataClassification = SystemMetadata;
        }
        field(100; "LinkRecordID"; Text[150])
        {
            Caption = 'Link Record ID';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "TableID", "LinkSID")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        lr_BarcodeEntries: Record "TTT-EBS-BCBarcodeEntries";
    begin
        lr_BarcodeEntries.SetRange("LinkSID", SystemId);
        lr_BarcodeEntries.DeleteAll(true);
    end;
}
