module my_address::SimpleToken{
    use std::string::String;
    use aptos_std::table;
    #[test_only]
    use std::string;
    #[test_only]
    use aptos_std::simple_map;
    #[test_only]
    use aptos_token::property_map;
    #[test_only]
    use aptos_std::debug;


    struct TableHolder has key{
        value:table::Table<String,String>
    }

    #[test(sender=@my_address)]
    fun table_test(sender:&signer){
        let table = table::new<String,String>();
        table::add(&mut table,string::utf8(b"name"),string::utf8(b"nb"));
        table::add(&mut table,string::utf8(b"address"),string::utf8(b"house"));

        assert!(table::contains(&table,string::utf8(b"name")),0);
        assert!(table::contains(&table,string::utf8(b"address")),0);

        table::remove(&mut table,string::utf8(b"address"));
        assert!(!table::contains(&table,string::utf8(b"address")),0);

        table::upsert(&mut table,string::utf8(b"address"),string::utf8(b"house"));
        assert!(table::contains(&table,string::utf8(b"address")),0);

        move_to(sender,TableHolder{
            value:table
        });
    }

    #[test]
    fun simple_map_test(){
        let simple_map = simple_map::create<String,u8>();
        simple_map::add(&mut simple_map,string::utf8(b"key1"),1);
        simple_map::add(&mut simple_map,string::utf8(b"key2"),2);
        assert!(simple_map::contains_key(&mut simple_map,&string::utf8(b"key1")),0);

        let ke1 = simple_map::borrow_mut(&mut simple_map,&string::utf8(b"key1"));
        *ke1 = 2;
        assert!(simple_map::contains_key(&mut simple_map,&string::utf8(b"key1")),0);
        assert!(*simple_map::borrow(&mut simple_map,&string::utf8(b"key1")) == 2 , 0);

        assert!(simple_map::length(&mut simple_map) == 2 , 0);

        simple_map::remove(&mut simple_map,&string::utf8(b"key1"));
        assert!(simple_map::length(&mut simple_map) == 1 , 0);

    }


    #[test]
    fun property_map_test(){
        let keys = vector<String>[string::utf8(b"key1"),string::utf8(b"key2"),string::utf8(b"key3")];
        let values = vector<vector<u8>>[b"a",x"36cf204b5594508e71cfcf77718cbf64ddeea04c03680c6dacc6e641291a26ab",b"a"];
        let types = vector<String>[string::utf8(b"u8"),string::utf8(b"address"),string::utf8(b"u64")];
        let pm = property_map::new(
            keys,values,types
        );
        assert!(property_map::length(&pm) == 3,0);
        assert!(property_map::contains_key(&pm,&string::utf8(b"key2")),0);

        let value1 = property_map::read_u8(&pm,&string::utf8(b"key1"));
        let value2 = property_map::read_address(&pm,&string::utf8(b"key2"));
        debug::print(&value1);
        debug::print(&value2);
        assert!(value2 == @my_address,0);
    }


}
