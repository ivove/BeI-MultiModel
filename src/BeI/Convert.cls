Class BeI.Convert Extends %RegisteredObject
{

/// This method should be overriden to populate the database with attibutes seeded from your source Database. 
/// Names for attributes must be unique, the interface to create an attribute will ensure this.
/// Attribute should be created calling the classmethod ##class(BeI.Utils).CreateAttribute(name,sourceId)
/// this with the name as the name of the attribute and the sourceid being the id of the attribute in the source database
ClassMethod BuildAttributes() As %Status [ Abstract ]
{
}

/// Use this method to populate the attribute-values from your source-database.
/// This is the place to group your aatributes to form a sort of range filter.
/// These records should be created using the classmethod ##class(BeI.Utils).CreateAttributeValue(attributeName,valueName,value,sourceValue)
/// where attributeName is the name you've given the attribute
/// valueName: the name of this attribute value (examples: small,medium,large)
/// value: the value that is associated with this attribute value (most of the time this will be an number)
/// sourceValue: the value in the source database. If you want to group values, this is for storing the individual values
ClassMethod BuildAttributeValues() As %Status [ Abstract ]
{
}

ClassMethod BuildCategories() As %Status [ Abstract ]
{
}

ClassMethod BuildProducts() As %Status [ Abstract ]
{
}

}
