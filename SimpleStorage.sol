// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;     // ^ indicates 0.8.7 and above is ok for this contract

contract SimpleStorage {

    // @notice This gets iniialized to zero by default.
    // @notice If the scope of state variable is not defined, the default scope is "internal".
    uint256 favoriteNumber;

    mapping ( string => uint256 ) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    // @notice One way to create an instance of type People
    People public person1 = People(5, "Amit");

    // @notice One more way to create an instance of type People
    People public person2 = People({favoriteNumber: 12, name: "Jignesh"});

    // @notice way to create multiple instance of people
    // @notice 3 main storage locations - calldata, memory, storage
    // @notice calldata are temporary variables that can't be modified
    // @notice memory are teamprary variables that can be modified
    // @notice storage is permanent
    // @notice Data location can only be specified for array, struct or mapping types
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // people.push(People(_favoriteNumber, _name));
        People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        people.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }


    /** @notice Example using calldata

    function addPerson(string calldata _name, uint256 _favoriteNumber) public {
        _name = "any";             // Not possible and hence error as calldata variable cannot be modified.
    }

    */

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
}