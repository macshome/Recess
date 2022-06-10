
func isInt(_ input: Any) -> Bool {
    if type(of: input.self) == Int.self {
        return true
    }
    return false
}

isInt(2)

func exists(_ input: Any? = nil) -> Bool {
    if input != nil {
        return true
    }
    return false
}

exists("foo")
exists()
