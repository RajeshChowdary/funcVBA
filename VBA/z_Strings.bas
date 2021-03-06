Attribute VB_Name = "z_Strings"
Option Explicit

Public Function AddNewLine(Optional Repeat As Integer = 1) As String
    '----------------------------------------------------
    ' AddNewLine         - Prints a new line Chr(10), can be repeated
    '                    - In : <none>
    '                    - Out: Chr(10)
    '                    - Last Updated: 3/15/11 by AJS
    '----------------------------------------------------
     AddNewLine = WorksheetFunction.Rept(Chr(10), Repeat)
End Function

Public Function AddQuotes(ByVal TextInQuotes As String) As String
    '----------------------------------------------------
    '  AddQuotes         - Surrounds text in quotations
    '                    - In : TextInQuotes as String
    '                    - Out: "TextInQuotes" as String
    '                    - Last Updated: 3/6/11 by AJS
    '----------------------------------------------------
    AddQuotes = Chr(34) & TextInQuotes & Chr(34)
End Function
Public Function AddTab(Optional Repeat As Integer = 1) As String
    '----------------------------------------------------
    '  AddTab            - Adds a tab
    '                    - In : Repeat As Integer
    '                    - Out: Tabs in string
    '                    - Last Updated: 6/17/11 by AJS
    '----------------------------------------------------
    AddTab = WorksheetFunction.Rept(Chr(9), Repeat)
End Function

Public Function ReturnTextBetween(SearchText As String, StartField As String, EndField As String) As String
    '---------------------------------------------------------------------------------------------------------
    ' ReturnTextBetween  - Returns string between starting and ending search strings
    '                    - In : SearchText As String, StartField As String, EndField As String
    '                    - Out: ReturnTextBetween as String
    '                    - Last Updated: 3/9/11 by AJS
    '---------------------------------------------------------------------------------------------------------
    Dim CropLeft As String
    If InStr(1, SearchText, EndField, vbTextCompare) = 0 Then
        FindTextBetween = "ERROR- End field not found (" & """" & EndField & """" & " not not found in " & """" & SearchText & """" & ")"
        MsgBox FindTextBetween
    ElseIf InStr(1, SearchText, StartField, vbTextCompare) = 0 Then
        MsgBox FindTextBetween
        FindTextBetween = "ERROR- Start field not found (" & """" & StartField & """" & " not not found in " & """" & SearchText & """" & ")"
    Else
        CropLeft = Left(SearchText, InStr(1, SearchText, EndField, vbTextCompare) - 1)
        ReturnTextBetween = Right(CropLeft, Len(CropLeft) - (InStr(1, SearchText, StartField, vbTextCompare) + Len(StartField) - 1))
    End If
End Function

Public Function SplitText(InTextLine As String, Delimeter As String) As Variant
    '---------------------------------------------------------------------------------------------------------
    ' SplitText          - Returns a string array of delimited values; removes extra spaces in splits
    '                    - In : InTextLine As String, Delimeter As String
    '                    - Out: SplitText as String()
    '                    - Last Updated: 3/9/11 by AJS
    '---------------------------------------------------------------------------------------------------------
    Dim k As Long, StringCount As Integer
    Dim TempString() As String
    Dim ThisChar As String, LastChar As String
    
    StringCount = 1
    ReDim TempString(1 To StringCount)
    LastChar = Delimeter
    
    For k = 1 To Len(InTextLine)
        ThisChar = Mid(InTextLine, k, 1)
        If ThisChar = Delimeter Then
            If LastChar <> Delimeter Then
                StringCount = StringCount + 1
                ReDim Preserve TempString(1 To StringCount)
                LastChar = ThisChar
            End If
        Else
            TempString(StringCount) = TempString(StringCount) & ThisChar
            LastChar = ThisChar
        End If
    Next k
    SplitText = TempString
End Function

Function SplitTextReturn(InTextLine As String, Delimeter As String, ReturnID As Integer) As String
    '---------------------------------------------------------------------------------------------------------
    ' SplitTextReturn    - Returns a field of a delimited text string
    '                    - In : InTextLine As String, Delimeter As String, ReturnID as Integer
    '                    - Out: SplitTextReturn as String
    '                    - Last Updated: 9/28/11 by AJS
    '---------------------------------------------------------------------------------------------------------
    Dim SplitString As Variant
    On Error GoTo IsErr
    SplitString = SplitText(InTextLine, Delimeter)
    SplitTextReturn = SplitString(ReturnID)
    Exit Function
IsErr:
    SplitTextReturn = ""
End Function

Function IsTextFound(ByVal FindText As String, ByVal WithinText As String) As Boolean
    '----------------------------------------------------------------
    ' IsTextFound       - Returns true if text is found, false if otherwise
    '                   - In : ByVal FindText As String, ByVal WithinText As String
    '                   - Out: Boolean true if found, false if not
    '                   - Last Updated: 4/12/11 by AJS
    '----------------------------------------------------------------
    If InStr(1, WithinText, FindText, vbTextCompare) > 0 Then
        IsTextFound = True
    Else
        IsTextFound = False
    End If
End Function

