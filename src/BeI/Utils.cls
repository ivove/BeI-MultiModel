Class BeI.Utils Extends %RegisteredObject
{

ClassMethod ResetDB() As %Status
{
    kill ^BeI.AttributeValueD
    kill ^BeI.AttributeValueI
    kill ^BeI.AttributeD
    kill ^BeI.AttributeI
    kill ^BeI.CategoryD
    kill ^BeI.CategoryI
    kill ^BeI.ProductD
    kill ^BeI.ProductI
    kill ^BeI.SortOrderD
    kill ^BeI.SortOrderI
    kill ^BeILastBitstringPosition
    kill ^INDEX
    return $$$OK
}

ClassMethod BuildFirstTestSet(size As %Integer = 100) As %Status
{
        set ok = $$$OK
        write "Resetting DB",!
        set start = $zh
        do ##class(BeI.Utils).ResetDB()
        write "DB reset done in: ",$zh-start,!
        write "Populating categories - Attributes - attributevalues",!
        set start = $zh
        // populate categories - Attributes - attributevalues
        do ##class(BeI.Utils).PopulateFromFile()
        write "categories - Attributes - attributevalues populated in: ",$zh-start,!
        write "Populating products",!
        set start = $zh
        // populate products
        do ##class(BeI.Product).Populate(size)
        for i=1:1:size {
            set oref = ##class(BeI.Product).%OpenId(i)
            if oref {
                set oref.Attributes = oref.PopulateAttributes()
                do oref.%Save(0)
            }
        }
        write "products populated in: ",$zh-start,!
        set start = $zh
        write "Creating Sort orders",!
        do ##class(BeI.Utils).BuildSorts()
        write "Sort orders created in: ",$zh-start,!
        write "running Agent",!
        set start = $zh
        // Run the agent
        do ##class(BeI.Agent).Run()
        write "Agent ran for: ",$zh-start,!
        // return overal status
        return ok
}

ClassMethod WorstCase() As %Status
{
    set cat = ##class(BeI.Utils).NewCategory("Worst")
    set prod = ##class(BeI.Product).%New()
    set prod.Category = cat
    set prod.Price = 999
    set prod.Name = "Worst product ever"
    do prod.%Save()
    do ##class(BeI.Agent).Run()    
    return $$$OK
}

ClassMethod PopulateFromFile(filename As %String = "/shared/testData.txt") As %Status
{
    Set stream=##class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(filename)
    While 'stream.AtEnd {
        set line = stream.ReadLine()
        set line = $tr(line,$c(13),"")
        if line '= "" {
            set content=$LISTFROMSTRING(line,"-")
            set type=$LIST(content,1)
            if type = "cat" {
                set cat($LIST(content,2)) = ##class(BeI.Utils).NewCategory($LIST(content,3))
            } elseif type = "attr" {
                set attr($LIST(content,2)) = ##class(BeI.Utils).NewAttribute($LIST(content,3))
            } elseif type = "lnk" {
                do cat($LIST(content,2)).Attributes.SetAt(attr($LIST(content,3)),cat($LIST(content,2)).Attributes.Count())
                do cat($LIST(content,2)).%Save()
            } elseif type = "attrval" {
                set x = ##class(BeI.AttributeValue).%New()
                set x.Attribute = attr($LIST(content,2))
                set x.Name = $LIST(content,3)
                set x.Value = $LIST(content,4)
                do x.%Save()
            }
        }
    }    
    return $$$OK
}

