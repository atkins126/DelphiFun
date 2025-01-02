# Data Transfer Object Helper

This is one of those projects that sounds like a good idea before development, but has so many drawbacks that it is never used.
However, I have completed the tool as a proof of concept so that someone can take up the idea.

## The idea

The runtime type information is a fundamental feature of Delphi that has existed since the first version. The entire
VCL, and thus the RAD concept, is based on the availability of type information at runtime.

Since the number of parameters in functions should be limited in order to increase the clarity and maintainability of the code,
DTOs (Data Transfer Objects) are used to transfer large, structured amounts of data between program components.
These are usually records or dumb objects without functionality.

Two tasks occur again and again: A TForm requests data from a service and receives a Data Transfer Object.
This must now be read out field by field and distributed to the individual form fields. If it is returned to the service, e.g.
to be stored in a database, the process is reversed: the fields of the form must be read and stored in the Data Transfer Object.
read out and saved in the Data Transfer Object. The finished DTO is then transferred to the service and processed.

The plan was to simplify these two processes using RTTI.

## Why the idea was not a good one

The Delphi compiler is our best friend. The strong typing of Object Pascal recognizes most type errors already 
during compilation. If you use RTTI to manipulate fields, the compiler cannot perform a check: Errors therefore
only appear as runtime errors. This takes some of the joy out of my development work.

## The demo project

I took the DTO TConfigFileDTO from one of my projects, so it comes from the real world. To use the helper,
it must be defined as a class and derived from TDataTransferObject. DTO's are not part of the object graph of an application,
but are used as a replacement for excessively long parameter lists.

The configuration of the DTO takes place in the example project in the procedure TForm1.FormCreate from line 81:

```
ClearControlLinks;
AddControlLink('id', Label1, 'Caption');
AddControlLink('exeFile', Edit1, 'Text');
AddControlLink('icon_index', Edit2, 'Text');
AddControlLink('allow_unsafe', CheckBox1, 'Checked');
```

The definition of AddControlLink is as follows:
**`procedure AddControlLink(const FieldName: string; Component: TComponent; SourceProperty: string);`**

FieldName: Name of the field in the Data Transfer Object as a  string

Component: The form component to be manipulated

SourceProperty: Name of the property of the form component as a string

### Distribute

A call to Distribute iterates the saved links and copies the values from the DTO to the corresponding form elements.
form elements.

### Collect

A call to Collect iterates the saved links and copies the values from the form elements into the DTO.

### External dependencies

None, or nothing that is not supplied with Delphi.