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
        let user_id = marketplace::new_user(
            ts::ctx(scenario),
            string::utf8(b"John Doe"),
            string::utf8(b"john@example.com"),
            string::utf8(b"Artist")
        );

        // Fetch user details using the user_id
        let user = ts::fetch<User>(scenario, user_id);

        // Verify user details
        assert_eq(user.name, string::utf8(b"John Doe"));
        assert_eq(user.email, string::utf8(b"john@example.com"));
        assert_eq(user.role, string::utf8(b"Artist"));

        ts::end(scenario);
    }

    #[test]
    public fun test_create_product() {
        let scenario = ts::new();
        next_tx(scenario, TEST_ADDRESS1);

        // Artist's UID needs to be defined; simulate fetching artist user UID
        let artist_id = UID::new(ts::ctx(scenario)); // This should actually come from a created User

        // Create a new product
        let product_id = marketplace::new_product(
            ts::ctx(scenario),
            string::utf8(b"Handmade Vase"),
            string::utf8(b"A beautiful handmade vase."),
            1000,
            10,
            string::utf8(b"Craft"),
            artist_id
        );

        // Fetch product details using the product_id
        let product = ts::fetch<Product>(scenario, product_id);

        // Verify product details
        assert_eq(product.name, string::utf8(b"Handmade Vase"));
        assert_eq(product.description, string::utf8(b"A beautiful handmade vase."));
        assert_eq(product.price, 1000);
        assert_eq(product.stock, 10);
        assert_eq(product.category, string::utf8(b"Craft"));

        ts::end(scenario);
    }

    #[test]
    public fun test_transaction_and_purchase() {
        let scenario = ts::new();
        next_tx(scenario, TEST_ADDRESS1);

        let artist_id = UID::new(ts::ctx(scenario)); // This should actually come from a created User

        // Create a new product
        let product_id = marketplace::new_product(
            ts::ctx(scenario),
            string::utf8(b"Handmade Vase"),
            string::utf8(b"A beautiful handmade vase."),
            1000,
            10,
            string::utf8(b"Craft"),
            artist_id
        );

        // Transfer product to the test address
        transfer::public_transfer(product_id, TEST_ADDRESS1);

        // Create a user account
        let buyer_id = marketplace::new_user(
            ts::ctx(scenario),
            string::utf8(b"Jane Doe"),
            string::utf8(b"jane@example.com"),
            string::utf8(b"Customer")
        );

        // Mint some test coins to simulate a purchase
        let coins = mint_for_testing<SUI>(1000_000_000, ts::ctx(scenario));

        // Simulate a transaction
        next_tx(scenario, TEST_ADDRESS2);
        {
            let transaction_id = marketplace::new_transaction(
                ts::ctx(scenario),
                buyer_id,
                product_id
            );

            let transaction = ts::fetch<Transaction>(scenario, transaction_id);

            assert_eq(ts::fetch<User>(scenario, transaction.buyer_id).name, string::utf8(b"Jane Doe"));
            assert_eq(ts::fetch<Product>(scenario, transaction.product_id).name, string::utf8(b"Handmade Vase"));

            ts::return_to_sender(scenario, coins); // Return coins to reset scenario
        };

        ts::end(scenario);
    }
}
