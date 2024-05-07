#[test_only]
module art_craft_marketplace::test_marketplace {
    use sui::test_scenario::{Self as ts, next_tx, Scenario};
    use sui::transfer;
    use sui::test_utils::{assert_eq};
    use sui::coin::{mint_for_testing};
    use sui::object::{Self, UID};
    use sui::sui::SUI;
    use sui::vector::{Self};
    use std::string::{Self};
    use std::option::{Self, Option};
    
    use art_craft_marketplace::marketplace::{Self, Product, User, Transaction, AdminCap};

    const TEST_ADDRESS1: address = @0xB;
    const TEST_ADDRESS2: address = @0xC;

    #[test]
    public fun test_init_and_create_admin() {
        let scenario = ts::new();
        next_tx(scenario, TEST_ADDRESS1);

        // Initialize the marketplace
        marketplace::init(ts::ctx(scenario));

        // Check if AdminCap is created and transferred to TEST_ADDRESS1
        let admin_cap = ts::take_from_sender<AdminCap>(scenario);
        assert_eq(admin_cap.id != object::UID_NULL, true);
        
        ts::return_to_sender(scenario, admin_cap);
        ts::end(scenario);
    }

    #[test]
    public fun test_create_user() {
        let scenario = ts::new();
        next_tx(scenario, TEST_ADDRESS1);

        // Create a new user account
        let user = marketplace::new_user(
            string::utf8(b"John Doe"),
            string::utf8(b"john@example.com"),
            string::utf8(b"Artist"),
            ts::ctx(scenario)
        );

        // Verify user details
        assert_eq(user.name, string::utf8(b"John Doe"));
        assert_eq(user.email, string::utf8(b"john@example.com"));
        assert_eq(user.role, string::utf8(b"Artist"));

        ts::return_to_sender(scenario, user);
        ts::end(scenario);
    }

    #[test]
    public fun test_create_product() {
        let scenario = ts::new();
        next_tx(scenario, TEST_ADDRESS1);

        // Create a new product
        let product = marketplace::new_product(
            string::utf8(b"Handmade Vase"),
            string::utf8(b"A beautiful handmade vase."),
            1000,
            10,
            string::utf8(b"Craft"),
            string::utf8(b"John Doe"),
            ts::ctx(scenario)
        );

        // Verify product details
        assert_eq(product.name, string::utf8(b"Handmade Vase"));
        assert_eq(product.description, string::utf8(b"A beautiful handmade vase."));
        assert_eq(product.price, 1000);
        assert_eq(product.stock, 10);
        assert_eq(product.category, string::utf8(b"Craft"));
        assert_eq(product.artist, string::utf8(b"John Doe"));

        ts::return_to_sender(scenario, product);
        ts::end(scenario);
    }

    #[test]
    public fun test_transaction_and_purchase() {
        let scenario = ts::new();
        next_tx(scenario, TEST_ADDRESS1);

        // Create a new product
        let product = marketplace::new_product(
            string::utf8(b"Handmade Vase"),
            string::utf8(b"A beautiful handmade vase."),
            1000,
            10,
            string::utf8(b"Craft"),
            string::utf8(b"John Doe"),
            ts::ctx(scenario)
        );

        // Transfer product to the test address
        transfer::public_transfer(product, TEST_ADDRESS1);

        // Create a user account
        let buyer = marketplace::new_user(
            string::utf8(b"Jane Doe"),
            string::utf8(b"jane@example.com"),
            string::utf8(b"Customer"),
            ts::ctx(scenario)
        );

        // Mint some test coins to simulate a purchase
        let coins = mint_for_testing<SUI>(1000_000_000, ts::ctx(scenario));

        // Simulate a transaction
        next_tx(scenario, TEST_ADDRESS2);
        {
            let product = ts::take_from_sender<Product>(scenario);
            let buyer = ts::take_from_sender<User>(scenario);

            let transaction = marketplace::new_transaction(buyer, product, ts::ctx(scenario));
            assert_eq(transaction.buyer.name, string::utf8(b"Jane Doe"));
            assert_eq(transaction.product.name, string::utf8(b"Handmade Vase"));

            transfer::public_transfer(transaction, TEST_ADDRESS2);

            ts::return_to_sender(scenario, coins); // Return coins to reset scenario
        };

        ts::end(scenario);
    }
}
