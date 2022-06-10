import CoreFoundation

let s1 = Set([1,2,3])
let s2 = Set([4,5,6])
let s3 = Set([s1, s2])

s3.isSuperset(of: s3) && s3.isSubset(of: s3)
s3.contains(s1) && s3.contains(s2)