Public Function BuildXMLText(ByVal FieldName As String, ByVal Value As String, Optional NumTabs As Integer = 0) As String
    '----------------------------------------------------------------
    ' BuildXMLText          - Builds XML text string
    '                       - In : ByVal FieldName As String, ByVal Value As String, Optional NumTabs As Integer = 0
    '                       - Out: XML test string for a single line:   <FieldName>Value</Field>
    '                       - Last Updated: 3/23/11 by AJS
    '----------------------------------------------------------------
    BuildXMLText = AddTab(NumTabs) & "<" & FieldName & ">" & Value & "</" & FieldName & ">"
End Function

Function Regex(SearchString As String, RegExPattern As String, Optional CaseSensitive As Boolean = False) As String
'http://www.regular-expressions.info/dotnet.html
'http://www.tmehta.com/regexp/
'http://www.ozgrid.com/forum/showthread.php?t=37624&page=1
'
'Example function call would return "ty1234"
'MsgBox RegEx("qwerty123456uiops123456", "[a-z][A-Z][0-9][0-9][0-9][0-9]", False)
'
    Dim re As Object, REMatches As Object
    Set re = CreateObject("vbscript.regexp")
    With re
        .Multiline = False
        .Global = False
        .IgnoreCase = Not (CaseSensitive)
        .Pattern = RegExPattern
    End With
    Set REMatches = re.Execute(SearchString)
    If REMatches.Count > 0 Then
        Regex = REMatches(0)
    Else
        Regex = False
    End If
End Function

Public Function RegexReplace(ByVal Pattern As String, _
                             ByVal Replacement As String, _
                             ByVal SourceString As String, _
                             Optional ByVal IgnoreCase As Boolean = False, _
                             Optional ByVal Glbl As Boolean = True, _
                             Optional ByVal Multiline As Boolean = False _
                             ) As String
'Perform a regular expression replacement
'
'Parameters
'----------
'  Pattern:
'    The regular expression pattern to search for
'  Replacement:
'    The string or pattern to be used as a replacement
'  SourceString:
'    The string to search within
'  IgnoreCase (default=True):
'    Whether to be case-insensitive
'  Glbl (default=True):
'    Whether to replace all matches in `SourceString` (otherwise,
'    stop after the first replacement)
'  Multiline (default=False):
'    Whether to activate multiline mode. This makes the carat (^) and
'    dollar ($) match at the beginning and end of each line, rather
'    than the beggining and end of the entire string.
'
'Returns
'-------
'  String, with `Pattern` replaced with `Replacement`, if found
'  in `SourceString`. If `Pattern` is not found, returns `SourceString`
'  as-is.
'
'Example function call
'---------------------
'   Dim Pattern As String: Pattern = "(:\$[A-Z]+\$)([0-9]+)" '2 groups, first keep, 2nd replace
'   Dim Replace As String: Replace = "$1" & 10     'keep $1, replace second with max row
'   Dim TestVal As String: TestVal = "$B$2:$C$4"
'   Debug.Print RegexReplace(Pattern, Replace, TestVal, True, False, False)

    Dim re As Object
    Set re = CreateObject("vbscript.regexp")
    With re
        .Pattern = Pattern
        .IgnoreCase = IgnoreCase
        .Global = Glbl
        .Multiline = Multiline
    End With
    
    RegexReplace = re.Replace(SourceString, Replacement)
End Function

Function Printf(ByVal FormatWithPercentSign As String, ParamArray InsertArray()) As String
'http://www.freevbcode.com/ShowCode.asp?ID=9342
    Dim ResultString As String
    Dim Element As Variant
    Dim FormatLocation As Long

    If IsMissingValue(InsertArray()) Then
        'raise an error
    End If
    
    ResultString = FormatWithPercentSign
    For Each Element In InsertArray
        FormatLocation = InStr(ResultString, "%")
        ResultString = Left$(ResultString, FormatLocation - 1) & Element & Right$(ResultString, Len(ResultString) - FormatLocation - 1)
    Next
    Printf = ResultString
End Function

Public Function AddToArrayIfUnique(ByVal NewString As String, ArrayName() As Variant) As Variant

'    Dim ArrayName() As Variant
'    Let ArrayName = [{"Andy", "Cara", "Josh"}]
'    ArrayName() = AddToArrayIfUnique("Bill", ArrayName())
'    ArrayName() = AddToArrayIfUnique("Andy", ArrayName())

    Dim EachValue As Variant
    Dim Duplicate As Boolean
    Dim ArrEmpty As Boolean
    
    ArrEmpty = False
    On Error Resume Next
    If UBound(ArrayName) = 0 Then ArrEmpty = True
    On Error GoTo 0
    
    Duplicate = False
    If ArrEmpty = False Then
        For Each EachValue In ArrayName
            If NewString = EachValue Then
                Duplicate = True
                Exit For
            End If
        Next
    End If
    
    If ArrEmpty = True Then
        ReDim ArrayName(1 To 1)
        ArrayName(1) = NewString
    ElseIf Duplicate = False Then
        ReDim Preserve ArrayName(LBound(ArrayName()) To UBound(ArrayName()) + 1)
        ArrayName(UBound(ArrayName)) = NewString
    End If
    Let AddToArrayIfUnique = ArrayName
End Function


Function SplitTextReturnOne(InputString As String, ReturnValue As Integer) As String
'Parse text string and return desired word
    Dim StringVariant As Variant
    On Error GoTo IsErr:
    
    StringVariant = SplitText(InputString, " ")
    SplitTextReturnOne = StringVariant(ReturnValue)
    Exit Function
IsErr:
    SplitTextReturnOne = "SplitTextError"
End Function

