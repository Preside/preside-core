component extends="tests.resources.HelperObjects.PresideBddTestCase" {

	public void function run() {
		describe( "readObject()", function(){
			it( "should get table name from component when attribute supplied", function(){
				var targetObject = new tests.resources.presideObjectReader.simple_object_with_attributes();
				var object       = getReader().readObject( targetObject );

				expect( object.tableName ).toBe( "test_table" );
			} );

			it( "should allow inheritance of table name", function(){
				var targetObject = new tests.resources.presideObjectReader.simple_object_with_inheritance();
				var object       = getReader().readObject( targetObject );

				expect( object.tableName ).toBe( "test_table" );
			} );

			it( "should allow inheritance overrides of table name", function(){
				var targetObject = new tests.resources.presideObjectReader.simple_object_with_inheritance_overrides();
				var object       = getReader().readObject( targetObject );

				expect( object.tableName ).toBe( "override_test_table" );
			} );

			it( "should read in all simple attributes with inheritance", function(){
				var targetObject = new tests.resources.presideObjectReader.simple_object_with_inheritance_and_custom_attributes();
				var object       = getReader().readObject( targetObject );

				expect( object.tableName ).toBe( "override_test_table" );
				expect( object.someattribute ).toBe( "test" );
			} );

			it( "should not read standard component attributes such as output and persist", function(){
				var targetObject = new tests.resources.presideObjectReader.simple_object_with_inheritance_and_custom_attributes();
				var object       = getReader().readObject( targetObject );

				expect( StructKeyExists( object, "accessors"     ) ).toBeFalse( "The object reader returned system attribute, 'accessors', when it was expected not to." );
				expect( StructKeyExists( object, "displayname"   ) ).toBeFalse( "The object reader returned system attribute, 'displayname', when it was expected not to." );
				expect( StructKeyExists( object, "fullname"      ) ).toBeFalse( "The object reader returned system attribute, 'fullname', when it was expected not to." );
				expect( StructKeyExists( object, "hashCode"      ) ).toBeFalse( "The object reader returned system attribute, 'hashCode', when it was expected not to." );
				expect( StructKeyExists( object, "hint"          ) ).toBeFalse( "The object reader returned system attribute, 'hint', when it was expected not to." );
				expect( StructKeyExists( object, "output"        ) ).toBeFalse( "The object reader returned system attribute, 'output', when it was expected not to." );
				expect( StructKeyExists( object, "path"          ) ).toBeFalse( "The object reader returned system attribute, 'path', when it was expected not to." );
				expect( StructKeyExists( object, "persistent"    ) ).toBeFalse( "The object reader returned system attribute, 'persistent', when it was expected not to." );
				expect( StructKeyExists( object, "remoteAddress" ) ).toBeFalse( "The object reader returned system attribute, 'remoteAddress', when it was expected not to." );
				expect( StructKeyExists( object, "synchronized"  ) ).toBeFalse( "The object reader returned system attribute, 'synchronized', when it was expected not to." );
			} );

			it( "should return properties defined in component", function(){
				var targetObject = new tests.resources.presideObjectReader.object_with_properties();
				var object       = getReader().readObject( targetObject );
				var expectedResult = {
					  test_property         = { name="test_property"         }
					, related_prop          = { name="related_prop"         ,                                                          control="objectpicker", maxLength="35", relatedto="someobject", relationship="many-to-one" }
					, another_property      = { name="another_property"     , type="date"   , label="My property" , dbtype="datetime", control="datepicker", required="true" }
					, some_numeric_property = { name="some_numeric_property", type="numeric", label="Numeric prop", dbtype="tinyint" , control="spinner"   , required="false", minValue="1", maxValue="10" }
				};

				expect( object.properties ).toBe( expectedResult );
			} );

			it( "should return properties defined in component mixed in with inherited properties", function(){
				var targetObject = new tests.resources.presideObjectReader.object_with_properties_and_inheritance();
				var object       = getReader().readObject( targetObject );
				var expectedResult = {
					  test_property         = { name="test_property"        , label="New label" }
					, new_property          = { name="new_property"         , label="New property" }
					, related_prop          = { name="related_prop"         ,                                              control="objectpicker", maxLength="35", relatedto="someobject", relationship="many-to-one" }
					, another_property      = { name="another_property"     , type="date"   , label="My property" , dbtype="datetime", control="datepicker", required="true" }
					, some_numeric_property = { name="some_numeric_property", type="numeric", label="Numeric prop", dbtype="tinyint" , control="spinner"   , required="false", minValue="1", maxValue="10" }
				};

				expect( object.properties ).toBe( expectedResult );
			} );

			it( "should return a list of public method when component has public methods", function(){
				var targetObject    = new tests.resources.presideObjectReader.object_with_methods();
				var object          = getReader().readObject( targetObject );
				var expectedMethods = "method1,method2,method3";

				super.assert( StructKeyExists( object, 'methods' ), "No methods key was returned" );
				expect( object.methods ).toBe( expectedMethods );
			} );

			it( "should return specified dsn", function(){
				var targetObject = new tests.resources.presideObjectReader.simple_object_with_dsn();
				var object       = getReader().readObject( targetObject );

				super.assert( StructKeyExists( object, 'dsn' ), "No dsn key was was returned" );
				expect( object.dsn ).toBe( "different_dsn" );
			} );

			it( "should provide array of property names in order of definition in component", function(){
				var targetObject = new tests.resources.presideObjectReader.object_with_properties();
				var object       = getReader().readObject( targetObject );
				var expected     = [ "test_property","related_prop","another_property","some_numeric_property"];

				expect( expected ).toBe( object.propertyNames );
			} );

		} );

		describe( "getAutoPivotObjectDefinition()", function(){
			it( "should create object definition based on two source PK objects", function(){
				var reader = getReader();
				var objA = { meta = reader.readObject( new tests.resources.presideObjectReader.simple_object() ) };
				var objB = { meta = reader.readObject( new tests.resources.presideObjectReader.simple_object_with_prefix() ) };

				reader.finalizeMergedObject( objA );
				reader.finalizeMergedObject( objB );

				var expectedResult = {
					  dbFieldList = "source,target,sort_order"
					, dsn         = "default_dsn"
					, indexes     = { ux_mypivotobject = { unique=true, fields="source,target" } }
					, name        = "mypivotobject"
					, tablePrefix = "pobj_"
					, tableName   = "pobj_mypivotobject"
					, versioned   = true
					, properties  = {
						  source      = { name="source"    , control="auto", dbtype="varchar", maxLength="35", generator="none", relationship="many-to-one", relatedTo="simple_object"            , required=true, type="string", onDelete="cascade" }
						, target      = { name="target"    , control="auto", dbtype="varchar", maxLength="35", generator="none", relationship="many-to-one", relatedTo="simple_object_with_prefix", required=true, type="string", onDelete="cascade" }
						, sort_order  = { name="sort_order", control="auto", type="numeric" , dbtype="int" , maxLength="0", generator="none", relationship="none", required=false }
					  }
				};
				var autoObject = getReader().getAutoPivotObjectDefinition(
					  sourceObject       = objA.meta
					, targetObject       = objB.meta
					, pivotObjectName    = "mypivotobject"
					, sourcePropertyName = "source"
					, targetPropertyName = "target"
				);

				autoObject.properties = _propertiesToStruct( autoObject.properties );

				expect( expectedResult ).toBe( autoObject );
			} );
		} );
	}

// PRIVATE HELPERS
	private any function getReader( string dsn="default_dsn", tablePrefix="pobj_" ) {
		mockFeatureService = createEmptyMock( "preside.system.services.features.FeatureService" );

		return new preside.system.services.presideObjects.PresideObjectReader(
			  dsn                = arguments.dsn
			, tablePrefix        = arguments.tablePrefix
			, interceptorService = _getMockInterceptorService()
			, featureService     = mockFeatureService
		);
	}

	private struct function _propertiesToStruct( required any properties ) {
		var newProps = {};

		for( var key in arguments.properties ){
			newProps[ key ] = arguments.properties[ key ];
		}

		return newProps;
	}
}