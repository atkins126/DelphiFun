object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 579
  ClientWidth = 631
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 456
    Width = 36
    Height = 15
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 159
    Top = 456
    Width = 68
    Height = 15
    Caption = 'Linked to '#39'id'#39
  end
  object Label3: TLabel
    Left = 159
    Top = 483
    Width = 94
    Height = 15
    Caption = 'Linked to '#39'exeFile'#39
  end
  object Label4: TLabel
    Left = 159
    Top = 535
    Width = 179
    Height = 15
    Caption = 'Linked to '#39'icon_index'#39' (an Integer)'
  end
  object Label5: TLabel
    Left = 159
    Top = 508
    Width = 189
    Height = 15
    Caption = 'Linked to '#39'allow_unsafe'#39' (a Boolean)'
  end
  object Memo1: TMemo
    Left = 16
    Top = 72
    Width = 593
    Height = 362
    TabOrder = 0
  end
  object btnTest: TButton
    Left = 16
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Dump TestObject'
    TabOrder = 1
    OnClick = btnDumpClick
  end
  object Edit1: TEdit
    Left = 32
    Top = 480
    Width = 121
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Text = 'Edit1'
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 509
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 32
    Top = 532
    Width = 121
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    Text = 'Edit2'
  end
  object Button1: TButton
    Left = 152
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Distribute TestObject'
    TabOrder = 5
    OnClick = btnDistributeClick
  end
  object Button2: TButton
    Left = 288
    Top = 24
    Width = 121
    Height = 25
    Caption = 'Collect TestObject'
    TabOrder = 6
    OnClick = btnCollectClick
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 568
    Top = 16
  end
end
