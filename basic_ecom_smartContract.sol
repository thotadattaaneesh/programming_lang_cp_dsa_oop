//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
contract Ecommerce{

    // Product information is a struct and it contains title, description, seller information
    // buyer information, product ID, price of the product, status of whether it is delivered
    // to the buyer or not.
    struct Product {
        string title;
        string desc;
        address payable seller;
        address buyer;
        uint productId;
        uint price;
        bool delivered;
    }

    // manager is the person who have full control over the smart contract
    // and he is the one who deploys it.
    address payable public manager;
    bool destroyed = false;

    // A modifier which checks whether the contract is still alive or destroyed
    modifier isNotDestroyed{
        require(!destroyed, "contract doesn't exist");
        _;
    }

    // A constructor which runs only once in the beginning and sets the msg.sender to the manager.
    constructor(){
        manager = payable(msg.sender);
    }

    // products is the dynamic array of all the products available in the store.
    Product[] public products;
    // counter to increment the id of the product.
    uint counter = 1;

    // Below 3 are the events which returns whether the products are registered, bought, delivered
    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    // Function for registering a product.
    function registerProduct(string memory _title, string memory _desc, uint _price) public isNotDestroyed{
        require(_price > 0, "Product price must be greater than 0.");
        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.desc = _desc;
        tempProduct.price = _price * 10**18; //converting ether into wei
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter;
        products.push(tempProduct);
        counter++;
        emit registered(_title, tempProduct.productId, msg.sender);
    }

    // Function for buying a product.
    function buy(uint _productId) payable public isNotDestroyed{
        require(products[_productId-1].price == msg.value, "Please Pay the exact price.");
        require(products[_productId-1].seller != msg.sender, "Seller cannot buy the product.");
        products[_productId-1].buyer = msg.sender;
        emit bought(_productId, msg.sender);
    }

    function delivery(uint _productId) public{
        require(products[_productId-1].buyer == msg.sender, "Only buyer can confirm this.");
        products[_productId-1].delivered = true;
        products[_productId-1].seller.transfer(products[_productId-1].price);
        emit delivered(_productId);
    }

    function destroy() public {
        require(msg.sender == manager, "Only manager can destory the smart contract");
        // selfdestruct(manager);
        manager.transfer(address(this).balance);
        destroyed = true;
    }

    fallback() payable external{
        payable(msg.sender).transfer(msg.value);
    }

}
