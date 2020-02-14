table 80282 "TTT-EBS-BCBarcodeEntries"
{
    Caption = 'Barcode Entries';
    DataClassification = CustomerContent;
    LookupPageId = "TTT-EBS-BCBarcodeEntriesList";
    DrillDownPageId = "TTT-EBS-BCBarcodeEntriesList";

    fields
    {
        field(1; "LinkSID"; Guid)
        {
            Caption = 'Link SID';
            DataClassification = SystemMetadata;
        }
        field(2; "EntryNo."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(110; Type; Code[20])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(120; "BarcodeType"; Code[20])
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
        field(150; "WithText"; Boolean)
        {
            Caption = 'With Text';
            DataClassification = CustomerContent;
        }
        field(160; "BarcodeValue"; Code[20])
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
        key(PK; "LinkSID", "EntryNo.")
        {
            Clustered = true;
        }
        key(Key2; "Type")
        {
        }
        key(Key3; "BarcodeType")
        {
        }
        key(Key4; "Height")
        {
        }
        key(Key5; "Width")
        {
        }
        key(Key6; "WithText")
        {
        }
    }
}
