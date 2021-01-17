/// Description
Class Demo.Populate Extends %RegisteredObject
{

/// Description
ClassMethod PopulateFromFile(filename As %String = "/shared/demoData.txt") As %Status
{
    Set stream=##class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(filename)
    While 'stream.AtEnd {
        set line = stream.ReadLine()
        set line = $tr(line,$c(13),"")
        if line '= "" {
            set content=$LISTFROMSTRING(line,"-")
            set type=$LIST(content,1)
            if type = "fam" {
                set ofam = ##class(Data.ProductFamily).%New()
                set ofam.Name = $LIST(content,3)
                do ofam.%Save()
                set fam($LIST(content,2)) = ofam
            } elseif type = "attr" {
                set oattr = ##class(Data.Attribute).%New()
                set oattr.Name = $LIST(content,3)
                do oattr.%Save()
                set attr($LIST(content,2)) = oattr
            } elseif type = "art" {
                set oart = ##class(Data.Product).%New()
                set oart.Name = $LIST(content,3)
                set oart.Price = $LIST(content,4)
                set oart.ProductFamily = fam($LIST(content,5))
                set oart.ProductCode = $LIST(content,2)
                do oart.%Save()
                set art($LIST(content,2)) = oart
            } elseif type = "lnk" {
                set olink = ##class(Data.ProductAttribute).%New()
                set olink.Product = art($LIST(content,2))
                set olink.Attribute = attr($LIST(content,3))
                set olink.Value = $LIST(content,4)
                do olink.%Save()
            }
        }
    }    
    return $$$OK
}

}
