struct Either <L, R> {
    let left: L?
    let right: R?
    
    init(left: L?, right: R?) {
        self.left = left
        self.right = right
    }
    
    static func left(left : L) -> Either<L, R> {
        return Either(left: left, right: nil)
    }
    
    static func right(right : R) -> Either<L, R> {
        return Either(left: nil, right: right)
    }
    
    func either() -> Bool {
        return (self.left != nil) || (self.right != nil)
    }
    
    func isLeft() -> Bool {
        return self.left != nil
    }

    func isRight() -> Bool {
        return self.right != nil
    }

}
