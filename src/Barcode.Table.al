table 80281 "TTTEBS-BCBarcode"
{
    Caption = 'Barcode';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            DataClassification = CustomerContent;
        }
        field(2; "Link SID"; Guid)
        {
            Caption = 'Link System ID';
            DataClassification = SystemMetadata;
        }
        field(100; "Link Record ID"; Text[150])
        {
            Caption = 'Link Record ID';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; "Table ID", "Link SID")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        lr_BarcodeEntries: Record "TTTEBS-BCBarcodeEntries";
    begin
        lr_BarcodeEntries.SetRange("Link SID", SystemId);
        lr_BarcodeEntries.DeleteAll(true);
    end;
}