ClassMethod BuildSorts() As %Status
{
    set result = $$$OK
    set sortPriceAsc = ##class(BeI.SortOrder).%New()
    set sortPriceAsc.Name = "Price Low -> High"
    set sortPriceAsc.Direction = 1
    set sortPriceAsc.Field = "price"
    set sortPriceAsc.IndexRule = "($j(prod.Price,0,2) * 10000000000) + prod.%Id()"
    do sortPriceAsc.%Save()
    set sortPriceDesc = ##class(BeI.SortOrder).%New()
    set sortPriceDesc.Name = "Price High -> Low"
    set sortPriceDesc.Direction = -1
    set sortPriceDesc.Field = "price"
    set sortPriceDesc.IndexRule = "($j(prod.Price,0,2) * 10000000000) + prod.%Id()"
    do sortPriceDesc.%Save()
    set sortNameAsc = ##class(BeI.SortOrder).%New()
    set sortNameAsc.Name = "Name A->Z"
    set sortNameAsc.Direction = 1
    set sortNameAsc.Field = "name"
    set sortNameAsc.IndexRule = "prod.Name_$EXTRACT(100000000 + prod.%Id(),2,*)"
    do sortNameAsc.%Save()
    set sortNameDesc = ##class(BeI.SortOrder).%New()
    set sortNameDesc.Name = "Name Z->A"
    set sortNameDesc.Direction = -1
    set sortNameDesc.Field = "name"
    set sortNameDesc.IndexRule = "prod.Name_$EXTRACT(100000000 + prod.%Id(),2,*)"
    do sortNameDesc.%Save()    
    set sortIdAsc = ##class(BeI.SortOrder).%New()
    set sortIdAsc.Name = "Id A->Z"
    set sortIdAsc.Direction = 1
    set sortIdAsc.Field = "id"
    set sortIdAsc.IndexRule = "prod.%Id()"
    do sortIdAsc.%Save()    
    set sortIdDesc = ##class(BeI.SortOrder).%New()
    set sortIdDesc.Name = "Id Z->A"
    set sortIdDesc.Direction = -1
    set sortIdDesc.Field = "id"
    set sortIdDesc.IndexRule = "prod.%Id()"
    do sortIdDesc.%Save()    
    return result
}

ClassMethod NewCategory(name As %String, sourceId As %String) As BeI.Category
{
    set cat = ##class(BeI.Category).GetAttributeByName(name)
    if cat = $$$NULLOREF {
        set cat = ##class(BeI.Category).%New()
        set cat.Name = name
    }
    if cat.SourceIds.Find(sourceId,"") = "" {
        do cat.SourceIds.Insert(sourceId)
    }
    do cat.%Save()
    return cat
}

ClassMethod NewAttribute(name As %String, sourceId As %String) As BeI.Attribute
{
    set attr = ##class(BeI.Attribute).GetAttributeByName(name)
    if attr = $$$NULLOREF { 
        set attr = ##class(BeI.Attribute).%New() 
        set attr.Name = name
    }
    if attr.SourceIds.Find(sourceId,"") = "" {
        do attr.SourceIds.Insert(sourceId)
    }
    do attr.%Save()
    return attr
}

ClassMethod NewAttributeValue(attributeName As %String, valueName As %String, value As %String, sourceValue As %String) As %Status
{
    set result = $$$NULLOREF
    set attr = ##class(BeI.Attribute).GetAttributeByName(attributeName)
    if attr '= $$$NULLOREF {
        set result = ##class(BeI.AttributeValue).GetAttributeValue(attr.%Id(),valueName,value)
        if result = $$$NULLOREF { 
            set result = ##class(BeI.AttributeValue).%New()
            set result.Attribute = attr
            set result.Name = valueName
            set result.Value = value
        }
        if result.SourceValues.Find(sourceValue,"") '= "" {
            do result.SourceValues.Insert(sourceValue)
        }
        do result.%Save()
    }
    return result
}

ClassMethod NewProduct(name As %String, price As %Numeric, categoryId As %String, attributes As %ListOfDataTypes) As %Status
{
    set result = ##class(BeI.Product).%New()

    return result
}

ClassMethod ShowBitstring(bs) As %String
{
    set result = ""
    for i=1:1:$BITCOUNT(bs) { set result = result_$bit(bs, i) }
    return result
}

}
