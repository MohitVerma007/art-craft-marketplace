module ArtCraft::game {
    use std::string::{String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext, sender};
    use sui::kiosk::{Self, KioskOwnerCap};
    use sui::transfer_policy::{Self as tp};
    use sui::package::{Self, Publisher};
    // Product struct representing an NFT
    struct Product has key, store {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        category: String,  // Category such as "Art", "Craft", etc.
        artist: address,    // Artist or Craftsperson address
    }
    /// Publisher capability object
    struct ProductPublisher has key {
        id: UID,
        publisher: Publisher
    }
    // One time witness
    struct GAME has drop {}
    // Only owner of this module can access it.
    struct AdminCap has key {
        id: UID,
    }
    // =================== Initializer ===================
    fun init(otw: GAME, ctx: &mut TxContext) {
        // Define the publisher
        let publisher_ = package::claim<GAME>(otw, ctx);
        // Wrap the publisher and share.
        transfer::share_object(ProductPublisher {
            id: object::new(ctx),
            publisher: publisher_
        });
        // Transfer the AdminCap
        transfer::transfer(AdminCap{id: object::new(ctx)}, tx_context::sender(ctx));
    }
    /// Users can create a new kiosk for the marketplace
    public fun new(ctx: &mut TxContext) : KioskOwnerCap {
        let (kiosk, kiosk_cap) = kiosk::new(ctx);
        // Share the kiosk
        transfer::public_share_object(kiosk);
        kiosk_cap
    }
    // Create a new transfer policy for rules
    public fun new_policy(publish: &ProductPublisher, ctx: &mut TxContext) {
        // Set the publisher
        let publisher = get_publisher(publish);
        // Create a transfer_policy and tp_cap
        let (transfer_policy, tp_cap) = tp::new<Product>(publisher, ctx);
        // Transfer the objects
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));
        transfer::public_share_object(transfer_policy);
    }
    // Function to create a new product NFT
    public fun new_product(name: String, description: String, price: u64, stock: u64, category: String, ctx: &mut TxContext) : Product {
        let id_ = object::new(ctx);
        let product = Product {
            id: id_,
            name,
            description,
            price,
            stock,
            category,
            artist: sender(ctx),
        };
        product
    }
    // =================== Helper Functions ===================
    // Return the publisher
    fun get_publisher(shared: &ProductPublisher) : &Publisher {
        &shared.publisher
    }
    #[test_only]
    // Call the init function
    public fun test_init(ctx: &mut TxContext) {
        init(GAME {}, ctx);
    }
}