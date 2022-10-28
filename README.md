# Aptos-Simple-Token

table.move

simple_map.move

property_map.move



token.move


结构层级关系：

* Collections

  * collection_data: Table<String, CollectionData>

    * Table: name为key，CollectionData为value

    * ```rust
      /// Represent the collection metadata
          struct CollectionData has store {
              // Describes the collection
              description: String,
              // Unique name within this creators account for this collection
              name: String,
              // URL for additional information /media
              uri: String,
              // Total number of distinct token_data tracked by the collection
              supply: u64,
              // maximum number of token_data allowed within this collections
              maximum: u64,
              // control which collection field is mutable
              mutability_config: CollectionMutabilityConfig,
          }
      ```

  * token_data: Table<TokenDataId, TokenData>,

    * Table: TokenDataId为key，TokenData为value

    * ```rust
       /// globally unique identifier of tokendata
          struct TokenDataId has copy, drop, store {
              // The creator of this token
              creator: address,
              // The collection or set of related tokens within the creator's account
              collection: String,
              // the name of this token
              name: String,
          }
      ```

    * ```rust
      /// The shared TokenData by tokens with different property_version
          struct TokenData has store {
              // the maxium of tokens can be minted from this token
              maximum: u64,
              // the current largest property_version
              largest_property_version: u64,
              // Total number of tokens minted for this TokenData
              supply: u64,
              // URL for additional information / media
              uri: String,
              // the royalty of the token
              royalty: Royalty,
              // The name of this Token
              name: String,
              // Describes this Token
              description: String,
              // store customized properties and their values for token with property_version 0
              default_properties: PropertyMap,
              //control the TokenData field mutability
              mutability_config: TokenMutabilityConfig,
          }
      
      ```

发行NFT案例
```rust
struct MintingNFT has key {
        minter_cap:SignerCapability,
        token_data_id:TokenDataId,
        expiration_timestamp: u64,
        uintprice:u64,
    }
```
      



