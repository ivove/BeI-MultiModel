Class BeI.Category Extends %Persistent
{

Property Name As %String;

Property Attributes As array Of BeI.Attribute;

Property SourceIds As array Of %String;

Property BitStringPosition As %Numeric;

ClassMethod GetCategoryByName(name As %String) As BeI.Category
{
    set result = $$$NULLOREF
    &SQL(SELECT id INTO :id FROM BeI.Category WHERE Name=:name)
    if 'SQLCODE,id '= "" { set result = ##class(BeI.Category).%OpenId(id) }
    return result
}

/// Get the Category by its legacy id (the id in the source database)
ClassMethod GetCategoryBySourceId(sourceId As %String) As BeI.Category
{
    Set result = $$$NULLOREF    
    &SQL(SELECT category INTO :id FROM BeI.Category_SourceIds WHERE SourceIds=:soucerId)
    if 'SQLCODE,id '=' "" {
        set result = ##class(BeI.Category).%OpenId(id)
    }
    Return result
}

ClassMethod GetAllCategories() As %Library.ArrayOfObjects
{
    set result = ##class(%ArrayOfObjects).%New(),i = 0
    &SQL(DECLARE allCats CURSOR FOR SELECT id INTO :id FROM BeI.Category)
    &SQL(OPEN allCats)
    while 'SQLCODE {
        &SQL(FETCH allCats)
        if 'SQLCODE,id '= "" {
            do result.SetAt(##class(BeI.Category).%OpenId(id),i)
            set i = i + 1
        }
    }
    &SQL(CLOSE allCats)
    return result
}

ClassMethod CategoriesWithoutPosition() As %Library.ArrayOfObjects
{
    set result = ##class(%ArrayOfObjects).%New(),i = 0
    &SQL(DECLARE noPosCats CURSOR FOR SELECT id INTO :id FROM BeI.Category WHERE BitStringPosition IS NULL)
    &SQL(OPEN noPosCats)
    while 'SQLCODE {
        &SQL(FETCH noPosCats)
        if 'SQLCODE,id '= "" {
            do result.SetAt(##class(BeI.Category).%OpenId(id),i)
            set i = i + 1
        }
    }
    &SQL(CLOSE noPosCats)
    return result
}

Storage Default
{
<Data name="Attribute">
<Attribute>Attribute</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attribute"</Subscript>
</Data>
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="CategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>BitStringPosition</Value>
</Value>
</Data>
<Data name="SourceIds">
<Attribute>SourceIds</Attribute>
<Structure>subnode</Structure>
<Subscript>"SourceIds"</Subscript>
</Data>
<DataLocation>^BeI.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<IdLocation>^BeI.CategoryD</IdLocation>
<IndexLocation>^BeI.CategoryI</IndexLocation>
<StreamLocation>^BeI.CategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
