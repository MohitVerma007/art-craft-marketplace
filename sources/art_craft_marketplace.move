module art_craft_marketplace::marketplace {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::package::{Self, Publisher};
    use sui::transfer;
    use std::string::{String};

    const E_NOT_AUTHORIZED: u64 = 101;
    const E_INVALID_OPERATION: u64 = 102;
    const E_OUT_OF_STOCK: u64 = 103;

    // Represents a product in the marketplace
    struct Product has key {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        category: String,  // Category such as "Art", "Craft", etc.
        artist_id: UID,    // Reference to the artist's User ID
    }

    // Represents a user in the marketplace
    struct User has key {
        id: UID,
        name: String,
        email: String,
        role: String,  // "Artist" or "Customer"
    }

    // Represents an admin capability
    struct AdminCap has key {
        id: UID,
    }

    // Represents a transaction in the marketplace
    struct Transaction has key {
        id: UID,
        buyer: User,
        product: Product,
        timestamp: u64,
    }

    // =================== Initialization ===================

    // Initialize the module, create AdminCap
    public fun init(ctx: &mut TxContext) {
        let admin_cap = AdminCap { id: UID::new(ctx) };
        transfer::transfer(admin_cap, ctx.sender());
    }

    public fun assert_admin(admin_cap: &AdminCap, ctx: &TxContext) {
        assert!(ctx.sender() == admin_cap.id, E_NOT_AUTHORIZED);
    }

    // =================== Product Operations ===================

    // Create a new product
    public fun new_product(
        ctx: &mut TxContext,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        category: String,
        artist_id: UID
    ): UID {
        let product = Product {
            id: UID::new(ctx),
            name,
            description,
            price,
            stock,
            category,
            artist_id
        };
        UID::new(ctx)
    }

    // Get product details
    public fun get_product(product: &Product): &Product {
        product
    }

    // Update product details
    // Update product details, can be called only by admin or the artist who created the product
    public fun update_product(ctx: &TxContext, product_id: UID, new_name: Option<String>, new_price: Option<u64>, new_stock: Option<u64>, new_description: Option<String>, admin_cap: &AdminCap) {
        assert_admin(admin_cap, ctx);
        let mut product = product::borrow_mut(product_id);
        if let Some(name) = new_name { product.name = name; }
        if let Some(price) = new_price { product.price = price; }
        if let Some(stock) = new_stock { product.stock = stock; }
        if let Some(description) = new_description { product.description = description; }
    }

    // Delete a product, can only be done by an admin
    public fun delete_product(ctx: &TxContext, product_id: UID, admin_cap: &AdminCap) {
        assert_admin(admin_cap, ctx);
        UID::delete(product_id);
    }


    // =================== User Operations ===================

    // Create a new user
    // Create a new user
    public fun new_user(
        ctx: &mut TxContext,
        name: String,
        email: String,
        role: String
    ): UID {
        let user = User {
            id: UID::new(ctx),
            name,
            email,
            role,
        };
        UID::new(ctx)
    }

    // Get user details
    public fun get_user(user: &User): &User {
        user
    }

    // Update user details
    // Update user details, can only be done by the user themselves or an admin
    public fun update_user(ctx: &TxContext, user_id: UID, new_name: Option<String>, new_email: Option<String>, new_role: Option<String>, admin_cap: &AdminCap) {
        assert_admin(admin_cap, ctx);
        let mut user = user::borrow_mut(user_id);
        if let Some(name) = new_name { user.name = name; }
        if let Some(email) = new_email { user.email = email; }
        if let Some(role) = new_role { user.role = role; }
    }

    // Delete a user, can only be done by an admin
    public fun delete_user(ctx: &TxContext, user_id: UID, admin_cap: &AdminCap) {
        assert_admin(admin_cap, ctx);
        UID::delete(user_id);
    }

    // =================== Transaction Operations ===================

    // Create a new transaction
    public fun new_transaction(
        ctx: &mut TxContext,
        buyer_id: UID,
        product_id: UID
    ): UID {
        let transaction = Transaction {
            id: UID::new(ctx),
            buyer_id,
            product_id,
            timestamp: ctx.timestamp(),
        };
        UID::new(ctx)
    }
    
    // Get transaction details
    public fun get_transaction(transaction: &Transaction): &Transaction {
        transaction
    }
}
