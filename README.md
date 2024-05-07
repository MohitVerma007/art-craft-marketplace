# ArtCraft Marketplace Module
This module provides functionalities for managing a simple marketplace for art and craft items. The module allows the creation, update, and deletion of products, users, and transactions. Below is a detailed description of the structures and functions provided by the module.

## Structures
- **Product**: Represents an item for sale in the marketplace.
  - `id`: Unique identifier for the product.
  - `name`: Name of the product.
  - `description`: Description of the product.
  - `price`: Price of the product.
  - `stock`: Available quantity.
  - `category`: Category of the product (e.g., "Art", "Craft").
  - `artist`: Name of the artist or craftsperson who created the product.
- **User**: Represents a user in the marketplace.
  - `id`: Unique identifier for the user.
  - `name`: Name of the user.
  - `email`: Email address of the user.
  - `role`: Role of the user in the marketplace (e.g., "Artist", "Customer").
- **AdminCap**: Represents an admin capability.
  - `id`: Unique identifier for the admin capability.
- **Transaction**: Represents a transaction in the marketplace.
  - `id`: Unique identifier for the transaction.
  - `buyer`: The user who is buying a product.
  - `product`: The product being purchased.
  - `timestamp`: Timestamp of the transaction.

## Functions
### Initialization
- **`init(ctx: &mut TxContext)`**: Initializes the module and creates an `AdminCap`. The `AdminCap` is transferred to the context's sender.
  
### Product Operations
- **`new_product(name: String, description: String, price: u64, stock: u64, category: String, artist: String, ctx: &mut TxContext) -> Product`**: Creates a new product in the marketplace.
- **`get_product(product: &Product) -> &Product`**: Retrieves the details of a product.
- **`update_product_name(product: &mut Product, new_name: String)`**: Updates the name of a product.
- **`update_product_price(product: &mut Product, new_price: u64)`**: Updates the price of a product.
- **`update_product_stock(product: &mut Product, new_stock: u64)`**: Updates the stock of a product.
- **`update_product_description(product: &mut Product, new_description: String)`**: Updates the description of a product.
- **`delete_product(product: Product)`**: Deletes a product from the marketplace.
  
### User Operations
- **`new_user(name: String, email: String, role: String, ctx: &mut TxContext) -> User`**: Creates a new user in the marketplace.
- **`get_user(user: &User) -> &User`**: Retrieves the details of a user.
- **`update_user_name(user: &mut User, new_name: String)`**: Updates the name of a user.
- **`update_user_email(user: &mut User, new_email: String)`**: Updates the email of a user.
- **`update_user_role(user: &mut User, new_role: String)`**: Updates the role of a user.
- **`delete_user(user: User)`**: Deletes a user from the marketplace.

### Transaction Operations
- **`new_transaction(buyer: User, product: Product, ctx: &mut TxContext) -> Transaction`**: Creates a new transaction in the marketplace.
- **`get_transaction(transaction: &Transaction) -> &Transaction`**: Retrieves the details of a transaction.

## Contributing
Contributions to the module are welcome. To contribute, please create a pull request with your proposed changes. Ensure that your code follows best practices and is properly documented.


We hope this README helps you understand the module's structure and how to use it. If you have any feedback, feel free to reach out!

## Dependency

- This DApp relies on the Sui blockchain framework for its smart contract functionality.
- Ensure you have the Move compiler installed and configured to the appropriate framework (e.g., `framework/devnet` for Devnet or `framework/testnet` for Testnet).

```bash
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }
```

## Installation

Follow these steps to deploy and use the Charity Donation Platform:

1. **Move Compiler Installation:**
   Ensure you have the Move compiler installed. Refer to the [Sui documentation](https://docs.sui.io/) for installation instructions.

2. **Compile the Smart Contract:**
   Switch the dependencies in the `Sui` configuration to match your chosen framework (`framework/devnet` or `framework/testnet`), then build the contract.

   ```bash
   sui move build
   ```

3. **Deployment:**
   Deploy the compiled smart contract to your chosen blockchain platform using the Sui command-line interface.

   ```bash
   sui client publish --gas-budget 100000000 --json
   ```

## Note

- Logs (`2024-04-19T08_52_35_994Z-debug-0.log` and `2024-04-19T08_52_35_994Z-eresolve-report.txt`) may provide more specific information about the problem.