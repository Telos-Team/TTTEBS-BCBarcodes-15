table 80282 "TTTEBS-BCBarcodeEntries"
{
    Caption = 'Barcode Entries';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Link SID"; Guid)
        {
            Caption = 'Link SID';
            DataClassification = SystemMetadata;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(110; Type; Code[20])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(120; "Barcode Type"; Code[20])
        {
            Caption = 'Barcode Type';
            DataClassification = CustomerContent;
        }
        field(130; Height; Integer)
        {
            Caption = 'Height';
            DataClassification = CustomerContent;
        }
        field(140; Width; Integer)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
        }
        field(150; "With Text"; Boolean)
        {
            Caption = 'With Text';
            DataClassification = CustomerContent;
        }
        field(160; "Barcode Value"; Code[20])
        {
            Caption = 'Barcode Value';
            DataClassification = CustomerContent;
        }
        field(170; Barcode; Blob)
        {
            Caption = 'Barcode';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Link SID", "Entry No.")
        {
            Clustered = true;
        }
    }
}
