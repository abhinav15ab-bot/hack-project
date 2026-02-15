// pragma solidity ^0.8.19;

// contract ChainShield {
//     // Structure of a protection event
//     struct Protection {
//         address user;        // Who was protected
//         uint256 timestamp;   // When
//         uint256 healthBefore; // Risk level before
//         uint256 healthAfter;  // Safety level after
//         string chain;        // Which chain triggered
//         uint256 panicScore;  // Panic level at time
//     }
    
//     // Store all protections
//     Protection[] public protections;
//     mapping(address => uint256[]) public userProtections;
    
//     // Event that can be watched
//     event GoldenAppleActivated(
//         address indexed user,
//         uint256 timestamp,
//         uint256 healthBefore,
//         uint256 panicScore
//     );
    
//     // Function to record a protection
//     function recordProtection(
//         address user,
//         uint256 healthBefore,
//         uint256 healthAfter,
//         string memory chain,
//         uint256 panicScore
//     ) external {
//         Protection memory newProtection = Protection(
//             user,
//             block.timestamp,
//             healthBefore,
//             healthAfter,
//             chain,
//             panicScore
//         );
        
//         protections.push(newProtection);
//         userProtections[user].push(protections.length - 1);
        
//         emit GoldenAppleActivated(
//             user,
//             block.timestamp,
//             healthBefore,
//             panicScore
//         );
//     }
    
//     // Get total protections
//     function getTotalProtections() external view returns (uint256) {
//         return protections.length;
//     }
    
//     // Get user's protections
//     function getUserProtections(address user) 
//         external 
//         view 
//         returns (uint256[] memory) 
//     {
//         return userProtections[user];
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ChainShield Protection Registry
/// @notice This contract records every automatic "Golden Apple" protection event on-chain.
/// @dev Provides an immutable and transparent log of all user protections.
contract ChainShield {

    /// @dev Structure containing details of a single protection event.
    struct Protection {
        address user;        // The address of the user who was protected
        uint256 timestamp;   // The time the protection was triggered
        uint256 healthBefore; // The user's health factor before protection (0-100)
        uint256 healthAfter;  // The user's health factor after protection (0-100)
        string chain;        // The blockchain where the risk was detected (e.g., "ethereum")
        uint256 panicScore;  // The social sentiment panic score at the time (0-100)
    }

    /// @dev Array storing all protection events in order.
    Protection[] public protections;
    
    /// @dev Mapping from user address to array of indices in the protections array.
    mapping(address => uint256[]) public userProtections;

    /// @dev Emitted when a golden apple protection is activated.
    /// @param user The address that was protected.
    /// @param timestamp The time of the protection.
    /// @param healthBefore The health before protection.
    /// @param panicScore The panic score that contributed to the trigger.
    event GoldenAppleActivated(
        address indexed user, 
        uint256 timestamp, 
        uint256 healthBefore, 
        uint256 panicScore
    );

    /// @notice Records a new protection event on the blockchain.
    /// @dev This function is called by our backend bot when protection conditions are met.
    /// @param user The address of the user being protected.
    /// @param healthBefore The user's health percentage before protection (e.g., 58).
    /// @param healthAfter The user's health percentage after protection (e.g., 85).
    /// @param chain The name of the chain where the risk occurred (e.g., "ethereum").
    /// @param panicScore The social sentiment panic score that triggered the event.
    function recordProtection(
        address user,
        uint256 healthBefore,
        uint256 healthAfter,
        string memory chain,
        uint256 panicScore
    ) external {
        // Create new Protection struct
        Protection memory newProtection = Protection(
            user,
            block.timestamp,
            healthBefore,
            healthAfter,
            chain,
            panicScore
        );
        
        // Add to protections array
        protections.push(newProtection);
        
        // Record this protection index for the user
        userProtections[user].push(protections.length - 1);
        
        // Emit event for frontend to listen to
        emit GoldenAppleActivated(
            user,
            block.timestamp,
            healthBefore,
            panicScore
        );
    }

    /// @notice Returns the total number of protection events ever recorded.
    /// @return The total count of protections.
    function getTotalProtections() external view returns (uint256) {
        return protections.length;
    }

    /// @notice Gets all protection indices for a specific user.
    /// @param user The address to query.
    /// @return An array of indices in the protections array.
    function getUserProtectionIndices(address user) 
        external 
        view 
        returns (uint256[] memory) 
    {
        return userProtections[user];
    }

    /// @notice Gets a specific protection event by its index.
    /// @param index The index in the protections array.
    /// @return The Protection struct at that index.
    function getProtectionByIndex(uint256 index) 
        external 
        view 
        returns (Protection memory) 
    {
        require(index < protections.length, "Invalid index");
        return protections[index];
    }

    /// @notice Gets all protection events for a specific user.
    /// @param user The address to query.
    /// @return An array of Protection structs for that user.
    function getUserProtections(address user) 
        external 
        view 
        returns (Protection[] memory) 
    {
        uint256[] memory indices = userProtections[user];
        Protection[] memory userEvents = new Protection[](indices.length);
        
        for (uint256 i = 0; i < indices.length; i++) {
            userEvents[i] = protections[indices[i]];
        }
        
        return userEvents;
    }

    /// @notice Gets the latest protection event for a user.
    /// @param user The address to query.
    /// @return The most recent Protection struct or empty if none.
    function getLatestUserProtection(address user) 
        external 
        view 
        returns (Protection memory) 
    {
        uint256[] memory indices = userProtections[user];
        require(indices.length > 0, "No protections for user");
        return protections[indices[indices.length - 1]];
    }
}