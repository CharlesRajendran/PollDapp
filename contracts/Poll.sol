pragma solidity ^0.4.20;
// pragma experimental ABIEncoderV2;

contract Poll {
    
    // structures (entities)
    struct UserStruct {
        address addr;
        string username;
        uint age;
        string email;
        string country;
    }
    
    struct PollStruct {
        uint pollid;
        string title;
        string description;
        UserStruct conductor;
        // PollOptionsStruct[] answers;
    }
    
    // struct PollOptionsStruct {
    //     uint ansid;
    //     string content;
    // }
    
    
    // modifiers
    modifier contractOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier pollConductor {
        require(1 == 1);
        _;
    }
    
    modifier registeredUser {
        require(isUserRegistered());
        _;
    }
    
    // variables
    address private owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    // arrays
    UserStruct[] users;
    PollStruct[] pools;
    
    // mappings
    mapping(uint => PollStruct) poolMap;
    mapping(address => UserStruct) userMap;
    // mapping(uint => PollOptionsStruct[]) pollOptionsMap; 
    
    // events
    event UserRegisterdEv(string username, uint age, string email, string country);
    event PollCreatedEv(uint pollid, string title, string description, string conductor);
    
    // functions
    function createPoll(string _title, string _description) public registeredUser returns (bool success) {
        uint _pollid = pools.length + 1;
        
        PollStruct memory newpool;
        newpool.pollid = _pollid;
        
        newpool.title = _title;
        newpool.description = _description;
        
        UserStruct currentUser = userMap[msg.sender];
        newpool.conductor = currentUser;
        
        
        // PollOptionsStruct[] _answers;
        
        // newpool.answers = _answers;
        
        // push to array and map
        pools.push(newpool);
        poolMap[_pollid] = newpool;
        
        // poll created event 
        PollCreatedEv(newpool.pollid, newpool.title, newpool.description, newpool.conductor.username);
        
        success = true;
    } 
    
    function registerUser(string _username, uint _age, string _email, string _country) public returns (bool success) {
        UserStruct memory currentUser;
        
        currentUser.addr = msg.sender;
        currentUser.username = _username;
        currentUser.age = _age;
        currentUser.email = _email;
        currentUser.country = _country;
        
        // push to array and map
        users.push(currentUser);
        userMap[msg.sender] = currentUser;
        
        // event for UI
        UserRegisterdEv(currentUser.username, currentUser.age, currentUser.email, currentUser.country);
        
        success = true;
    }
    
    function addOptions() public pollConductor returns (bool success) {
        success = true;
    }
    
    // utility methods
    
    function isUserRegistered() private returns (bool) {
        for(uint i=0; i < users.length; i++) {
            if (users[i].addr == msg.sender) {
                return true;
            }
        }
        return false;
    }
    
    function listOfUsers() contractOwner public returns (UserStruct[]) {
        return users;
    }
    
}
