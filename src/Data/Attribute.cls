Class Data.Attribute Extends %Persistent
{

Property Name As %String;

Storage Default
{
<Data name="AttributeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^Data.AttributeD</DataLocation>
<DefaultData>AttributeDefaultData</DefaultData>
<IdLocation>^Data.AttributeD</IdLocation>
<IndexLocation>^Data.AttributeI</IndexLocation>
<StreamLocation>^Data.AttributeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
