component extends="tests.resources.HelperObjects.PresideBddTestCase" {

	public void function run() {
		describe( "listCloneableFields()", function(){
			it( "should, by default, return all fields that are not system fields, oneToMany relationships or formula fields and have no unique indexes", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectProperties" ).$args( objectName=objectName ).$results({
					  _id           = {}
					, label         = { uniqueindexes="label" }
					, _datecreated  = {}
					, _datemodified = {}
					, test          = { type="boolean", uniqueindexes="" }
					, fubar         = { relationship="many-to-one", relatedto="fubar", uniqueindexes="" }
					, crikey        = { relationship="many-to-many", relatedto="fubar", relatedvia="crikey_crumbs" }
					, oneToMany     = { relationship="one-to-many", relatedto="dang", relationshipKey="test" }
					, blah          = { formula="test" }
				});

				var cloneableFields = service.listCloneableFields( objectName );
				cloneableFields.sort( "textnocase" );

				expect( cloneableFields ).toBe( [ "crikey", "fubar", "test" ] );
			} );

			it( "should allow unique index fields and one-to-many relationships IF cloneable=true is specified on the property", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectProperties" ).$args( objectName=objectName ).$results({
					  label     = { uniqueindexes="label", cloneable=true }
					, oneToMany = { relationship="one-to-many", relatedto="dang", relationshipKey="test", cloneable=true }
				});

				var cloneableFields = service.listCloneableFields( objectName );
				cloneableFields.sort( "textnocase" );

				expect( cloneableFields ).toBe( [ "label", "oneToMany" ] );
			} );

			it( "should disallow ANY fields that have cloneable=false", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectProperties" ).$args( objectName=objectName ).$results({
					  _id           = {}
					, label         = { uniqueindexes="label" }
					, _datecreated  = {}
					, _datemodified = {}
					, test          = { type="boolean", uniqueindexes="", cloneable=false }
					, fubar         = { relationship="many-to-one", relatedto="fubar", uniqueindexes="", cloneable=false }
					, crikey        = { relationship="many-to-many", relatedto="fubar", relatedvia="crikey_crumbs", cloneable=false }
					, oneToMany     = { relationship="one-to-many", relatedto="dang", relationshipKey="test" }
					, blah          = { formula="test" }
				});

				var cloneableFields = service.listCloneableFields( objectName );
				cloneableFields.sort( "textnocase" );

				expect( cloneableFields ).toBe( [] );
			} );
		} );

		describe( "isCloneable()", function(){
			it( "should return false if the object has @clonable=false annotation", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectAttribute" ).$args( objectName=objectName, attributeName="cloneable" ).$results( false );

				expect( service.isCloneable( objectName ) ).toBeFalse();
			} );

			it( "should return true if the object has @clonable=true annotation and has one or more cloneable attributes", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectAttribute" ).$args( objectName=objectName, attributeName="cloneable" ).$results( true );
				service.$( "listCloneableFields" ).$args( objectName=objectName ).$results( [ "more", "than", "zero" ] );

				expect( service.isCloneable( objectName ) ).toBeTrue();
			} );

			it( "should return true if the object does not specify @clonable annotation and has one or more cloneable attributes", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectAttribute" ).$args( objectName=objectName, attributeName="cloneable" ).$results( "" );
				service.$( "listCloneableFields" ).$args( objectName=objectName ).$results( [ "more", "than", "zero" ] );

				expect( service.isCloneable( objectName ) ).toBeTrue();
			} );

			it( "should return false if the object does not specify @clonable annotation but has no cloneable attributes", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectAttribute" ).$args( objectName=objectName, attributeName="cloneable" ).$results( "" );
				service.$( "listCloneableFields" ).$args( objectName=objectName ).$results( [] );

				expect( service.isCloneable( objectName ) ).toBeFalse();
			} );

			it( "should return false if the object  has @clonable=true annotation but has no cloneable attributes", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";

				mockPresideObjectService.$( "getObjectAttribute" ).$args( objectName=objectName, attributeName="cloneable" ).$results( true );
				service.$( "listCloneableFields" ).$args( objectName=objectName ).$results( [] );

				expect( service.isCloneable( objectName ) ).toBeFalse();
			} );
		} );

		describe( "getCloneHandler()", function(){
			it( "return handler event specified in @cloneHandler annotation on the object", function(){
				var service    = _getService();
				var objectName = "SomeObject#CreateUUId()#";
				var cloneHandler = "some.handler.here.#CreateUUId()#";

				mockPresideObjectService.$( "getObjectAttribute" ).$args( objectName=objectName, attributeName="cloneHandler" ).$results( cloneHandler );

				expect( service.getCloneHandler( objectName ) ).toBe( cloneHandler );
			} );
		} );

		describe( "cloneRecord()", function(){
			it( "should do stuff", function(){
				fail( "but not yet implemented" );
			} );
		} );
	}

	private any function _getService() {
		mockPresideObjectService = CreateEmptyMock( "preside.system.services.presideObjects.PresideObjectService" );

		mockPresideObjectService.$( "getIdField"          , "_id" );
		mockPresideObjectService.$( "getDateCreatedField" , "_datecreated" );
		mockPresideObjectService.$( "getDateModifiedField", "_datemodified" );

		var service = CreateMock( object = new preside.system.services.presideObjects.PresideObjectCloningService() );

		service.$( "$getPresideObjectService", mockPresideObjectService );

		return service;
	}

}