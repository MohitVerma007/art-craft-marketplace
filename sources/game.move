module art_craft_marketplace::marketplace {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::package::{Self, Publisher};
    use sui::transfer;
    use std::string::{String};

    // Represents a product in the marketplace
    struct Product has key {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        category: String,  // Category such as "Art", "Craft", etc.
        artist: String,    // Artist or Craftsperson name
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
        let admin_cap = AdminCap { id: object::new(ctx) };
        transfer::transfer(admin_cap, tx_context::sender(ctx));
    }

    // =================== Product Operations ===================

    // Create a new product
    public fun new_product(
        name: String,
        description: String,
        price: u64,
        stock: u64,
        category: String,
        artist: String,
        ctx: &mut TxContext
    ): Product {
        Product {
            id: object::new(ctx),
            name,
            description,
            price,
            stock,
            category,
            artist,
        }
    }

    // Get product details
    public fun get_product(product: &Product): &Product {
        product
    }

    // Update product details
    public fun update_product_name(product: &mut Product, new_name: String) {
        product.name = new_name;
    }

    public fun update_product_price(product: &mut Product, new_price: u64) {
        product.price = new_price;
    }

    public fun update_product_stock(product: &mut Product, new_stock: u64) {
        product.stock = new_stock;
    }

    public fun update_product_description(product: &mut Product, new_description: String) {
        product.description = new_description;
    }

    // Delete a product
    public fun delete_product(product: Product) {
        object::delete(product.id);
    }

    // =================== User Operations ===================

    // Create a new user
    public fun new_user(name: String, email: String, role: String, ctx: &mut TxContext): User {
        User {
            id: object::new(ctx),
            name,
            email,
            role,
        }
    }

    // Get user details
    public fun get_user(user: &User): &User {
        user
    }

    // Update user details
    public fun update_user_name(user: &mut User, new_name: String) {
        user.name = new_name;
    }

    public fun update_user_email(user: &mut User, new_email: String) {
        user.email = new_email;
    }

    public fun update_user_role(user: &mut User, new_role: String) {
        user.role = new_role;
    }

    // Delete a user
    public fun delete_user(user: User) {
        object::delete(user.id);
    }

    // =================== Transaction Operations ===================

    // Create a new transaction
    public fun new_transaction(
        buyer: User,
        product: Product,
        ctx: &mut TxContext
    ): Transaction {
        Transaction {
            id: object::new(ctx),
            buyer,
            product,
            timestamp: ctx.timestamp(),
        }
    }

    // Get transaction details
    public fun get_transaction(transaction: &Transaction): &Transaction {
        transaction
    }
}
