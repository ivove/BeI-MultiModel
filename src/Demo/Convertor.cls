/// BeI.Convert implementation to convert the data in the Data.* tables to filter entries
Class Demo.Convertor Extends BeI.Convert
{

ClassMethod BuildAttributes() As %Status
{
    &SQL(DECLARE attrs CURSOR FOR SELECT id INTO :id FROM Data.Attribute)
    &SQL(OPEN attrs)
    while 'SQLCODE {
        &SQL(FETCH attrs)        
        if 'SQLCODE,id '= "" {
            set oattr = ##class(Data.Attribute).%OpenId(id)
            do ##class(BeI.Utils).NewAttribute(oattr.Name,oattr.%Id())
        }
    }
    &SQL(CLOSE attrs)
}

ClassMethod BuildAttributeValues() As %Status
{
    &SQL(DECLARE prodattrs CURSOR FOR SELECT id INTO :id FROM Data.ProductAttribute)
    &SQL(OPEN prodattrs)
    while 'SQLCODE {
        &SQL(FETCH prodattrs)        
        if 'SQLCODE,id '= "" {
            set oattr = ##class(Data.ProductAttribute).%OpenId(id)
            set value = oattr.Value
            if oattr.Attribute.Name = "Screen Size" {
                set value = "Medium"
                if oattr.Value > 40 { set value = "Large" }
                if oattr.Value < 30 { set value = "Small" }
            }
            d ##class(BeI.Utils).NewAttributeValue(oattr.Attribute.Name,value,,oattr.Value)
        }
    }
    &SQL(CLOSE prodattrs)
}

ClassMethod BuildCategories() As %Status
{
    &SQL(DECLARE fams CURSOR FOR SELECT id INTO :id FROM Data.ProductFamily)
    &SQL(OPEN fams)
    while 'SQLCODE {
        &SQL(FETCH fams)
        if 'SQLCODE,id '= "" {
            set ofam = ##class(Data.ProductFamily).%OpenId(id)
            set name = ofam.Name
            if $lENGTH(name," ") > 1{
                // this family contains a size prefix; for filtering we want to ignore this and
                // place all these products in one big, happy, category
                set name = $PIECE(name," ",$LENGTH(name," "))
            }
            do ##class(BeI.Utils).NewCategory(name,ofam.%Id())
        }
    }
    &SQL(CLOSE fams)
}

ClassMethod BuildProducts() As %Status
{
}

}
