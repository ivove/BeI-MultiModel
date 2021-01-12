Class Data.ProductAttribute Extends %Persistent
{

Property Product As Data.Product;

Property Attribute As Data.Attribute;

Property Value As %String;

Storage Default
{
<Data name="ProductAttributeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Product</Value>
</Value>
<Value name="3">
<Value>Attribute</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^Data.ProductAttributeD</DataLocation>
<DefaultData>ProductAttributeDefaultData</DefaultData>
<IdLocation>^Data.ProductAttributeD</IdLocation>
<IndexLocation>^Data.ProductAttributeI</IndexLocation>
<StreamLocation>^Data.ProductAttributeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
