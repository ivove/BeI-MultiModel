Class BeI.Attribute Extends %Persistent
{

Property Name As %String;

Property SourceIds As list Of %String;

Index idxName On Name;

Method GetValues() As %Library.ArrayOfObjects
{
    kill list
    set result = ##class(%Library.ArrayOfObjects).%New()
    set attrId = ..%Id(),i = 0
    &SQL(declare attrs cursor for select id into:Id from BeI.AttributeValue where Attribute = :attrId)
    &SQL(open attrs)
    while 'SQLCODE {
        &sql(fetch attrs)
        if 'SQLCODE,Id '= "" {
            do result.SetAt(##class(BeI.AttributeValue).%OpenId(Id),i)
            set i = i + 1
        }
    }
    &SQL(close attrs)
    return result
}

ClassMethod GetAttributes() As %ArrayOfObjects
{
    set result = ##class(%ArrayOfObjects).%New(),i = 0
    &SQL(DECLARE attrs CURSOR FOR SELECT id INTO :id FROM BeI.Attribute)
    &SQL(OPEN attrs)
    while 'SQLCODE {
        &SQL(FETCH attrs)
        if 'SQLCODE,id '= "" {
            do result.SetAt(##class(BeI.Attribute).%OpenId(id),i)
            set i = i + 1
        }
    }
    &SQL(CLOSE attrs)
    return result
}

ClassMethod GetAttributeByName(name As %String) As BeI.Attribute
{
    set result = $$$NULLOREF
    &SQL(SELECT id into:id FROM BeI.Attribute WHERE Name = :name)
    if 'SQLCODE,id'="" { set result = ##class(BeI.Attribute).%OpenId(id) }
    return result
}

Storage Default
{
<Data name="AttributeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>SourceIds</Value>
</Value>
</Data>
<DataLocation>^BeI.AttributeD</DataLocation>
<DefaultData>AttributeDefaultData</DefaultData>
<IdLocation>^BeI.AttributeD</IdLocation>
<IndexLocation>^BeI.AttributeI</IndexLocation>
<StreamLocation>^BeI.AttributeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
