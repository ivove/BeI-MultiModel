Class BeI.Product Extends (%Persistent, %Populate)
{

Property Name As %String(POPORDER = 1, POPSPEC = ".PopulateName()");

Property Price As %Numeric(POPORDER = 2, POPSPEC = "Float(0,500)");

Property Category As BeI.Category(POPORDER = 3);

Property BitString As %String(POPORDER = 4);

Property Attributes As array Of BeI.AttributeValue(POPORDER = 5, POPSPEC = ".PopulateAttributes()");

ClassMethod GetProductsByCategoryId(categoryId As %String) As %ArrayOfObjects
{
    s result = ##class(%ArrayOfObjects).%New(),i=0
    &SQL(DECLARE prodByCat CURSOR FOR SELECT id INTO :id FROM BeI.Product WHERE Category=:categoryId)
    &SQL(OPEN prodByCat)
    while 'SQLCODE {
        &SQL(FETCH prodByCat)
        i 'SQLCODE,id'="" {
            d result.SetAt(##class(BeI.Product).%OpenId(id),i)
            s i=i+1
        }
    }
    &SQL(CLOSE prodByCat)
    return result
}

ClassMethod GetAllProducts() As %ArrayOfObjects
{
    s result = ##class(%ArrayOfObjects).%New(),i=0
    &SQL(DECLARE allProds CURSOR FOR SELECT id INTO :id FROM BeI.Product)
    &SQL(OPEN allProds)
    while 'SQLCODE {
        &SQL(FETCH allProds)
        i 'SQLCODE,id'="" {
            d result.SetAt(##class(BeI.Product).%OpenId(id),i)
            s i=i+1
        }
    }
    &SQL(CLOSE allProds)
    return result
}

Method SetBitstring() As %Status
{
    set ok = $$$OK
    set BitString=""
    s len=##class(BeI.Agent).GetLastBitstringPosition()
    for i = 1:1:len {
        s $BIT(BitString, i) = 0
    }
    if (..Category '= $$$NULLOREF){
        s $BIT(BitString,..Category.BitStringPosition)=1
    }
    s attr = ..Attributes.GetNext(.key)
    while key'="" {
        s $BIT(BitString,attr.BitStringPosition)=1
        s attr = ..Attributes.GetNext(.key)
    }
    s ..BitString=BitString
    d ..%Save(0)
    return ok
}

Method PopulateName() As %String
{
    return ##class(%Library.PopulateUtils).Product()_" "_##class(%Library.PopulateUtils).String(10)
}

Method PopulateAttributes() As %Library.ArrayOfObjects
{
    s result = ##class(%Library.ArrayOfObjects).%New()
    s key = "",i = 0
    s cat = ##class(BeI.Category).%OpenId(i%Category)
    s attr = cat.Attributes.GetNext(.key)
    while key'="" {
        s posibilities = attr.GetValues()
        s x = $RANDOM(posibilities.Count()-1)
        d result.SetAt(posibilities.GetAt(x),i)
        s attr = cat.Attributes.GetNext(.key),i = i + 1
    }
    return result
}

Storage Default
{
<Data name="Attributes">
<Attribute>Attributes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Attributes"</Subscript>
</Data>
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Category</Value>
</Value>
<Value name="4">
<Value>BitString</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
</Data>
<DataLocation>^BeI.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^BeI.ProductD</IdLocation>
<IndexLocation>^BeI.ProductI</IndexLocation>
<StreamLocation>^BeI.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}