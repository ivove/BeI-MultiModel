Class BeI.Convert Extends %RegisteredObject
{

/// This method should be overriden to populate the database with attibutes seeded from your source Database. 
/// Names for attributes must be unique, the interface to create an attribute will ensure this.
/// Attribute should be created calling the classmethod ##class(BeI.Utils).NewAttribute(name,sourceId)
/// this with the name as the name of the attribute and the sourceid being the id of the attribute in the source database
ClassMethod BuildAttributes() As %Status [ Abstract ]
{
}

/// Use this method to populate the attribute-values from your source-database.
/// This is the place to group your aatributes to form a sort of range filter.
/// These records should be created using the classmethod ##class(BeI.Utils).NewAttributeValue(attributeName,valueName,value,sourceValue)
/// where attributeName is the name you've given the attribute
/// valueName: the name of this attribute value (examples: small,medium,large)
/// value: the value that is associated with this attribute value (most of the time this will be an number)
/// sourceValue: the value in the source database. If you want to group values, this is for storing the individual values
ClassMethod BuildAttributeValues() As %Status [ Abstract ]
{
}

/// use this method to create categories. You may group multiple categorie/families from your source database into one filter category
/// Category records should be created using the classmethod ##class(BeI.Utils).NewCategory(name,sourceId)
/// The name should be the name you wish to use in the filter, the sourceId is the id of the record in your sourcedatabase
ClassMethod BuildCategories() As %Status [ Abstract ]
{
}

/// this method should be used to create the products. products in the filter an the sourcedatabase should have a 1 on 1 mapping
/// A product can be created using the classmethod ##class(BeI.Utils).NewProduct(name,price,categoryId,attributes,sourceId)
/// where: name: the name of the product
/// price: the product price
/// categoryId: the id of the category/family in the source database
/// attributes: a list of strings containing the sourcevalues (used for the creation of the attribute values)
/// sourceId: the id of the product in the database
ClassMethod BuildProducts() As %Status [ Abstract ]
{
}

}
