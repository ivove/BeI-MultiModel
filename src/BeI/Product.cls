Class BeI.Product Extends (%Persistent, %Populate)
{

Property Name As %String(POPORDER = 1, POPSPEC = ".PopulateName()");

Property Price As %Numeric(POPORDER = 2, POPSPEC = "Float(10,500)");

Property Category As BeI.Category(POPORDER = 3);

Property BitString As %String(POPORDER = 4);

Property FilterBitString As %String;

Property Attributes As array Of BeI.AttributeValue(POPORDER = 5, POPSPEC = ".PopulateAttributes()");

/// cat index
Index idxCategory On Category;

ClassMethod GetProductsByCategoryId(categoryId As %String) As %ArrayOfObjects
{
    set result = ##class(%ArrayOfObjects).%New(),i = 0
    &SQL(DECLARE prodByCat CURSOR FOR SELECT id INTO :id FROM BeI.Product WHERE Category=:categoryId)
    &SQL(OPEN prodByCat)
    while 'SQLCODE {
        &SQL(FETCH prodByCat)
        if 'SQLCODE,id '= "" {
            do result.SetAt(##class(BeI.Product).%OpenId(id),i)
            set i = i + 1
        }
    }
    &SQL(CLOSE prodByCat)
    return result
}

ClassMethod GetAllProducts() As %ArrayOfObjects
{
    s result = ##class(%ArrayOfObjects).%New(),i = 0
    &SQL(DECLARE allProds CURSOR FOR SELECT id INTO :id FROM BeI.Product)
    &SQL(OPEN allProds)
    while 'SQLCODE {
        &SQL(FETCH allProds)
        if 'SQLCODE,id '= "" {
            do result.SetAt(##class(BeI.Product).%OpenId(id),i)
            set i = i + 1
        }
    }
    &SQL(CLOSE allProds)
    return result
}

Method SetBitstring() As %Status
{
    set ok = $$$OK
    set BitString = ""
    set len = ##class(BeI.Agent).GetLastBitstringPosition()
    for i = 1:1:len {
        set $BIT(BitString, i) = 0
    }
    if (..Category '= $$$NULLOREF){
        set $BIT(BitString,..Category.BitStringPosition) = 1
    }
    set attr = ..Attributes.GetNext(.key)
    while key'="" {
        set $BIT(BitString,attr.BitStringPosition) = 1
        set attr = ..Attributes.GetNext(.key)
    }
    set ..BitString=BitString
    do ..%Save(0)
    return ok
}

Method SetFilterBitstring() As %Status
{
    set ok = $$$OK
    set BitString = ""
    set len = ##class(BeI.Attribute).GetAttributes().Count()
    for i = 1:1:len {
        set $BIT(BitString, i) = 0
    }
    if (..Category '= $$$NULLOREF){
        set key = ""
        set attr = ..Category.Attributes.GetNext(.key)
        while key'="" {
            set $BIT(BitString,attr.%Id()) = 1
            set attr = ..Category.Attributes.GetNext(.key)
        }
    }
    set ..FilterBitString = BitString
    do ..%Save(0)
    return ok
}

Method PopulateName() As %String
{
    return ##class(%Library.PopulateUtils).String(20)
}

Method PopulateAttributes() As %Library.ArrayOfObjects [ PublicList = pos ]
{
    set result = ##class(%Library.ArrayOfObjects).%New()
    set key = "",i = 0
    set cat = ##class(BeI.Category).%OpenId(i%Category)
    set attr = cat.Attributes.GetNext(.key)
    while key'="" {
        if '$DATA(pos(attr.%Id()))
        {
            set pos = attr.GetValues()
            set pos(attr.%Id()) = pos 
        }
        set posibilities = pos(attr.%Id())
        set x = $RANDOM(posibilities.Count()-1)
        do result.SetAt(posibilities.GetAt(x),i)
        set attr = cat.Attributes.GetNext(.key),i = i + 1
    }
    return result
}

Method GetDynamicProduct(sortIndex As %String = "") As %DynamicObject
{
    set result = {}
    set result.name = ..Name
    set result."category_name" = ..Category.Name
    set result."category_id" = ..Category.%Id()
    set result.id = ..%Id()
    //set result.bitstring = ##class(BeI.Utils).ShowBitstring(..BitString)
    set result.price = ..Price
    set result.attributes = []
    set attr = ..Attributes.GetNext(.key)
    while key '= "" {
        do result.attributes.%Push(attr.GetDynamicAttributeValue())
        set attr = ..Attributes.GetNext(.key)
    }
    set result."sort_index" = sortIndex
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
<Value name="6">
<Value>FilterBitString</Value>
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
