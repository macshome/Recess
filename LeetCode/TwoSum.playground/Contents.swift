import Foundation

class Solution {

    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        for (index, num) in nums.enumerated() {
            guard let diffIndex = nums.firstIndex(of: target - num),
                  diffIndex < index else {
                continue
            }
            return [index, diffIndex]
        }
        return []
    }
}


let start = Date()
Solution().twoSum([2, 7, 11, 15], 9)
Solution().twoSum([3,2,4], 6)
Solution().twoSum([3,3], 6)
let total = Date().timeIntervalSince(start)

