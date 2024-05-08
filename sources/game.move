module ArtCraft::game {
    use std::string::{String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext, sender};
    use sui::kiosk::{Self, KioskOwnerCap};
    use sui::transfer_policy::{Self as tp};
    use sui::package::{Self, Publisher};

    // Picture struct representing an NFT
    struct Product has key {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        category: String,  // Category such as "Art", "Craft", etc.
        artist: address,    // Artist or Craftsperson name
    }
    
    /// Publisher capability object
    struct PicturePublisher has key { id: UID, publisher: Publisher }

     // one time witness 
    struct GAME has drop {}

    // Only owner of this module can access it.
    struct AdminCap has key {
        id: UID,
    }

    // =================== Initializer ===================
    fun init(otw: GAME, ctx: &mut TxContext) {
        // define the publisher
        let publisher_ = package::claim<GAME>(otw, ctx);
        // wrap the publisher and share.
        transfer::share_object(PicturePublisher {
            id: object::new(ctx),
            publisher: publisher_
        });
        // transfer the admincap
        transfer::transfer(AdminCap{id: object::new(ctx)}, tx_context::sender(ctx));
    }

    /// Users can create new kiosk for marketplace 
    public fun new(ctx: &mut TxContext) : KioskOwnerCap {
        let(kiosk, kiosk_cap) = kiosk::new(ctx);
        // share the kiosk
        transfer::public_share_object(kiosk);
        kiosk_cap
    }
    // create any transferpolicy for rules 
    public fun new_policy(publish: &PicturePublisher, ctx: &mut TxContext ) {
        // set the publisher
        let publisher = get_publisher(publish);
        // create an transfer_policy and tp_cap
        let (transfer_policy, tp_cap) = tp::new<Product>(publisher, ctx);
        // transfer the objects 
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));
        transfer::public_share_object(transfer_policy);
    }
    // Function to create a new Picture NFT
    public fun new_product(uri: String, name: String, description: String, price: u64, stock: u64, category: String, ctx: &mut TxContext) : Product {
        let id_ = object::new(ctx);

        let picture = Product {
            id: id_,
            name,
            description,
            price,
            stock,
            category,
            artist: sender(ctx),
        };
        picture 
    }

    // =================== Helper Functions ===================

    // return the publisher
    fun get_publisher(shared: &PicturePublisher) : &Publisher {
        &shared.publisher
     }

    #[test_only]
    // call the init function
    public fun test_init(ctx: &mut TxContext) {
        init(GAME {}, ctx);
    }
}